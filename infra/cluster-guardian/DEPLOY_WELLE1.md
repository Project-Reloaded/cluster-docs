# Welle 1 — L0 Guardian-Floor: Deploy-Anleitung

> Ziel: OpenClaw (vm-100) und Hermes (vm-101) heilen den „hängt-aber-lebt"-Fall selbst.
> Beide haben schon `Restart=always` (Crash gedeckt) — L0 ergänzt die **funktionale** Erkennung.
> **Vorgehen: erst `report` (beobachten), dann `arm` (neu starten).**

## Discovery-Grundlage (2026-06-21, real geprüft)

| Host | Dienst | Health-Probe |
|---|---|---|
| vm-100 OpenClaw | `openclaw.service` (Gateway :18789, `Restart=always`) | HTTP `GET http://127.0.0.1:18789/health` → `{"ok":true,"status":"live"}` |
| vm-101 Hermes | `hermes-gateway.service` (Python, **kein** HTTP-Port — ausgehende Messaging-Integration, `Restart=always`); `hermes-studio.service` (:3002) | proc: `pgrep -f hermes-agent/venv/bin/python` + Subcheck Studio `http://127.0.0.1:3002/` |

Hinweis (Stand 2026-06-21): Beim Hermes-Gateway war „hängt-aber-lebt" über HTTP NICHT erkennbar (kein Endpoint). L0-Hermes deckte daher nur Prozess-Tod + Studio-Ausfall — **unzureichend** (siehe Welle 1.1).

> **⚠️ ÜBERHOLT durch Welle 1.1 (2026-06-30):** Das Gateway betreibt seit dem Cowork-:8642-Fix einen **In-Process-HTTP-Server auf 127.0.0.1:8642** (Socket gehört dem Gateway-MainPID). `/health` → `{"status":"ok","platform":"hermes-agent",...}`, 200, ohne Auth, ~1 ms. Damit ist `proc`-Mode obsolet → Hermes nutzt jetzt **`http`-Mode auf :8642/health** (genau wie OpenClaw). Details unten in „Welle 1.1".

## Dateien (aus diesem Ordner)

- `cluster-guardian.sh` → `/opt/cluster-guardian/cluster-guardian.sh` (chmod 755)
- `cluster-guardian.service` + `cluster-guardian.timer` → `/etc/systemd/system/`
- `/etc/cluster-guardian.env` → pro Host unterschiedlich (siehe unten)

## Schritt 0 — Kuma-Push-Monitore (Klaus-Hand, 2 Min)

In Uptime-Kuma zwei **Push**-Monitore anlegen: `guardian-openclaw`, `guardian-hermes`. Die jeweilige Push-URL kommt in `HEARTBEAT_URL` der env. (Kein Push → Monitor wird rot = Agent krank/rate-limited.)

## env vm-100 (OpenClaw) — `/etc/cluster-guardian.env`, chmod 600

```
AGENT_NAME=openclaw
SERVICE=openclaw
HEALTH_MODE=http
HEALTH_URL=http://127.0.0.1:18789/health
HEALTH_EXPECT="ok":true
FAIL_THRESHOLD=3
MAX_RESTARTS=3
WINDOW_SEC=1800
MODE=report
HEARTBEAT_URL=<Kuma-Push-URL guardian-openclaw>
```

## env vm-101 (Hermes) — `/etc/cluster-guardian.env`, chmod 600

```
AGENT_NAME=hermes
SERVICE=hermes-gateway
HEALTH_MODE=proc
PROC_PATTERN=hermes-agent/venv/bin/python
SUBCHECK_URL=http://127.0.0.1:3002/
FAIL_THRESHOLD=3
MAX_RESTARTS=3
WINDOW_SEC=1800
MODE=report
HEARTBEAT_URL=<Kuma-Push-URL guardian-hermes>
```

## Schritt 1 — Ausrollen (report-Modus)

Pro Host: Dateien ablegen, dann:
```
systemctl daemon-reload
systemctl enable --now cluster-guardian.timer
```
Verifizieren: `tail -f /var/log/cluster-guardian.log` zeigt im Normalfall nichts (gesund) und Kuma-Heartbeat wird grün.

## Schritt 2 — Fehlerfall testen (noch report)

Kontrolliert „Hang" simulieren und prüfen, dass der Guardian ihn ERKENNT, aber NICHT eingreift:
- OpenClaw: Gateway kurz pausieren (`systemctl kill -s STOP openclaw`), 3–4 Min warten → Log zeigt `UNHEALTHY consec=…` dann `WOULD-RESTART … (mode=report)`. Danach `systemctl kill -s CONT openclaw` (wieder freigeben).
- Erwartung: Kuma rot während der Pause, kein Neustart.

## Schritt 3 — Schärfen (arm)

Wenn Schritt 2 sauber: in beiden env `MODE=report` → `MODE=arm`, dann `systemctl restart cluster-guardian.timer` (oder nächster Lauf greift). Test aus Schritt 2 wiederholen → jetzt muss der Agent nach 3 Fehlschlägen automatisch neu starten, und der Rate-Limit (max 3 / 30 Min) muss bei Dauerausfall auf „nur Alarm" umschalten.

## Sicherheits-Eigenschaften (eingebaut)

- **Report-first**: kein Eingriff, bis Klaus auf `arm` schaltet.
- **Konsekutiv-Schwelle** (3×): ein einzelner langsamer Probe-Lauf löst nichts aus.
- **Rate-Limit** (max 3 Restarts / 30 Min): kein Restart-Sturm; bei Dauerausfall nur Alarm.
- **Schlüssellos**: L0 hält keine Cluster-Keys, restartet nur den lokalen Dienst.
- **Kuma-Heartbeat nur bei Gesundheit**: Monitor wird automatisch rot bei Krankheit/Rate-Limit.

## Welle 1.1 — Hermes echte Hang-Detection + ARM (LIVE 2026-06-30)

**Problem (Blocker seit 2026-06-22):** L0-Hermes lief im `proc`-Mode. Beide Signale trogen:
`pgrep -f …/python` zählt einen per `SIGSTOP` eingefrorenen Prozess (T-State) als „lebt"; der Subcheck
`:3002` ist **hermes-studio** (eigener Prozess), nicht das Gateway. → report-Detection versagte, arm wäre wirkungslos.

**Lösung (Recon-getrieben):** Der Gateway hat jetzt `:8642/health` (In-Process, MainPID-eigen). → vm-101-env von
`proc` auf **`http`** umgestellt:
```
HEALTH_MODE=http
HEALTH_URL=http://127.0.0.1:8642/health
HEALTH_EXPECT=hermes-agent
```
(`PROC_PATTERN`/`SUBCHECK_URL` entfernt). Ein `SIGSTOP` friert den ganzen Prozess inkl. HTTP-Thread → curl
Timeout → erkannt. Kein neuer Script-Mode nötig (Simplicity-First).

**Script-Bugfix (beim Report-Test gefunden):** Bei fehlender Restart-History-Datei crashte
`recent=$(awk … "$HIST" …|wc -l)` unter `set -euo pipefail` **bevor** die Restart-Logik griff → im arm-Modus
wäre der **allererste** Restart verschluckt worden. Fix: `touch "$HIST"` vor dem awk (Zeile 49). Auf vm-101 **und**
vm-100 ausgerollt (md5 identisch zum Workspace `73258bf2…`).

**Verifikation (beide Knoten, live):**
- report: `SIGSTOP` → `/health`=000 → consec 1→2→3 → `WOULD-RESTART (report)` sauber geloggt, nach `CONT` wieder gesund.
- arm: Probe-Fehlschlag (HEALTH_URL kurz auf toten Port) → `RESTART (mode=arm)` → Dienst-PID wechselt, `health`=200, `restarts`-History=1 (Rate-Limit greift), consec=0. Für Hermes UND OpenClaw bestanden.
- Endstand: beide `MODE=arm`, korrekte HEALTH_URL, Timer aktiv, Gateways active+200.

> **arm-Test-Hinweis:** `hermes-gateway` hat `TimeoutStopUSec=210s` → einen per SIGSTOP eingefrorenen Prozess
> über `systemctl restart` zu killen blockiert lange. Für den arm-Test daher **Probe-Ebene** faken (toter Port),
> nicht den Prozess einfrieren — dann restartet der Guardian einen lebenden, signal-willigen Prozess sauber.
> `StartLimitIntervalUSec=0` → kein Start-Limit-Crash-Loop (der 2026-06-22-Fall kann so nicht wiederkehren).

## Repo-Abbildung

Nach Bewährung nach `cluster-docs/infra/cluster-guardian/` committen (Repo-first). Verwandt: `failover/GUARDIAN_DESIGN_2026-06-21_DRAFT.md`. **Status 2026-06-30:** bewährt + live (Welle 1.1) → cluster-docs-Commit noch offen.

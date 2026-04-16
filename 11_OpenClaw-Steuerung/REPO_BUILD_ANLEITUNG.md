# REPO_BUILD_ANLEITUNG – Schritt-für-Schritt Repo-Aufbau mit OpenClaw

**Gilt für:** Alle 7 v5-Repos im Project-Reloaded Cluster 
**OpenClaw:** VM 100 (192.168.1.20:18789) — alle Git-Ops laufen über ssh_exec 
**Ziel:** Von Null zu einem vollständig dokumentierten, OpenClaw-kompatiblen Fabrik-Repo

---

## Voraussetzungen

Vor dem Start prøfen:
- GitHub-Token in OpenClaw hinterlegt: `/root/.openclaw/credentials.env` → `GITHUB_TOKEN=...`
- SSH-Zugang VM 100 von OpenClaw aus funktioniert (ssh_exec MCP-Tool)
- Repo existiert bereits auf GitHub (leeres Repo reicht)

---

## Phase 0: Kontext laden

**Befehl an OpenClaw:**
```
Starte eine neue Session für [REPO-NAME].
Klone https://github.com/Project-Reloaded/[REPO-NAME] nach /tmp/[repo-name].
Lies README.md (falls vorhanden).
Sage mir: aktueller Stand in 3 Sätzen.
```

---

## Phase 1: Wave 0.x – Grundstruktur

Ziel: Repo ist navigierbar, hat Zweck-Beschreibung und erste Orientierung.

**Befehl an OpenClaw:**
```
Erstelle die Grundstruktur in /tmp/[repo-name]:

Verzeichnisse:
 docs/governance/
 docs/architecture/
 docs/operators/
 docs/vms/
 docs/product/
 _ai/openclaw/sessions/

README.md mit diesen Abschnitten:
 1. Zweck (1 Satz)
 2. Wave-Status: Wave 0.x – Grundstruktur
 3. VM-Rollen (Tabelle: VM | Funktion | Status)
 4. Nächster Start / Startbefehl (leere Sektion – wird später gefüllt)
 5. Verbindlich lesen (leere Liste)

Commit: "init: Grundstruktur [REPO-NAME] angelegt"
Push nach GitHub.
```

**Gate für Wave 1:** README existiert, Verzeichnisstruktur ist da.

---

## Phase 2: Wave 1.x – Truth Bootstrap

Ziel: OpenClaw weiß, wer es ist, was die Wahrheit ist und was sein Scope ist.

**Befehl an OpenClaw:**
```
Erstelle in /tmp/[repo-name] die Truth-Bootstrap-Dokumente:

docs/governance/WAHRHEITS_HIERARCHIE.md:
 Inhalt: GitHub-Repo > ZIP > Evidence > Legacy > Chat
 Gilt für alle Entscheidungen und Widersprüche in diesem Repo.

docs/architecture/OPENCLAW_ROLLENMODELL.md:
 Phase 1: Bootstrap-Operator (jetzt – Repo aufbauen, Docs schreiben)
 Phase 2: Helfer/Überwacher (nach VM-Installation)
 Phase 3: Sentinel (nach VPS-Betrieb)

docs/operators/OPENCLAW_START_COMMAND.md:
 Lesefolge für OpenClaw bei Session-Start in diesem Repo.
 VM-Rollen-Kurzübersicht.
 Scope-Definition.

Patche README.md: Füge alle 3 neuen Dateien in die Sektion "Verbindlich lesen" ein.
Commit: "feat(wave1): Truth-Bootstrap [REPO-NAME]"
Push.
```

**Gate für Wave 2:** Alle 3 Dateien vorhanden, README aktuell.

---

## Phase 3: Wave 2.x – VM-Rollen + Governance

Ziel: Jede VM hat eine klare Aufgabe. Harte Regeln sind dokumentiert.

**Befehl an OpenClaw (Fabrik-Repos):**
```
Erstelle in /tmp/[repo-name]:

docs/vms/VM_ROLLEN.md:
 Tabelle: vm-101 bis vm-10x
 Spalten: VM-ID | Funktion | Beschreibung | Status | Gate
 vm-101 = Orchestrator/GitOps
 [restliche VMs nach Fabrik-Typ anpassen]

docs/governance/[FABRIK]_GUARDRAILS.md:
 5 harte Regeln die NICHT verhandelbar sind.
 Was ist verboten (z.B. kein Auto-Publish, keine Live-Keys außerhalb vm-106).
 Gate-Bedingungen bevor etwas scharf geschalten wird.

Patche README.md: neue Dateien ergänzen.
Commit: "feat(wave2): VM-Rollen + Guardrails [REPO-NAME]"
Push.
```

**Gate für Wave 3:** VM_ROLLEN.md und GUARDRAILS.md vorhanden und vollständig.

---

## Phase 4: Wave 3.x – Legacy-Transfer

Ziel: Alle wertvollen Muster aus den Legacy-Repos sind übernommen und dokumentiert.

**Befehl an OpenClaw:**
```
Lies cluster-docs/10_Legacy-Delta/LEGACY_DELTA_ANALYSE.md.
Lies cluster-docs/11_OpenClaw-Steuerung/LEGACY_STEUERUNG_VERGLEICH.md.

Identifiziere alle P1-Lücken für [REPO-NAME].
Erstelle die fehlenden Dateien.
Patche README.md.
Commit: "feat(wave3): Legacy-Transfer P1 fuer [REPO-NAME] abgeschlossen"
Push.
```

**Typische P1-Dateien je nach Repo-Typ:**

| Repo-Typ | Typische P1-Dateien |
|----------|-------------------|
| Trading | LIVE_KEY_GUARDRAIL.md, TRADING_PROGRESSION.md |
| Social Media | CONTENT_RELEASE_GUARDRAILS.md, CONTENT_PIPELINES.md |
| Marketing / Ebook | WAHRHEITS_HIERARCHIE.md, OPENCLAW_ROLLENMODELL.md |
| Cluster / Control | FEHLENDE_VMS.md, NODE_FABRIK_ZUORDNUNG.md |
| RefactorCo | PRODUCT_REQUEST_CONTRACT.md, CANONICAL_WORKFLOW.md |

**Gate für Wave 4:** Alle P1-Lücken geschlossen, keine roten Zeilen in LEGACY_DELTA_ANALYSE.

---

## Phase 5: Wave 4.x – Installation Readiness

Ziel: Alles ist bereit für die tatsächliche VM-Installation.

**Befehl an OpenClaw:**
```
Erstelle in /tmp/[repo-name]:

docs/installation/INSTALL_SEQUENCE.md:
 Reihenfolge: Welche VM wird zuerst installiert?
 Abhängigkeiten zwischen VMs.
 Smoke-Tests pro VM.

docs/installation/PREINSTALL_CHECKLIST.md:
 Hardware-Gates (RAM, CPU, Disk pro VM).
 Netzwerk-Gates (IP-Plan, DNS).
 Credential-Gates (welche Secrets müssen vor Start vorhanden sein).

Patche README.md: Wave auf 4.x setzen.
Commit: "feat(wave4): Installation-Readiness [REPO-NAME]"
Push.
```

**Gate für Wave 5:** INSTALL_SEQUENCE und PREINSTALL_CHECKLIST vollständig, alle Gates grün.

---

## Phase 6: Wave 5.x – Aktiver Betrieb

Ziel: VMs laufen, OpenClaw øberwacht.

**Befehl an OpenClaw:**
```
Erstelle in /tmp/[repo-name]:

docs/betrieb/RUNBOOK.md:
 Standard-Betriebsprozeduren.
 Was tun bei Ausfall von vm-10x?
 Rollback-Prozedur.

_ai/openclaw/IDENTITY.md:
 Rolle von OpenClaw in diesem Repo (Betriebsphase).
 Was darf OpenClaw tun / nicht tun.

Patche README.md: Wave auf 5.x setzen.
Commit: "feat(wave5): Runbook + OpenClaw-Identity [REPO-NAME]"
Push.
```

---

## Schnell-Referenz: Alle Phasen

| Wave | Ziel | Schlüsseldatei | Gate |
|------|------|---------------|------|
| 0.x | Grundstruktur | README.md | Verzeichnisse da |
| 1.x | Truth Bootstrap | WAHRHEITS_HIERARCHIE.md | 3 Governance-Docs |
| 2.x | VM-Rollen + Regeln | VM_ROLLEN.md | Alle VMs definiert |
| 3.x | Legacy-Transfer | LEGACY_DELTA_ANALYSE P1 | Keine P1-Lücken |
| 4.x | Install-Bereit | INSTALL_SEQUENCE.md | Alle Gates grün |
| 5.x | Betrieb aktiv | RUNBOOK.md | VMs laufen |
| 6.x | Self-improving | TBD | Lernschleife bestätigt |
| 7.x | Freeze / 100% | CHANGELOG frozen | Keine offenen Punkte |

---

## Technische Details: Wie OpenClaw Git macht

Alle Git-Operationen laufen auf **VM 100 via ssh_exec**, nicht im lokalen Bash.

**Standard-Skript-Muster (Python):**
```python
import subprocess, os

GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN")
REPO = "Project-Reloaded/[REPO-NAME]"
DIR = "/tmp/[repo-dir]"

subprocess.run(["git", "clone",
 f"https://{GITHUB_TOKEN}@github.com/{REPO}", DIR])

# ... Dateien schreiben ...

os.chdir(DIR)
subprocess.run(["git", "add", "-A"])
subprocess.run(["git", "commit", "-m", "feat: ..."])
subprocess.run(["git", "push"])
```

**Wichtig:** Token niemals als String in den Chat schreiben. OpenClaw muss
`${GITHUB_TOKEN}` als Platzhalter verwenden und es selbst aus credentials.env auflösen.

---

## Qualitäts-Checkliste nach jedem Build-Schritt

- [ ] README.md enthält alle neu erstellten Dateien im Startbefehl-Abschnitt
- [ ] Commit-Message folgt dem Schema `type(scope): beschreibung`
- [ ] Kein Secret / Token im Repo
- [ ] Verzeichnisstruktur konsistent mit anderen v5-Repos
- [ ] Wave-Status im README aktualisiert
- [ ] Session-Handoff in `_ai/openclaw/sessions/` gespeichert (bei langen Sessions)

---

*Stand: 2026-04-16 | Kapitel: cluster-docs/11_OpenClaw-Steuerung*

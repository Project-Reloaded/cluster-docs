> **Stand: 2026-04-25 (cluster-weiter Bestandsdatei-Sync abgeschlossen)** | Master-Statusdatei für den gesamten v5-Cluster
> Quelle der Wahrheit: GitHub-Repos auf `Project-Reloaded/*-v5` (main).
> Aktualisierung: nach jeder produktiven Session, mindestens 1× pro Arbeitstag.

# CURRENT_STATE — Cluster-Gesamtstand

## Was du HEUTE als Erstes tun solltest

**1. Schnellstatus aller 7 Repos (B1 in jedem Repo) → in 5 Min weißt du wo du stehst:**
```
@OpenClaw: Lies in jedem dieser 7 Repos das README.md und gib einen 3-Zeilen-Statusbericht
(Wave-Stand, nächster offener Schritt, offene Gates):
project-reloaded-cluster-v5, Cluster-Control-v5, Trading-Fabrik-v5,
Social-Media-Fabrik-v5, Marketing-Fabrik-v5, Ebook-Fabrik-v5, RefactorCo-Fabrik-v5.
```

**2. Wenn dieser Bericht da ist → das schwächste Repo zuerst:**
- **RefactorCo-Fabrik-v5** ist auf 52 % gelb (Block A erledigt 2026-04-25, Block B/C offen, Gates FAIL bis ≥ 80 % grün) — **immer noch das schwächste der 7**
- **Cluster-Control-v5** und **project-reloaded-cluster-v5** sind nominal 32 / 35 % rot, aber Werte sind vom 2026-04-11 und noch nicht neu bewertet
- **Trading-Fabrik-v5 (82%), Social-Media-Fabrik-v5 (93%), Marketing-Fabrik-v5 (63%), Ebook-Fabrik-v5 (87%)** sind konsistent und arbeiten in Welle 3.x

**3. Routine-Audit täglich:** `AUDIT1` aus `OPENCLAW_BEFEHLSKATALOG.md` ausführen — Netzwerk + VMs + Services in einem Durchgang. **Stand 2026-04-25:** 4/6 Geräte erreichbar (Pi-holes 10.6.7.x VLAN-isoliert), Proxmox-API-Token funktional, 12 VMs sichtbar, VM 100 selbst kerngesund.

---

## Repo-Reifegrad (Stand 2026-04-25)

| # | Repo | Reifegrad | Farbe | Aktive Welle | Gates | Letzter Push |
|---|------|----------:|:-----:|:------------:|-------|:------------:|
| 1 | **project-reloaded-cluster-v5** | **35 %** *(nominal)* | red | 1 (Bootstrap) | `cluster_integration_ready: FAIL` | 2026-04-25 (`d913595`) |
| 2 | **Cluster-Control-v5** | **32 %** *(nominal)* | red | 0.5 / 1 | `control_shared_ready: FAIL` | 2026-04-25 (`46c86b6`) |
| 3 | **Trading-Fabrik-v5** | **82 %** | yellow | 3.x | `legacy_compare_ready: PASS`, `delta_wave_ready: FAIL`, `cross_repo_ready: FAIL` | 2026-04-25 (`1b5e444`) |
| 4 | **Social-Media-Fabrik-v5** | **93 %** | yellow | 3.1 | `legacy_compare_ready: PASS`, `delta_wave_ready: FAIL`, `cross_repo_ready: FAIL` | 2026-04-25 (`7b07c6e`) |
| 5 | **Marketing-Fabrik-v5** | **63 %** | yellow | 3.1 | `legacy_compare_ready: PASS`, `delta_wave_ready: FAIL`, `cross_repo_ready: FAIL` | 2026-04-25 (`d276b80`) |
| 6 | **Ebook-Fabrik-v5** | **87 %** | green | 3.x | `legacy_compare_ready: PASS`, `delta_wave_ready: FAIL`, `cross_repo_ready: FAIL` | 2026-04-25 (`fa51f18`) |
| 7 | **RefactorCo-Fabrik-v5** | **52 %** | yellow | 1-2 + Block B/C | alle FAIL | 2026-04-25 (`f21ecf3`) |

> *(nominal)* = Wert vom 2026-04-11, **noch nicht neu bewertet** in dieser Session. Stand-Datum frisch, Score wartet auf Klaus' Neubewertung in einer späteren Session.

**Cluster-weite Gates:**
- `delta_wave_ready` : **FAIL** (überall — fehlende `INSTALL_SEQUENCE.md` + `docs/VM_SPEC.md` in allen Fabriken)
- `cross_repo_ready` : **FAIL** (überall — fehlende `CLUSTER_DEPS.md`)
- `CLUSTER_INTEGRATION_READY` : **BLOCKED** (wartet auf `delta_wave_ready`)

**Strategische Reihenfolge (laut `01_BEFEHLSLISTE-CLUSTER-ABSCHLUSS.md`):**
RefactorCo → Cluster-Control → Trading → Social-Media → Marketing → Ebook → cluster-v5 (zuletzt — braucht alle anderen).

---

## Was als Nächstes pro Repo dran ist (4-5 Schritte aus den jeweiligen Handoffs)

### project-reloaded-cluster-v5  ⚠ Reifegrad nominal, Neubewertung erforderlich
1. Reifegrad-Neubewertung: Candidate-Scorecard erstellen oder direkt Wert setzen
2. `_ai/openclaw/sessions/` + `_ai/openclaw/BOOTSTRAP.md` anlegen
3. `AGENTS.md` auf Root-Level ergänzen (B3 im Befehlskatalog)
4. `docs/nodes/NODE4_TRADING_SONDERPFAD.md` aus Legacy v3
5. `docs/installation/INSTALL_SEQUENCE.md` erstellen (Wave-4-Gate)

### Cluster-Control-v5  ⚠ Reifegrad nominal, Neubewertung erforderlich
1. Reifegrad-Neubewertung: Candidate-Scorecard erstellen oder direkt Wert setzen
2. `_ai/openclaw/` + `AGENTS.md` (analog zu cluster-v5)
3. `docs/nodes/NODE_FABRIK_ZUORDNUNG.md` prüfen/erstellen
4. Orchestrierungs-Konzept dokumentieren
5. Failover-Prozedur (was bei vm-101-Ausfall?)

### Trading-Fabrik-v5
1. Welle 3.2 fortsetzen — belastbare v1/v2/v3/v4 Quellen ins Repo
2. `docs/governance/LIVE_KEY_GUARDRAIL.md` (3-Regeln-Härtung)
3. Selbstverbessernde Lernschleife konzipieren
4. `PHASED_ACTIVATION.md` aus trading-lab übernehmen
5. Smoke-Tests für vm-103 (Market-Core)

### Social-Media-Fabrik-v5
1. Welle 3.1 — `inventory/legacy-comparison-gap-matrix.md`
2. `docs/migration/legacy-boundary-rules.md`
3. K-R Bundle-System vollständig dokumentieren (`docs/content/KR_BUNDLE_SYSTEM.md`)
4. Block-Derivation-System aus Legacy
5. Scheduling-Konzept + Kanal-Übersicht

### Marketing-Fabrik-v5
1. Welle 3.1 — `inventory/legacy-comparison-gap-matrix.md` (Delta-Gap-Matrix fehlt noch)
2. V1-Pack gegen v5-Zielarchitektur prüfen
3. Quellen-Routing entscheiden (übernehmen / nach Social-Media / nach Cluster-Control / parken)
4. `docs/marketing/MARKETING_FUNNEL.md` (4-Stufen-Modell)
5. Schnittstelle zu Social-Media + Ebook formalisieren

### Ebook-Fabrik-v5
1. Welle 3.1 → 4 Pflicht-Dateien:
   - `docs/runtime/cli-and-runner-contract.md`
   - `docs/runtime/manifest-schema-rules.md`
   - `docs/knowledge/source-moc-structure.md`
   - `docs/factory/final-green-checklist.md`
2. Themen-Backlog-Format
3. Cover-Design-Workflow
4. Export-Qualitäts-Gate definieren
5. Auf 100 % schließen → dann Trading-Fabrik aufholen

### RefactorCo-Fabrik-v5  ⚠ Schwächstes Glied (Block A am 2026-04-25 erledigt)
1. **Block B starten** — Artefakt-Gegenprüfung aller Core-Dateien (Welle 6 vorziehen)
2. `_ai/handoffs/HANDOFF_STAGE_GATE_AND_WAVE_MASTER.md` auf Block-A-erledigt aktualisieren
3. Truth-Gaps + Park-Zonen in einem Sammeldokument konsistent markieren
4. **Block C** — Reifegrad von 52 auf ≥ 80 % grün heben (Release-Candidate-Stand)
5. Erst nach 80 % grün: Welle 3.2 (Legacy-Import) freigeben

---

## Cluster-weite offene Punkte (Querschnitt)

- [ ] **AGENTS.md auf Root** — fehlt in mehreren Repos (Bootstrap-Pflicht)
- [ ] **`_ai/openclaw/sessions/` + BOOTSTRAP.md** — fehlt in mehreren Repos
- [ ] **`INSTALL_SEQUENCE.md`** — fehlt in **ALLEN 7 Repos** → blockt `delta_wave_ready`
- [ ] **`docs/VM_SPEC.md`** — fehlt in **ALLEN 7 Repos** → blockt `delta_wave_ready`
- [ ] **`CLUSTER_DEPS.md`** — fehlt in **ALLEN 7 Repos** → blockt `cross_repo_ready`
- [ ] **`docs/operators/OPENCLAW_START_COMMAND.md`** — existiert NUR in RefactorCo-Fabrik-v5 → CW2 ausrollen
- [ ] **Reifegrad-Neubewertung** für project-reloaded-cluster-v5 + Cluster-Control-v5 (Werte aktuell nominal 35 / 32 % vom 2026-04-11)
- [ ] **Pi-hole-Routing** — VLAN 10.6.7.x ist von 192.168.1.20 (VM 100) nicht erreichbar; Pi-holes laufen aber (laut PVE-API). OPNsense-Routing prüfen.
- [ ] **Token-Rotation** — die im Cache liegenden GitHub-PATs sind als rotationsbedürftig markiert (Sicherheitsschuld); Telegram-Bot-Token war kurz im Chat (rotierbar via @BotFather); Proxmox-Token wurde im Chat-Output sichtbar (rotierbar via `pveum user token remove + add`)
- [x] ~~**`cluster-docs/08_Betrieb/CROSS_REPO_STATUS.md`** — wird im Befehlskatalog referenziert, existiert noch nicht~~ → existiert seit 2026-04-25
- [x] ~~**`PVE_USER` / `PVE_TOKEN_ID` / `PVE_TOKEN_SECRET`** in `credentials.env`~~ → erledigt 2026-04-25 (`openclaw@pve!cowork-2026-04-25`, PVEVMAdmin + PVEAuditor)
- [x] ~~**Bestandsdatei-Sync alle Repos**~~ → erledigt 2026-04-25 (cluster-weit, 7 atomic Commits)

---

## Cluster-Architektur (Kurzform)

```
GitHub-User Project-Reloaded
├─ project-reloaded-cluster-v5    (Master / Integration / Dedupe)
├─ Cluster-Control-v5             (Meta-Steuerung / Governance / Observability)
├─ 5 Fachfabriken-v5
│  ├─ Trading-Fabrik-v5           ← braucht vm-106 für Live-Keys
│  ├─ Social-Media-Fabrik-v5
│  ├─ Marketing-Fabrik-v5
│  ├─ Ebook-Fabrik-v5
│  └─ RefactorCo-Fabrik-v5
├─ cluster-docs                   (PUBLIC — diese Doku!)
└─ openclaw-memory                (OpenClaw Wiki/Memory-Repo)

Hardware (laut Proxmox-API, 2026-04-25):
└─ Proxmox-Cluster auf Node-1-Network-Master (PVE 9.1.7), 12 VMs:
   ├─ VM 100  openclaw                  (running, 75 % RAM)
   ├─ VM 102  vm-102-OpnSense-Master    (running)
   ├─ VM 104  vm-104-OpnSense-Slave     (running)
   ├─ VM 106  vm-106-pi-hole-a          (running) ← isoliert ab VM 100
   ├─ VM 107  pihole-b                  (running) ← isoliert ab VM 100
   ├─ VM 110  ?                         (unknown, nicht installiert)
   ├─ VM 200  ?                         (unknown)
   └─ VM 300-305  vlan-test-VMs (5x)    (running, klein)
```

**Steuerung:** OpenClaw Gateway auf VM 100 (192.168.1.20:18789) →
4 MCP-Server (ssh-exec, github-wiki, proxmox-api, github-repos) →
GitHub-Repos. Telegram-Bot: [@OpenClaw_Vm_100_bot](https://t.me/OpenClaw_Vm_100_bot) (Whitelist nur Klaus).

---

## Heute committet (2026-04-25)

| Repo | Commit | Zweck |
|------|--------|-------|
| cluster-docs | `6a058f9` → `b5a48e7` (mehrere) | Master-Doku, AUDIT1, Cross-Repo-Sync |
| RefactorCo-Fabrik-v5 | `f21ecf3` | Block A (29→52%) |
| Trading-Fabrik-v5 | `1b5e444` | refresh, konsistent 82% |
| Social-Media-Fabrik-v5 | `7b07c6e` | refresh, konsistent 93% |
| Marketing-Fabrik-v5 | `d276b80` | refresh, konsistent 63% |
| Ebook-Fabrik-v5 | `fa51f18` | refresh, konsistent 87% |
| project-reloaded-cluster-v5 | `d913595` | refresh, nominal 35% |
| Cluster-Control-v5 | `46c86b6` | refresh, nominal 32% |
| openclaw-memory | `685f2ec`, `f20a36f` | system_prompt v2, workspace bootstrap |

---

## Nutzung dieser Datei

- **Vor jeder Session lesen** — gibt dir den Sprung-in-Mitte-Überblick
- **Nach jeder produktiven Session aktualisieren** — mindestens Reifegrad-Tabelle + "Nächste 4-5 Schritte" pro betroffenem Repo
- **In jeden Repo-Handoff verlinken** als `cluster-docs/CURRENT_STATE.md`
- **OpenClaw-Befehl zum automatischen Refresh:** siehe `11_OpenClaw-Steuerung/STARTBEFEHL_QUICKSTART.md` Abschnitt "C0 — Cluster-Statusbericht"

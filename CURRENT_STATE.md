> **Stand: 2026-04-25 (nach Block A für RefactorCo)** | Master-Statusdatei für den gesamten v5-Cluster
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

**2. Wenn dieser Bericht da ist → das schwächste Repo zuerst:** Aktuell ist das immer noch `RefactorCo-Fabrik-v5` (52 % gelb, Block B + C der Roadmap offen, Gates FAIL bis ≥ 80 % grün). Block A ist 2026-04-25 erledigt — nächste Etappe ist Block B (Welle 6 vorziehen).

**3. Routine-Audit täglich:** `AUDIT1` aus `OPENCLAW_BEFEHLSKATALOG.md` ausführen — Netzwerk + VMs + Services in einem Durchgang. **Stand 2026-04-25:** 4/6 Geräte erreichbar (Pi-holes 10.6.7.x VLAN-isoliert), Proxmox-API-Token ist seit heute da (PVE-Zugang funktional, 12 VMs sichtbar), VM 100 selbst kerngesund.

---

## Repo-Reifegrad (Stand 2026-04-25)

| # | Repo | Reifegrad | Farbe | Aktive Welle | Gates | Letzter Push |
|---|------|----------:|:-----:|:------------:|-------|:------------:|
| 1 | **project-reloaded-cluster-v5** | n/a | gray | 1 (Bootstrap) | `cluster_integration_ready: FAIL` | 2026-04-16 |
| 2 | **Cluster-Control-v5** | n/a | gray | 0.5 / 1 | `control_shared_ready: FAIL` | 2026-04-16 |
| 3 | **Trading-Fabrik-v5** | **82 %** | yellow | 3.2 | `legacy_compare_ready: PASS`, `delta_wave_ready: FAIL`, `cross_repo_ready: FAIL` | 2026-04-16 |
| 4 | **Social-Media-Fabrik-v5** | **93 %** | yellow | 3.1 | `legacy_compare_ready: PASS`, `delta_wave_ready: FAIL`, `cross_repo_ready: FAIL` | 2026-04-16 |
| 5 | **Marketing-Fabrik-v5** | n/a | yellow | 3.1 | `legacy_compare_ready: PASS`, `delta_wave_ready: FAIL`, `cross_repo_ready: FAIL` | 2026-04-16 |
| 6 | **Ebook-Fabrik-v5** | **87 %** | green | 3.x | `legacy_compare_ready: PASS`, `delta_wave_ready: FAIL`, `cross_repo_ready: FAIL` | 2026-04-16 |
| 7 | **RefactorCo-Fabrik-v5** | **52 %** | yellow | 1-2 + Block B/C | alle FAIL | **2026-04-25** (Block A: `f21ecf3`) |

**Cluster-weite Gates:**
- `delta_wave_ready` : **FAIL** (überall — fehlende `INSTALL_SEQUENCE.md` + `docs/VM_SPEC.md` in allen Fabriken)
- `cross_repo_ready` : **FAIL** (überall — fehlende `CLUSTER_DEPS.md`)
- `CLUSTER_INTEGRATION_READY` : **BLOCKED** (wartet auf `delta_wave_ready`)

**Strategische Reihenfolge (laut `01_BEFEHLSLISTE-CLUSTER-ABSCHLUSS.md`):**
RefactorCo → Cluster-Control → Trading → Social-Media → Marketing → Ebook → cluster-v5 (zuletzt — braucht alle anderen).

---

## Was als Nächstes pro Repo dran ist (4-5 Schritte aus den jeweiligen Handoffs)

### project-reloaded-cluster-v5
1. `_ai/openclaw/sessions/` + `_ai/openclaw/BOOTSTRAP.md` anlegen
2. `AGENTS.md` auf Root-Level (B3 im Befehlskatalog)
3. `docs/nodes/NODE4_TRADING_SONDERPFAD.md` aus Legacy v3
4. `docs/vms/FEHLENDE_VMS_NODE1.md` (DNS, TOR — vm-106/108/110)
5. `docs/installation/INSTALL_SEQUENCE.md` erstellen (Wave-4-Gate)

### Cluster-Control-v5
1. `_ai/openclaw/` + `AGENTS.md` (analog zu cluster-v5)
2. `docs/nodes/NODE_FABRIK_ZUORDNUNG.md` prüfen/erstellen
3. Orchestrierungs-Konzept dokumentieren
4. Monitoring-Konzept (`docs/betrieb/`)
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
1. Welle 3.1 — `inventory/legacy-comparison-gap-matrix.md`
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
- [ ] **Pi-hole-Routing** — VLAN 10.6.7.x ist von 192.168.1.20 (VM 100) nicht erreichbar; Pi-holes laufen aber (laut PVE-API). OPNsense-Routing prüfen.
- [ ] **Token-Rotation** — die im Cache liegenden GitHub-PATs sind als rotationsbedürftig markiert (Sicherheitsschuld); Telegram-Bot-Token war kurz im Chat (rotierbar via @BotFather)
- [x] ~~**`cluster-docs/08_Betrieb/CROSS_REPO_STATUS.md`** — wird im Befehlskatalog referenziert, existiert noch nicht~~ → existiert seit 2026-04-25
- [x] ~~**`PVE_USER` / `PVE_TOKEN_ID` / `PVE_TOKEN_SECRET`** in `credentials.env`~~ → erledigt 2026-04-25 (`openclaw@pve!cowork-2026-04-25`, PVEVMAdmin + PVEAuditor)

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

## Nutzung dieser Datei

- **Vor jeder Session lesen** — gibt dir den Sprung-in-Mitte-Überblick
- **Nach jeder produktiven Session aktualisieren** — mindestens Reifegrad-Tabelle + "Nächste 4-5 Schritte" pro betroffenem Repo
- **In jeden Repo-Handoff verlinken** als `cluster-docs/CURRENT_STATE.md`
- **OpenClaw-Befehl zum automatischen Refresh:** siehe `11_OpenClaw-Steuerung/STARTBEFEHL_QUICKSTART.md` Abschnitt "C0 — Cluster-Statusbericht"

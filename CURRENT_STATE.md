> **Stand: 2026-04-25** | Master-Statusdatei für den gesamten v5-Cluster
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

**2. Wenn dieser Bericht da ist → das schwächste Repo zuerst:** Aktuell ist das `RefactorCo-Fabrik-v5` (alle Gates FAIL, Wave-1/2 noch nicht 80% grün).

**3. Routine-Audit täglich:** `AUDIT1` aus `OPENCLAW_BEFEHLSKATALOG.md` ausführen — Netzwerk + VMs + Services in einem Durchgang.

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
| 7 | **RefactorCo-Fabrik-v5** | n/a | red | 1–2 | alle FAIL | 2026-04-16 |

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

### RefactorCo-Fabrik-v5  ⚠ Schwächstes Glied
1. **ZUERST** `main` auf min. 80 % grün bringen (alle bisherigen P1-Lücken schließen)
2. Welle-1-Truth-Bootstrap finalisieren
3. Welle-2-Core-Kanonisierung abschließen
4. `docs/operators/OPENCLAW_START_COMMAND.md` als Muster auf alle 6 anderen Repos ausrollen (CW2 im Befehlskatalog)
5. Multi-Case-System A-G dokumentieren

---

## Cluster-weite offene Punkte (Querschnitt)

- [ ] **AGENTS.md auf Root** — fehlt in mehreren Repos (Bootstrap-Pflicht)
- [ ] **`_ai/openclaw/sessions/` + BOOTSTRAP.md** — fehlt in mehreren Repos
- [ ] **`INSTALL_SEQUENCE.md`** — fehlt in **ALLEN 7 Repos** → blockt `delta_wave_ready`
- [ ] **`docs/VM_SPEC.md`** — fehlt in **ALLEN 7 Repos** → blockt `delta_wave_ready`
- [ ] **`CLUSTER_DEPS.md`** — fehlt in **ALLEN 7 Repos** → blockt `cross_repo_ready`
- [ ] **`docs/operators/OPENCLAW_START_COMMAND.md`** — existiert NUR in RefactorCo-Fabrik-v5 → CW2 ausrollen
- [ ] **`cluster-docs/08_Betrieb/CROSS_REPO_STATUS.md`** — wird im Befehlskatalog referenziert, existiert noch nicht
- [ ] **Token-Rotation** — die im Cache liegenden GitHub-PATs sind als rotationsbedürftig markiert (Sicherheitsschuld)

---

## Cluster-Architektur (Kurzform)

```
GitHub-Org Project-Reloaded
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

Hardware:
└─ Proxmox-Cluster (5 Nodes geplant)
   ├─ Node-1: Infra (OpenClaw VM 100, OPNsense, DNS, TOR)
   ├─ Node-2/3: Fachfabriken
   ├─ Node-4: Trading-Sonderpfad (vm-106 = Live-Keys ONLY)
   └─ Node-5: noch zu definieren
```

**Steuerung:** OpenClaw Gateway auf VM 100 (192.168.1.20:18789) →
4 MCP-Server (ssh-exec, github-wiki, proxmox-api, github-repos) →
GitHub-Repos.

---

## Nutzung dieser Datei

- **Vor jeder Session lesen** — gibt dir den Sprung-in-Mitte-Überblick
- **Nach jeder produktiven Session aktualisieren** — mindestens Reifegrad-Tabelle + "Nächste 4-5 Schritte" pro betroffenem Repo
- **In jeden Repo-Handoff verlinken** als `cluster-docs/CURRENT_STATE.md`
- **OpenClaw-Befehl zum automatischen Refresh:** siehe `11_OpenClaw-Steuerung/STARTBEFEHL_QUICKSTART.md` Abschnitt "C0 — Cluster-Statusbericht"

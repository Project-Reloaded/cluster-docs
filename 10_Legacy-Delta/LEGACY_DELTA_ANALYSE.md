# Legacy-Delta-Analyse -- Project-Reloaded
Stand: 2026-04-16

Analysierte Vorgaenger-Repos: trading-lab, Social-Media-Fabrik, RefactorCo-lab, cluster-v4, cluster-v3

---

## 1. trading-lab --> Trading-Fabrik-v5

### Was im Legacy vorhanden, in v5 noch FEHLT:

**VM-Rollen konkret (trading-lab hat diese, v5 nicht):**
| VM | Rolle |
|----|-------|
| vm-101 | Governance / Audit / GitOps |
| vm-102 | Agent-Inference / lokaler Backbone |
| vm-103 | Market-Core |
| vm-104 | Research-Lab |
| vm-105 | Data / Observe |
| vm-106 | Exec-Gateway -- LIVE KEYS NUR HIER |
| vm-107 | Ops-Portal / Trading-App-PWA-Basis |
| vm-108 | Heavy-Inference / grosse lokale Jobs |

**Harte Sicherheitsregeln (nicht verhandelbar):**
- Live-Keys nur auf vm-106 --> in Trading-Fabrik-v5 als harte Guardrail verankern
- Live-Orderpfad nur auf vm-106
- Keine stille Echtgeld-Freischaltung

**Trading-Progression (noch fehlende Stufenlogik in v5):**
Research --> Replay --> Walk-Forward --> Shadow --> kontrollierte Micro-Live-Vorbereitung

**Fehlende Harte Wahrheiten in v5:**
- Noch keine bestaetigte selbstverbessernde Lernschleife
- Noch keine vollstaendige Trading-App / PWA
- Kein bestaedigter Echtgeld-Produktivbetrieb

**Prioritaet Transfer:** HOCH -- Security-Guardrails und VM-Rollen zuerst

---

## 2. Social-Media-Fabrik --> Social-Media-Fabrik-v5

### Was im Legacy vorhanden, in v5 noch FEHLT:

**Vollstaendiges Root-Dateiset (Legacy hat 00-11, v5 unvollstaendig):**
- 09_permission_lifecycle.md --> fehlt in v5 (Freigabe-Workflow!)
- cluster-map.yaml (inventory/) --> nicht uebernommen
- node-plan-v1.1.yaml (inventory/) --> nicht uebernommen
- SOCIAL_MEDIA_FABRIK_IMPORT.md --> Ur-Entwurf mit Ideen!

**Fehlende Kerndokumente:**
- docs/architecture/ARCHITECTURE.md
- docs/agents/SOCIAL_MEDIA_AGENT_SYSTEM.md
- docs/governance/CONTENT_RELEASE_GUARDRAILS.md
- docs/product/CONTENT_PIPELINES.md

**VM-Rollen (Legacy klar, v5 unklar):**
| VM | Rolle |
|----|-------|
| vm-101 | Orchestrator / Steuerung / Scheduling / Freigabewege |
| vm-102 | Inference-Heavy / Produktionsjobs |
| vm-103 | Inference-Light / Vorverarbeitung / Utility |
| vm-104 | Storage / Archiv / Export / Artefaktablage |
| vm-106 | Automation / Workflows / Publishing-Steuerung |
| vm-107 | Monitoring / KPIs / Queue / Health / Kostenkontrolle |

**Harte Regeln aus Legacy:**
- Review vor Produktion
- Freigabe vor Publishing
- Keine Secrets in Git
- Keine stillen Architekturwechsel
- Local-first, API-Fallback nur kontrolliert

**Prioritaet Transfer:** MITTEL -- CONTENT_RELEASE_GUARDRAILS + VM-Rollen

---

## 3. RefactorCo-lab --> RefactorCo-Fabrik-v5

### Was im Legacy vorhanden, in v5 noch FEHLT:

**Kanonischer Workflow (in v5 nicht explizit):**
Idea Intake --> Fork Analysis --> Module Spec --> Fast Test --> Hybrid Testbed --> Portal-Sicht

**Fehlende Kerndokumente:**
- docs/operators/CHATGPT_START_COMMAND.md --> fuer OpenClaw: OpenClaw Start Command
- docs/contracts/PRODUCT_REQUEST_CONTRACT.md -- zentral!

**VM-Rollen (Legacy klar, v5 unklar):**
| VM | Rolle |
|----|-------|
| vm-101 | Governance / Audit / GitOps |
| vm-102 | Orchestrator / Dashboard / Idea Intake |
| vm-103 | Heavy Refactoring |
| vm-104 | Fork Analysis / Memory |
| vm-105 | Fast Execution / Testing |
| vm-106 | Storage / Code / lokales Hybrid-Testbed |
| vm-107 | Ops-Portal / PWA |

**Multi-Case-Template-Ansatz (FEHLT komplett in v5):**
- 10+ Fallvorlagen vorbereiten als wiederverwendbare Arbeitsvorlagen
- Erst Muster-Faelle --> dann echte Ziel-Repos anlegen
- Kein Auto-Upgrade auf echtes Zielrepo ohne expliziten Schritt

**Harte Wahrheiten aus Legacy:**
- Kein stiller Komplett-Rewrite
- Laravel nur wo einzelne Module bewusst herausgeloest werden
- Jede Aenderung muss im lokalen Testbed pruefbar bleiben

**Prioritaet Transfer:** SEHR HOCH -- RefactorCo ist der blockierte Schwaechste (< 80%)
PRODUCT_REQUEST_CONTRACT + kanonischer Workflow koennen Wave 2 abschliessen helfen

---

## 4. project-reloaded-cluster-v4 --> project-reloaded-cluster-v5

### Was im Legacy vorhanden, in v5 noch FEHLT:

**OpenClaw-Rollenmodell (v4 hat das, v5 nicht):**
- OpenClaw = TEMPORAERER Bootstrap-Operator
- Nach Grundinstallation: OpenClaw --> Helfer/Ueberwacher-Rolle (downgrade!)
- Das ist eine wichtige Architekturentscheidung!

**Fehlende VMs in v5-Planung:**
| VM | Rolle in v4 | Status in v5 |
|----|-------------|--------------|
| vm-106 | DNS / Adblock-Core (primaer) | FEHLT |
| vm-108 | DNS / Adblock-Core (Redundanz) | FEHLT |
| vm-110 | TOR-Segment / Privacy Egress | FEHLT |

**Node-1 VM-Linie aus v4 (klarer als in v5):**
- vm-100 = OpenClaw (Bootstrap-Operator)
- vm-102 = Edge-Firewall / Router / VLAN-Gateway (= aktuell OPNsense)
- vm-104 = HA/Failover (= aktuell OPNsense Slave)
- vm-106 = DNS/Adblock (NOCH NICHT INSTALLIERT)
- vm-108 = DNS/Adblock Redundanz (NOCH NICHT INSTALLIERT)
- vm-110 = TOR / Privacy Egress (NOCH NICHT INSTALLIERT)

**Prioritaet Transfer:** HOCH -- fehlende VMs (DNS, TOR) und OpenClaw-Rollenmodell

---

## 5. project-reloaded-cluster-v3 --> project-reloaded-cluster-v5

### Was im Legacy vorhanden, in v5 noch FEHLT:

**Node-4 = Trading/Krypto-Sonderpfad:**
- In v3 war Node-4 explizit als Trading/Crypto/Ops/PWA-Sonderpfad bestaetigt
- In v5 noch keine Node-->Fabrik-Zuordnung definiert!

**Uebergreifende Wahrheits-Hierarchie (in v5 nicht formalisiert):**
- GitHub-Repo = lebende Wahrheit
- ZIP = Snapshot / Transportformat
- Evidence = operative Wahrheit
- Legacy = Referenzquelle, nicht automatische Gegenwartswahrheit

**Out-of-Band-Kontrolle (v3 hatte das, v5 nicht):**
- vps-openclaw-main als externer Sentinel --> Out-of-Band-Kontrollpunkt
- Bypass IP:Port parallel zu Hostname/Proxy-Zugriff

**OpenWebUI (v3 hatte das, in v5 nicht geplant):**
- vm-215 = OpenWebUI als allgemeiner Cluster-Komfortdienst

**Permanentes Gedaechtnis (v3 Pflicht, v5 noch nicht explizit):**
- Permanentes Gedaechtnis bleibt Pflichtbestandteil der Zielarchitektur
- openclaw-memory wiki ist Ansatz, aber noch nicht als Pflicht verankert

**Prioritaet Transfer:** MITTEL -- Wahrheits-Hierarchie und Node-->Fabrik-Zuordnung

---

## Gesamtbild: Kritischste Luecken (nach Prioritaet)

| Prioritaet | Luecke | Betroffene v5-Repos | Quelle |
|-----------|-------|----------------------|--------|
| KRITISCH | RefactorCo: PRODUCT_REQUEST_CONTRACT + Workflow | RefactorCo-Fabrik-v5 | RefactorCo-lab |
| KRITISCH | Trading: VM-Rollen + Live-Key-Guardrail | Trading-Fabrik-v5 | trading-lab |
| HOCH | Fehlende VMs: DNS (106/108), TOR (110) | cluster-v5 | cluster-v4 |
| HOCH | OpenClaw Rollenmodell Bootstrap-->Monitor | cluster-v5 | cluster-v4 |
| HOCH | Social-Media: CONTENT_RELEASE_GUARDRAILS | Social-Media-Fabrik-v5 | Social-Media-Fabrik |
| MITTEL | Node-->Fabrik-Zuordnung (Node-4 = Trading) | cluster-v5 | cluster-v3 |
| MITTEL | Wahrheits-Hierarchie formal | alle v5-Repos | cluster-v3 |
| MITTEL | Multi-Case-Template-Ansatz | RefactorCo-Fabrik-v5 | RefactorCo-lab |
| MITTEL | Social-Media: CONTENT_PIPELINES | Social-Media-Fabrik-v5 | Social-Media-Fabrik |
| NIEDRIG | Out-of-Band VPS Sentinel | cluster-v5 | cluster-v3 |
| NIEDRIG | OpenWebUI vm-215 | cluster-v5 | cluster-v3 |

---

## Naechste konkrete Schritte (in dieser Reihenfolge)

1. **RefactorCo-Fabrik-v5**: PRODUCT_REQUEST_CONTRACT.md + kanonischen Workflow uebertragen
2. **Trading-Fabrik-v5**: VM-Rollen (101-108) + Live-Key-Guardrail als harte Regel einfuegen
3. **Social-Media-Fabrik-v5**: CONTENT_RELEASE_GUARDRAILS.md + VM-Rollen uebertragen
4. **cluster-v5**: Fehlende VMs (dns-106, dns-108, tor-110) + Node-->Fabrik-Zuordnung festlegen
5. **Alle v5-Repos**: Wahrheits-Hierarchie (Repo > Session > Chat) formal verankern

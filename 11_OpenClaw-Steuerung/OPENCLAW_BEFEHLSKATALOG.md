# OPENCLAW_BEFEHLSKATALOG
## Komplette Befehlsliste — 7 v5-Repos von oben nach unten abarbeiten

**Reihenfolge:** Jedes Repo hat eine nummerierte Befehlssequenz. 
Befehl 1 immer zuerst, dann der Reihe nach. 
Letzter Befehl jedes Repos = Session-Handoff mit den nächsten 10 Schritten.

**Wahrheitshierarchie:** GitHub-Repo > ZIP > Evidence > Legacy > Chat 
**Token (niemals in Chat!):** OpenClaw liest aus `/root/.openclaw/credentials.env`

**B0 - Session-Start (vollstaendig):** Fuer alle KI-Tools (OpenClaw, ChatGPT, Claude, Copilot). Laedt Kontext, orientiert sich aus letztem Handoff, arbeitet weiter, speichert Pflicht-Handoff.

**B1 - Schnellcheck:** Nur Status-Report, keine Aktion.

---

## REPO 1 — project-reloaded-cluster-v5

### B1 — Session-Start
```
Du arbeitest jetzt in project-reloaded-cluster-v5.
Lies zuerst README.md, dann docs/governance/WAHRHEITS_HIERARCHIE.md,
dann docs/nodes/NODE_FABRIK_ZUORDNUNG.md (falls vorhanden).
Sage mir in 3 Sätzen: (1) aktueller Wave-Stand, (2) nächster offener Schritt,
(3) welche Gate-Bedingungen noch fehlen.
```

### B2 — P1-Lücke: _ai/openclaw/sessions/ anlegen
```
Erstelle in project-reloaded-cluster-v5 den Ordner _ai/openclaw/sessions/
mit einer Platzhalterdatei _ai/openclaw/sessions/.gitkeep.
Erstelle außerdem _ai/openclaw/BOOTSTRAP.md mit folgendem Inhalt:
 Lesereihenfolge beim Session-Start:
 1. README.md
 2. docs/governance/WAHRHEITS_HIERARCHIE.md
 3. docs/nodes/NODE_FABRIK_ZUORDNUNG.md
 4. docs/vms/VM_ROLLEN.md
 5. _ai/openclaw/sessions/ — letzte 3 Session-Dateien lesen
 Scope: Bootstrap-Operator. Kein Produktivbetrieb ohne Wave-5-Gate.
Committe mit: "feat(wave3): _ai/openclaw Bootstrap-Struktur angelegt"
```

### B3 — P1-Lücke: AGENTS.md auf Root-Level
```
Erstelle in project-reloaded-cluster-v5 eine AGENTS.md im Root mit folgendem Inhalt:
 # AGENTS — Wer darf dieses Repo nutzen?
 OpenClaw (VM 100): Lesen + Schreiben (Bootstrap-Operator)
 Harte Regeln:
 - Keine stillen Scope-Änderungen
 - Repo-first: Chat-Aussagen niemals über Repo-Stand stellen
 - Kein Push auf main ohne Review bei Wave-4+
 - Token niemals in Code committen
 Lesereihenfolge: README → WAHRHEITS_HIERARCHIE → NODE_FABRIK_ZUORDNUNG → VM_ROLLEN
 Vorlage: trading-lab/AGENTS.md
Committe mit: "feat(wave3): AGENTS.md Root-Level hinzugefuegt"
```

### B4 — Legacy-Transfer: Node-4 Trading/Krypto-Sonderpfad
```
Lies cluster-docs/10_Legacy-Delta/LEGACY_DELTA_ANALYSE.md, Abschnitt
"project-reloaded-cluster-v3 --> project-reloaded-cluster-v5".
Erstelle in project-reloaded-cluster-v5:
 docs/nodes/NODE4_TRADING_SONDERPFAD.md
Inhalt:
 - Node-4 = Trading/Krypto/Ops/PWA-Sonderpfad (bestätigt aus v3)
 - Welche Fabriken auf Node-4 laufen (Trading-Fabrik-v5, RefactorCo)
 - Sicherheitsregel: Live-Keys nur auf vm-106 (Node-4)
 - Gate: kein Echtgeld ohne Trading-Fabrik Wave-4-Abschluss
Patche README.md: neue Datei in Startbefehl-Liste eintragen.
Committe mit: "feat(wave3): Node-4 Trading-Sonderpfad aus Legacy v3 uebernommen"
```

### B5 — Legacy-Transfer: Fehlende VMs Node-1 (DNS, TOR)
```
Prüfe ob docs/vms/FEHLENDE_VMS_NODE1.md in project-reloaded-cluster-v5 existiert.
Falls nicht: erstelle sie mit folgendem Inhalt aus LEGACY_DELTA_ANALYSE:
 vm-106 = DNS/Adblock (NOCH NICHT INSTALLIERT)
 vm-108 = DNS/Adblock Redundanz (NOCH NICHT INSTALLIERT)
 vm-110 = TOR/Privacy Egress (NOCH NICHT INSTALLIERT)
 Gate für Installation: OpenClaw Wave-4-Readiness-Check bestanden
Committe mit: "docs: fehlende VMs Node-1 dokumentiert (DNS, TOR)"
```

### B6 — Session-Handoff (immer letzter Befehl)
```
Erstelle _ai/openclaw/sessions/2026-04-16-cluster-v5-wave3.md mit:
 ## Was wurde heute gemacht
 - _ai/openclaw/BOOTSTRAP.md angelegt
 - _ai/openclaw/sessions/ Struktur erstellt
 - AGENTS.md Root-Level erstellt
 - NODE4_TRADING_SONDERPFAD.md aus Legacy v3 übernommen
 - FEHLENDE_VMS_NODE1.md geprüft/erstellt

 ## Aktueller Wave-Stand
 Wave 3.x — Legacy-Transfer läuft

 ## Nächste 10 Schritte (roter Faden für nächste Session)
 1. docs/installation/INSTALL_SEQUENCE.md erstellen (Reihenfolge der VM-Installationen)
 2. docs/installation/PREINSTALL_CHECKLIST.md erstellen (Hardware/Netzwerk/Credential-Gates)
 3. README.md Wave-Status auf 3.x setzen + alle neuen Dateien im Startbefehl eintragen
 4. Cluster-Control-v5 analog aufbauen (selbe P1-Schritte)
 5. Cross-Repo-Status-Tabelle in cluster-docs/08_Betrieb/CROSS_REPO_STATUS.md aktualisieren
 6. AGENTS.md in allen 7 v5-Repos anlegen (einheitliche Vorlage)
 7. _ai/openclaw/sessions/ in allen 7 v5-Repos anlegen
 8. BOOTSTRAP.md in allen 7 v5-Repos anlegen
 9. Node-5 Sonderpfad dokumentieren (falls vorhanden)
 10. Wave-4-Gate definieren: was muss erfüllt sein bevor Installation startet?

 ## Offene Gates
 - INSTALL_SEQUENCE.md fehlt noch → Wave-4-Gate nicht erfüllbar
 - vm-106/108/110 noch nicht installiert
Committe mit: "docs(session): Handoff 2026-04-16 cluster-v5 gespeichert"
```

---

## REPO 2 — Cluster-Control-v5

### B1 — Session-Start
```
Du arbeitest jetzt in Cluster-Control-v5.
Lies README.md, dann alle Dateien unter docs/governance/ und docs/nodes/.
Sage mir in 3 Sätzen: (1) Wave-Stand, (2) nächster Schritt, (3) offene Gates.
```

### B2 — P1: _ai-Struktur + AGENTS.md
```
Erstelle in Cluster-Control-v5:
 _ai/openclaw/sessions/.gitkeep
 _ai/openclaw/BOOTSTRAP.md (Lesereihenfolge: README → WAHRHEITS_HIERARCHIE →
 NODE_FABRIK_ZUORDNUNG → VM_ROLLEN → letzte 3 Session-Dateien)
 AGENTS.md (Root): OpenClaw darf lesen+schreiben. Repo-first. Kein Push ohne Review.
Committe mit: "feat(wave3): _ai Struktur + AGENTS.md angelegt"
```

### B3 — Legacy-Transfer: Node-Fabrik-Zuordnung prüfen
```
Prüfe ob docs/nodes/NODE_FABRIK_ZUORDNUNG.md in Cluster-Control-v5 existiert.
Falls nicht: erstelle sie. Inhalt aus cluster-docs und project-reloaded-cluster-v5:
 Node-1: Infrastruktur (OpenClaw, Firewall, DNS, TOR)
 Node-2: [Fabrik-Typ aus README oder cluster-docs]
 Node-3: [Fabrik-Typ]
 Node-4: Trading/Krypto/Ops/PWA-Sonderpfad
 Node-5: [Fabrik-Typ]
Patche README.md.
Committe mit: "feat(wave3): NODE_FABRIK_ZUORDNUNG aus cluster-v5 øbernommen"
```

### B4 — Session-Handoff
```
Erstelle _ai/openclaw/sessions/2026-04-16-cluster-control-wave3.md:
 ## Gemacht: _ai-Struktur, AGENTS.md, NODE_FABRIK_ZUORDNUNG geprüft
 ## Wave-Stand: 3.x
 ## Nächste 10 Schritte:
 1. INSTALL_SEQUENCE.md før Cluster-Control anlegen
 2. Orchestrierungs-Konzept dokumentieren (welche VM orchestriert welche)
 3. Monitoring-Konzept (wer beobachtet wer) in docs/betrieb/
 4. Failover-Prozedur (was passiert wenn vm-101 ausfällt) in docs/betrieb/
 5. Cross-Repo-Abhängigkeiten zu project-reloaded-cluster-v5 klären
 6. PREINSTALL_CHECKLIST.md mit Hardware-Gates
 7. Smoke-Tests pro VM definieren
 8. README Wave auf 4.x vorbereiten (Gate-Liste aufstellen)
 9. AGENTS.md Vorlage aus trading-lab vergleichen und anpassen
 10. Session-Handoff-Frequenz festlegen (nach jeder Session oder täglich?)
 ## Offene Gates: INSTALL_SEQUENCE fehlt, Monitoring-Konzept fehlt
Committe mit: "docs(session): Handoff 2026-04-16 cluster-control gespeichert"
```

---

## REPO 3 — Trading-Fabrik-v5

### B1 — Session-Start
```
Du arbeitest jetzt in Trading-Fabrik-v5.
Lies README.md, dann docs/governance/LIVE_KEY_GUARDRAIL.md,
dann docs/trading/TRADING_PROGRESSION.md (falls vorhanden).
Sage mir: (1) Wave-Stand, (2) sind Live-Keys explizit nur auf vm-106 gesperrt?,
(3) welche Trading-Stufe ist aktuell aktiv?
```

### B2 — P1: TRADING_PROGRESSION aus Legacy øbernehmen
```
Lies cluster-docs/10_Legacy-Delta/LEGACY_DELTA_ANALYSE.md, Abschnitt trading-lab.
Erstelle docs/trading/TRADING_PROGRESSION.md in Trading-Fabrik-v5:
 Stufe 1: Research (kein Echtgeld, nur Daten)
 Stufe 2: Replay (historische Simulation)
 Stufe 3: Walk-Forward (rollierende Validierung)
 Stufe 4: Shadow (Parallel-Paper-Trading, kein echtes Order-Routing)
 Stufe 5: Kontrollierte Micro-Live-Vorbereitung (Gate: alle vorherigen Stufen bestanden)
 Stufe 6: Micro-Live (max. Positionsgröße definiert, Stopp automatisch)
 AKTUELLER STAND: Stufe 1 (Research)
 Gate før nächste Stufe: [aus README oder leer lassen wenn unklar]
Patche README.md. Committe mit: "feat(wave3): TRADING_PROGRESSION aus trading-lab übernommen"
```

### B3 — P1: LIVE_KEY_GUARDRAIL härten
```
Prüfe docs/governance/LIVE_KEY_GUARDRAIL.md in Trading-Fabrik-v5.
Stelle sicher, dass diese 3 Regeln explizit drin stehen:
 1. Live-Keys AUSSCHLIESSLICH auf vm-106 — niemals in Code committen
 2. Live-Orderpfad AUSSCHLIESSLICH auf vm-106
 3. Keine stille Echtgeld-Freischaltung — Gate muss explizit bestätigt werden
Falls die Datei fehlt: erstelle sie mit diesen 3 Regeln.
Patche README.md. Committe mit: "feat(wave3): LIVE_KEY_GUARDRAIL aus trading-lab gehaertet"
```

### B4 — P1: _ai-Struktur + AGENTS.md
```
Erstelle in Trading-Fabrik-v5:
 _ai/openclaw/sessions/.gitkeep
 _ai/openclaw/BOOTSTRAP.md:
 Lesereihenfolge: README → LIVE_KEY_GUARDRAIL → TRADING_PROGRESSION →
 VM_ROLLEN → letzte 3 Sessions
 WARNUNG: Kein Zugriff auf vm-106 ohne explizite Operator-Freigabe!
 AGENTS.md (Root): Scope = Research+Dokumentation. Live-Keys nur Operator.
Committe mit: "feat(wave3): _ai Struktur + AGENTS.md Trading-Fabrik"
```

### B5 — Legacy-Transfer: VM-Rollen aus trading-lab
```
Lies cluster-docs/10_Legacy-Delta/LEGACY_DELTA_ANALYSE.md, VM-Tabelle trading-lab.
Prüfe docs/vms/VM_ROLLEN.md in Trading-Fabrik-v5.
Stelle sicher, dass diese Rollen eingetragen sind:
 vm-101: Governance/Audit/GitOps
 vm-102: Agent-Inference/lokaler Backbone
 vm-103: Market-Core
 vm-104: Research-Lab
 vm-105: Data/Observe
 vm-106: Exec-Gateway — LIVE KEYS NUR HIER
 vm-107: Ops-Portal/Trading-App-PWA-Basis
 vm-108: Heavy-Inference/große lokale Jobs
Committe mit: "docs: VM-Rollen aus trading-lab übernommen"
```

### B6 — Session-Handoff
```
Erstelle _ai/openclaw/sessions/2026-04-16-trading-fabrik-wave3.md:
 ## Gemacht: TRADING_PROGRESSION, LIVE_KEY_GUARDRAIL, _ai-Struktur, VM-Rollen
 ## Wave-Stand: 3.x — Legacy-Transfer abgeschlossen
 ## Nächste 10 Schritte:
 1. Selbstverbessernde Lernschleife konzipieren (fehlende harte Wahrheit aus Legacy)
 2. PHASED_ACTIVATION.md aus trading-lab übernehmen (was wann scharf geschaltet wird)
 3. LIVE_SWITCH_AND_SIM_STATE.md aus trading-lab übernehmen
 4. docs/installation/INSTALL_SEQUENCE.md für Trading-Fabrik erstellen
 5. Smoke-Tests für vm-103 (Market-Core) definieren
 6. Backtest-Reporting-Format dokumentieren
 7. Walk-Forward-Validierungs-Prozedur dokumentieren
 8. README Wave auf 4.x vorbereiten
 9. Cross-Repo-Link zu project-reloaded-cluster-v5/NODE4 einbauen
 10. Audit-Trail für alle Live-Key-Zugriffe definieren
 ## Offene Gates: Lernschleife fehlt, Wave-4 Gate noch nicht definiert
Committe mit: "docs(session): Handoff 2026-04-16 trading-fabrik gespeichert"
```

---

## REPO 4 — Social-Media-Fabrik-v5

### B1 — Session-Start
```
Du arbeitest jetzt in Social-Media-Fabrik-v5.
Lies README.md, dann docs/governance/CONTENT_RELEASE_GUARDRAILS.md,
dann alle Dateien unter docs/content/ (falls vorhanden).
Sage mir: (1) Wave-Stand, (2) ist das K-R Bundle-System dokumentiert?,
(3) was ist der nächste offene Schritt?
```

### B2 — P1: CONTENT_PIPELINES aus Legacy übernehmen
```
Lies cluster-docs/10_Legacy-Delta/LEGACY_DELTA_ANALYSE.md, Abschnitt Social-Media-Fabrik.
Erstelle docs/content/CONTENT_PIPELINES.md in Social-Media-Fabrik-v5:
 Pipeline 1: Rohdaten → Content-Brief (Research-Phase)
 Pipeline 2: Brief → Entwurf (Draft-Phase, KI-generiert)
 Pipeline 3: Entwurf → Review (menschliche Prüfung — Gate!)
 Pipeline 4: Review → Scheduling (Planung ohne Freigabe nicht möglich)
 Pipeline 5: Scheduling → Publish (nur nach expliziter Freigabe)
 K-R Bundle-System: [aus Legacy-Repo beschreiben oder Platzhalter]
 Block-Derivation: [aus Legacy-Repo beschreiben oder Platzhalter]
Patche README.md. Committe mit: "feat(wave3): CONTENT_PIPELINES aus Legacy übernommen"
```

### B3 — P1: Session-Docs aufräumen (war 22 PR-Sessions unkontrolliert)
```
Prüfe ob _ai/openclaw/sessions/ in Social-Media-Fabrik-v5 bereits Dateien hat.
Wenn ja: stelle sicher, dass jede Datei dem Schema [DATUM]-[THEMA].md folgt.
Wenn nein: erstelle _ai/openclaw/sessions/.gitkeep.
Erstelle _ai/openclaw/BOOTSTRAP.md:
 Lesereihenfolge: README → CONTENT_RELEASE_GUARDRAILS → CONTENT_PIPELINES →
 VM_ROLLEN → letzte 3 Sessions
 REGEL: Kein Auto-Publish. Jede Veröffentlichung braucht explizite Gate-Bestätigung.
Committe mit: "feat(wave3): _ai Struktur Social-Media-Fabrik, Session-Aufräum-Convention"
```

### B4 — P1: AGENTS.md
```
Erstelle AGENTS.md (Root) in Social-Media-Fabrik-v5:
 OpenClaw: Darf Inhalte entwerfen, NICHT veröffentlichen.
 Veröffentlichungs-Gate: Immer menschliche Bestätigung.
 Auto-Publish ist VERBOTEN — auch wenn KI sicher ist.
 Lesereihenfolge: README → CONTENT_RELEASE_GUARDRAILS → CONTENT_PIPELINES
Committe mit: "feat(wave3): AGENTS.md Social-Media-Fabrik"
```

### B5 — Legacy-Transfer: K-R Bundle-System dokumentieren
```
Lies cluster-docs/10_Legacy-Delta/LEGACY_DELTA_ANALYSE.md, Social-Media-Fabrik-Abschnitt.
Erstelle docs/content/KR_BUNDLE_SYSTEM.md in Social-Media-Fabrik-v5:
 Was ist ein K-R Bundle? (Knowledge-Resource Bundle)
 Wie wird Block-Derivation angewendet?
 Welche Content-Typen gibt es?
 Qualitätssicherung vor Publish.
Falls Legacy-Details unklar sind: Platzhalter mit [TODO: aus Legacy lesen].
Committe mit: "feat(wave3): K-R Bundle System aus Legacy dokumentiert"
```

### B6 — Session-Handoff
```
Erstelle _ai/openclaw/sessions/2026-04-16-social-media-wave3.md:
 ## Gemacht: CONTENT_PIPELINES, _ai-Struktur, AGENTS.md, KR_BUNDLE_SYSTEM
 ## Wave-Stand: 3.x
 ## Nächste 10 Schritte:
 1. Block-Derivation-System vollständig dokumentieren (aus Legacy lesen)
 2. Scheduling-Konzept (welcher Content wann auf welchem Kanal) erstellen
 3. Kanal-Übersicht (Plattformen, Formate, Limits) in docs/channels/ anlegen
 4. Content-Review-Prozess mit Checkboxen formalisieren
 5. INSTALL_SEQUENCE.md für Social-Media-Fabrik VMs
 6. Monitoring: wann gilt ein Post als erfolgreich? (KPIs dokumentieren)
 7. README Wave auf 4.x vorbereiten
 8. 22 alte PR-Sessions aus Legacy archivieren oder löschen
 9. Prompt-Bibliothek _ai/openclaw/prompts/ anlegen (P2)
 10. Cross-Repo-Link: welche Fabrik liefert Input für Social-Media-Content?
 ## Offene Gates: Block-Derivation unvollständig, KPIs nicht definiert
Committe mit: "docs(session): Handoff 2026-04-16 social-media gespeichert"
```

---

## REPO 5 — Marketing-Fabrik-v5

### B1 — Session-Start
```
Du arbeitest jetzt in Marketing-Fabrik-v5.
Lies README.md und alle Dateien unter docs/governance/.
Sage mir: (1) Wave-Stand, (2) welche Marketing-Kanäle sind dokumentiert?,
(3) nächster offener Schritt?
```

### B2 — P1: _ai-Struktur + AGENTS.md
```
Erstelle in Marketing-Fabrik-v5:
 _ai/openclaw/sessions/.gitkeep
 _ai/openclaw/BOOTSTRAP.md:
 Lesereihenfolge: README → WAHRHEITS_HIERARCHIE → VM_ROLLEN →
 docs/product/ → letzte 3 Sessions
 AGENTS.md (Root): OpenClaw = Content-Ersteller, kein Auto-Publish,
 kein Zugriff auf Werbekonten ohne Gate
Committe mit: "feat(wave3): _ai Struktur + AGENTS.md Marketing-Fabrik"
```

### B3 — P1: Marketing-Funnel dokumentieren
```
Erstelle docs/marketing/MARKETING_FUNNEL.md in Marketing-Fabrik-v5:
 Stufe 1: Awareness (Zielgruppe, Kanäle, Budget-Gate)
 Stufe 2: Interest (Content-Typen, KPIs)
 Stufe 3: Decision (Conversion-Trigger, Landing-Pages)
 Stufe 4: Action (CTA-Typen, Tracking)
 Automatisierungs-Grenze: was darf OpenClaw alleine, was braucht Gate?
Patche README.md. Committe mit: "feat(wave3): MARKETING_FUNNEL dokumentiert"
```

### B4 — Session-Handoff
```
Erstelle _ai/openclaw/sessions/2026-04-16-marketing-fabrik-wave3.md:
 ## Gemacht: _ai-Struktur, AGENTS.md, MARKETING_FUNNEL
 ## Wave-Stand: 3.x
 ## Nächste 10 Schritte:
 1. Kanal-Matrix erstellen: welcher Content auf welchem Kanal
 2. Budget-Guardrail dokumentieren (Werbekosten-Gates)
 3. A/B-Test-Protokoll für Kampagnen
 4. Schnittstelle zu Social-Media-Fabrik-v5 dokumentieren
 5. Schnittstelle zu Ebook-Fabrik-v5 dokumentieren (Leadmagnet-Funnel)
 6. INSTALL_SEQUENCE.md für Marketing-VMs
 7. CRM-Integration dokumentieren (falls vorhanden)
 8. README Wave auf 4.x vorbereiten
 9. Prompt-Bibliothek _ai/openclaw/prompts/ anlegen
 10. Kampagnen-Archiv-Struktur festlegen
 ## Offene Gates: Budget-Guardrail fehlt
Committe mit: "docs(session): Handoff 2026-04-16 marketing-fabrik gespeichert"
```

---

## REPO 6 — Ebook-Fabrik-v5

### B1 — Session-Start
```
Du arbeitest jetzt in Ebook-Fabrik-v5.
Lies README.md und alle docs/governance/ Dateien.
Sage mir: (1) Wave-Stand, (2) ist der Ebook-Produktionsprozess dokumentiert?,
(3) nächster Schritt?
```

### B2 — P1: _ai-Struktur + AGENTS.md
```
Erstelle in Ebook-Fabrik-v5:
 _ai/openclaw/sessions/.gitkeep
 _ai/openclaw/BOOTSTRAP.md:
 Lesereihenfolge: README → WAHRHEITS_HIERARCHIE → VM_ROLLEN → letzte 3 Sessions
 AGENTS.md (Root): OpenClaw = Ebook-Autor/Strukturierer.
 Kein Auto-Publish. Jedes Ebook braucht menschliche Endkontrolle.
Committe mit: "feat(wave3): _ai Struktur + AGENTS.md Ebook-Fabrik"
```

### B3 — P1: Ebook-Produktionspipeline
```
Erstelle docs/production/EBOOK_PIPELINE.md in Ebook-Fabrik-v5:
 Phase 1: Thema + Zielgruppe definieren (Gate: Freigabe)
 Phase 2: Inhaltsstruktur (TOC) erstellen (Gate: Freigabe)
 Phase 3: Kapitel schreiben (KI-Entwurf, menschliches Review)
 Phase 4: Lektorat + Formatierung
 Phase 5: Cover + Metadaten
 Phase 6: Export (PDF, EPUB)
 Phase 7: Publish (nur nach Gate-Bestätigung)
 Schnittstelle: Marketing-Fabrik liefert Themen, Ebook geht zurück als Leadmagnet
Patche README.md. Committe mit: "feat(wave3): EBOOK_PIPELINE dokumentiert"
```

### B4 — Session-Handoff
```
Erstelle _ai/openclaw/sessions/2026-04-16-ebook-fabrik-wave3.md:
 ## Gemacht: _ai-Struktur, AGENTS.md, EBOOK_PIPELINE
 ## Wave-Stand: 3.x
 ## Nächste 10 Schritte:
 1. Themen-Backlog-Format festlegen (wie werden Ebook-Ideen erfasst?)
 2. Cover-Design-Workflow dokumentieren
 3. Export-Formate und Qualitäts-Gate definieren
 4. Schnittstelle zu Marketing-Fabrik formalisieren
 5. Schnittstelle zu Social-Media-Fabrik (Ebook-Snippets als Posts)
 6. INSTALL_SEQUENCE.md für Ebook-VMs
 7. KPI-Tracking: Was gilt als erfolgreiches Ebook?
 8. Archiv-Struktur für fertige Ebooks
 9. README Wave auf 4.x vorbereiten
 10. Prompt-Bibliothek _ai/openclaw/prompts/ anlegen
 ## Offene Gates: Export-Qualitäts-Gate nicht definiert
Committe mit: "docs(session): Handoff 2026-04-16 ebook-fabrik gespeichert"
```

---

## REPO 7 — RefactorCo-Fabrik-v5

### B1 — Session-Start
```
Du arbeitest jetzt in RefactorCo-Fabrik-v5.
Lies README.md, dann docs/operators/OPENCLAW_START_COMMAND.md (das existiert hier!),
dann docs/governance/WAHRHEITS_HIERARCHIE.md.
Sage mir: (1) Wave-Stand, (2) welche Refactoring-Cases (A-G) sind dokumentiert?,
(3) nächster offener Schritt?
```

### B2 — P1: PRODUCT_REQUEST_CONTRACT aus Legacy übernehmen
```
Lies cluster-docs/10_Legacy-Delta/LEGACY_DELTA_ANALYSE.md, RefactorCo-Abschnitt.
Erstelle docs/product/PRODUCT_REQUEST_CONTRACT.md in RefactorCo-Fabrik-v5:
 Was ist ein Product-Request? (Eingabe-Format)
 Wer darf einen Request stellen?
 Welche Informationen sind Pflicht?
 Wie wird priorisiert?
 Gate vor Bearbeitung: Vollständigkeit-Check
 Ablehnungs-Kriterien (was wird nicht bearbeitet)
 Vorlagen aus RefactorCo-lab Multi-Case-System A-G übernehmen
Patche README.md. Committe mit: "feat(wave3): PRODUCT_REQUEST_CONTRACT aus RefactorCo-lab"
```

### B3 — P1: CANONICAL_WORKFLOW aus Legacy
```
Erstelle docs/workflows/CANONICAL_WORKFLOW.md in RefactorCo-Fabrik-v5:
 Schritt 1: Request eingang + Validierung
 Schritt 2: Analyse (Code lesen, Probleme identifizieren)
 Schritt 3: Refactoring-Plan erstellen (Gate: Freigabe)
 Schritt 4: Refactoring durchführen
 Schritt 5: Tests laufen lassen (Gate: alle Tests grün)
 Schritt 6: PR erstellen + Review
 Schritt 7: Merge + Dokumentation
 Multi-Case A-G: [aus RefactorCo-lab lesen und eintragen]
Committe mit: "feat(wave3): CANONICAL_WORKFLOW aus RefactorCo-lab übernommen"
```

### B4 — P1: _ai-Struktur + AGENTS.md
```
Erstelle in RefactorCo-Fabrik-v5:
 _ai/openclaw/sessions/.gitkeep
 _ai/openclaw/BOOTSTRAP.md:
 Lesereihenfolge: README → OPENCLAW_START_COMMAND → WAHRHEITS_HIERARCHIE →
 PRODUCT_REQUEST_CONTRACT → CANONICAL_WORKFLOW → letzte 3 Sessions
 Hinweis: RefactorCo hat als einziges Repo bereits OPENCLAW_START_COMMAND.md —
 dieses Muster auf alle anderen Repos ausrollen!
 AGENTS.md (Root): OpenClaw = Analyse + Refactoring-Entwurf.
 Kein Merge auf main ohne Tests + Review-Gate.
Committe mit: "feat(wave3): _ai Struktur + AGENTS.md RefactorCo-Fabrik"
```

### B5 — Session-Handoff
```
Erstelle _ai/openclaw/sessions/2026-04-16-refactorco-wave3.md:
 ## Gemacht: PRODUCT_REQUEST_CONTRACT, CANONICAL_WORKFLOW, _ai-Struktur, AGENTS.md
 ## Wave-Stand: 3.x
 ## Nächste 10 Schritte:
 1. Multi-Case-System A-G vollständig aus RefactorCo-lab dokumentieren
 2. Test-Framework-Anforderungen definieren (welche Tests müssen grün sein?)
 3. Code-Qualitäts-Metriken festlegen
 4. OPENCLAW_START_COMMAND.md als Muster auf alle 6 anderen Repos ausrollen
 5. PR-Template erstellen
 6. Schnittstelle zu anderen Fabriken (wer fordert Refactoring an?)
 7. INSTALL_SEQUENCE.md für RefactorCo-VMs
 8. README Wave auf 4.x vorbereiten
 9. Prompt-Bibliothek _ai/openclaw/prompts/ anlegen
 10. Retrospektive: was waren häufigste Refactoring-Requests in Legacy? Muster ableiten.
 ## Offene Gates: Test-Framework nicht definiert, Multi-Case A-G unvollständig
Committe mit: "docs(session): Handoff 2026-04-16 refactorco gespeichert"
```

---

## CLUSTER-WEIT: Nachdem alle 7 Repos Wave 3.x abgeschlossen haben

### CW1 — Cross-Repo-Status aktualisieren
```
Klone alle 7 v5-Repos nach /tmp/.
Erstelle eine Tabelle in cluster-docs/08_Betrieb/CROSS_REPO_STATUS.md:
 Repo | Wave | _ai/sessions vorhanden | AGENTS.md vorhanden | offene P1-Gates | letzte Aktivität
 Fülle sie aus dem aktuellen Stand der Repos.
Committe in cluster-docs mit: "docs: CROSS_REPO_STATUS 2026-04-16 aktualisiert"
```

### CW2 — OPENCLAW_START_COMMAND.md in alle Repos ausrollen
```
Lies docs/operators/OPENCLAW_START_COMMAND.md aus RefactorCo-Fabrik-v5.
Erstelle eine angepasste Version davon in allen 6 anderen v5-Repos unter
docs/operators/OPENCLAW_START_COMMAND.md.
Jede Version muss auf das jeweilige Repo angepasst sein (Scope, VM-Rollen, Lesereihenfolge).
Patche README.md jedes Repos.
Committe pro Repo mit: "feat(wave3): OPENCLAW_START_COMMAND.md ausgerollt"
```

### CW3 — Wave-4-Readiness prüfen
```
Lies alle 7 README.md-Dateien.
Prüfe pro Repo: Sind alle Wave-3-Gates erfüllt?
 - WAHRHEITS_HIERARCHIE.md vorhanden ✓/✗
 - VM_ROLLEN.md vorhanden ✓/✗
 - Legacy-P1-Transfer abgeschlossen ✓/✗
 - AGENTS.md vorhanden ✓/✗
 - _ai/openclaw/sessions/ vorhanden ✓/✗
 - BOOTSTRAP.md vorhanden ✓/✗
Erstelle cluster-docs/08_Betrieb/WAVE4_READINESS.md mit der Ergebnistabelle.
```

---

## VORLAGE: Session-Handoff-Generator

**Diesen Befehl am Ende JEDER Session verwenden:**

```
Erstelle _ai/openclaw/sessions/[DATUM]-[REPO]-[THEMA].md mit folgendem Schema:

## Session-Info
Datum: [DATUM]
Repo: [REPO-NAME]
Bearbeitet von: OpenClaw

## Was wurde heute gemacht
[Liste der Commits und Dateien]

## Aktueller Wave-Stand
Wave [X.x] — [Kurzbeschreibung was das bedeutet]

## Offene Gates (was blockt nächste Wave)
[Liste der noch offenen Gate-Bedingungen]

## Nächste 10 Schritte (roter Faden für nächste Session)
1. [Schritt 1 — spezifisch und ausführbar]
2. [Schritt 2]
3. [Schritt 3]
4. [Schritt 4]
5. [Schritt 5]
6. [Schritt 6]
7. [Schritt 7]
8. [Schritt 8]
9. [Schritt 9]
10. [Schritt 10]

## Wichtige Entscheidungen dieser Session
[Was wurde entschieden, was nicht rückgängig gemacht werden soll]

## Warnungen før nächste Session
[Was ist heikel, worauf aufpassen]

Committe mit: "docs(session): Handoff [DATUM] [REPO] gespeichert"
```

---

*Stand: 2026-04-16 | Gilt før alle 7 v5-Repos | Basis: LEGACY_DELTA_ANALYSE.md + LEGACY_STEUERUNG_VERGLEICH.md*


---

## CLUSTER-WEITE PHASEN-BEFEHLE

### CW4 — Fabrik-Abschluss-Check

```
Pruefe ob REPO_NAME standalone fertig ist.
Lies: README.md, docker-compose.yml (falls vorhanden), inventory/READINESS_SCORECARD.yaml.
Berichte:
  (1) Welche Kernfunktionen fehlen noch?
  (2) Ist ein .env.example vorhanden?
  (3) Gibt es einen funktionierenden Health-Check?
  (4) Was ist der naechste konkrete Schritt bis zur Install-Fertigkeit?
Keine Aktion, kein Commit. Nur Analyse.
```

### CW5 — Legacy-Migration (Funktion uebernehmen)

```
Migriere Funktion FUNKTION_NAME aus Legacy-Repo LEGACY_REPO nach ZIEL_REPO.
Vorgehen:
  1. Lies LEGACY_REPO/[Pfad zur Funktion]
  2. Verstehe was sie tut — nicht blind kopieren
  3. Passe die Logik an die v5-Struktur an
  4. Schreibe sie in ZIEL_REPO/[Zielpfad]
  5. Aktualisiere relevante Tests und Imports
  6. Pflicht-Abschluss: Committe mit "feat: [FUNKTION_NAME] aus Legacy migriert"
Repo-first gilt: Keine Aenderung ohne Commit.
```

### CW6 — Cluster-Integration (Fabrik einbinden)

```
Binde FABRIK_NAME in project-reloaded-cluster-v5 ein.
Vorgehen:
  1. Lies FABRIK_NAME/README.md und docker-compose.yml
  2. Lies project-reloaded-cluster-v5/README.md und CLUSTER_ROADMAP.md
  3. Erstelle/aktualisiere cluster-compose-Eintrag fuer FABRIK_NAME
  4. Pruefe Service-Discovery-Konfiguration
  5. Aktualisiere CLUSTER_ROADMAP.md Checkliste (Phase 3, Zeile FABRIK_NAME)
  6. Pflicht-Abschluss: Committe mit "feat: FABRIK_NAME in Cluster integriert"
```

### CW7 — Service-Konsolidierung

```
Analysiere alle 6 Fabriken auf doppelte Dienste.
Lies jeweils: docker-compose.yml oder Helm-Chart.
Berichte:
  (1) Welche Dienste laufen in mehr als 2 Fabriken identisch?
  (2) Sind die Konfigurationen kompatibel (gleiche Version, gleiche Flags)?
  (3) Welche koennen sicher zentralisiert werden, welche nicht?
  (4) Geschaetzte VM-Einsparung nach Konsolidierung?
Erstelle danach einen Konsolidierungsplan in Cluster-Control-v5/CONSOLIDATION_PLAN.md.
Pflicht-Abschluss: Committe Plan mit "docs: Service-Konsolidierungsplan erstellt"
```


---

## NW1 — Netzwerk-Audit (Alle Geräte prüfen)

**Zweck:** Prüft Erreichbarkeit und Status aller Netzwerkgeräte im Cluster. Kein Login, kein Schreibzugriff — reine Statusprüfung.

**Wann verwenden:** Vor größeren Konfigurationsänderungen, nach Neustart, bei Konnektivitätsproblemen.

**Ablauf:**
1. Lade Zugangsdaten aus `/root/.openclaw/credentials.env`
2. Prüfe jeden Endpunkt per HTTP HEAD oder ping:
 - UniFi Controller: `https://192.168.1.1`
 - OPNsense Master: `http://192.168.1.49`
 - OPNsense Backup/HA: `http://192.168.1.50`
 - Pi-hole 1: `http://10.6.7.16`
 - Pi-hole 2: `http://10.6.7.17`
 - TP-Link Switch: `http://192.168.1.74`
3. Zeige für jedes Gerät: ERREICHBAR / NICHT ERREICHBAR + HTTP-Statuscode
4. Bei Problemen: beschreibe was fehlt und schlage Fix vor
5. Bestätige mit: `NW1_AUDIT_DONE` oder liste offene Probleme

**Hinweis:** Dieser Befehl ist der Pflicht-Einstieg vor allen NW2-NW9 Netzwerk-Konfigurationsbefehlen.

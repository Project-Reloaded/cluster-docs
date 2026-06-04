# KNOWLEDGE_CONTINUITY_LAYER

**Status:** PHASE 1 TEILWEISE LIVE-IDLE — Repo-Auth und Frontend noch offen  
**Stand:** 2026-05-08

## A) Zweck
Dieses Dokument beschreibt den **cluster-weiten Knowledge-Continuity-Layer** fuer alle 7 v5-Fabriken plus `cluster-docs`.

Ziel:
- der **rote Faden** bei der Arbeit darf nie verloren gehen
- Schritte, Entscheidungen, Handoffs und Sessions bleiben persistent gespeichert
- Arbeit soll jederzeit **nahtlos wiederaufnehmbar** sein
- Repo-, Session-, Wiki- und Sicht-Ebene sollen zusammen einen belastbaren Kontinuitaetsrahmen bilden

## B) Problem
`RefactorCo-lab` belegt bereits eine **Innen-Repo-Continuity**:
- `docs/operators/CHATGPT_START_COMMAND.md`
- `_ai/openclaw/sessions/`
- `_ai/openclaw/BOOTSTRAP.md`
- Obsidian-Templates in `vm-104`

Diese Bausteine loesen aber nur einen Teil des Problems:
- sie sichern den roten Faden **innerhalb eines Repos**
- sie bilden **keinen cluster-weiten Cross-Repo-Layer**
- sie enthalten **keinen Quartz-/Wiki-Sync als gemeinsame Sichtschicht**

Der v5-Cluster braucht deshalb zusaetzlich:
- eine gemeinsame Wissensschicht ueber mehrere Repos hinweg
- eine saubere Cross-Repo-Verlinkung
- eine dauerhafte Wiki-/Vault-/Portal-Sicht fuer Menschen und Agenten

## C) Komponenten
### 1. Obsidian-Vault als zentraler Knowledge-Pool
Ein gemeinsamer Obsidian-Vault dient als cluster-weiter Wissensspeicher.
Alle 7 v5-Repos plus `cluster-docs` haengen sich in diesen Wissensraum ein.

Ziel:
- Session-Handoffs, Architekturentscheidungen, Mapping-Notizen und Cross-Repo-Referenzen gebuendelt sichtbar machen
- Repo-first beibehalten, aber einen stabilen Wissens-Rueckraum schaffen

### 2. Quartz fuer statische Veroeffentlichung
Quartz dient als statische Wiki-/Dokuseite ueber dem Vault.
So wird aus Repo-Wissen eine lesbare, verlinkte und dauerhafte Sichtschicht.

Ziel:
- statische Veroeffentlichung des Wissensstands
- saubere Navigierbarkeit ueber Repos, Fabriken, VMs und Betriebsdoku hinweg

### 3. obsidian-wiki bzw. GitHub-Wiki-Sync
Ein automatischer Sync soll Repo-Wissen in eine Wiki-Sicht ueberfuehren.
Das kann ueber `obsidian-wiki`, GitHub Wiki oder einen vergleichbaren Repo-getriebenen Exportpfad erfolgen.

Ziel:
- kein isolierter Notizfriedhof
- Wiki-Inhalte bleiben aus Repo-Quellen ableitbar
- Wissenssicht bleibt aktualisierbar und reproduzierbar

### 4. `_ai/openclaw/sessions/` als Cluster-Standard
Das Session-Muster aus `RefactorCo-lab` wird in **jedes v5-Repo** uebernommen.

Ziel:
- jede produktive Session hinterlaesst einen nachvollziehbaren Handoff
- Arbeitskontext bleibt dateibasiert statt chatbasiert
- naechste Sessions koennen direkt am letzten sauberen Punkt weiterarbeiten

### 5. `_ai/openclaw/BOOTSTRAP.md` cluster-weit
Das BOOTSTRAP-Muster wird cluster-weit ausgerollt.
Die konkrete Ausrollung ist bereits als eigenes Folgepaket vorgesehen (Task 7 in `NEXT_10`).

Ziel:
- jede neue Session startet mit derselben belastbaren Lesereihenfolge
- Repo-Kanon steht immer ueber Chat-Gedaechtnis

### 6. Cross-Repo-Wikilinks
Zwischen allen 7 v5-Fabriken und `cluster-docs` werden gezielte Querverweise aufgebaut.

Ziel:
- Architektur-, VM-, Operator- und Abhaengigkeitswissen nicht mehrfach isoliert pflegen
- ein Fabrik-Repo kann auf kanonische Cluster- oder Schwester-Doku verweisen
- der rote Faden wird nicht an Repo-Grenzen zerschnitten

## D) Tagebuch-Doktrin
### Klaus-Definition
`vm-112` ist das **Arbeitsgedaechtnis fuer OpenClaw plus Klaus**.
Dafuer werden alle **8 Repos** in einen gemeinsamen Wissensraum eingebunden:
- `cluster-docs`
- die 7 v5-Fabriken

Pro Fabrik gehoeren dort mindestens hinein:
- **Tagebuch**
- **Workflow**
- **Roadmap**
- **Befehle**

Arbeitsregel:
- OpenClaw schaut auf `vm-112` nach, **wenn etwas im laufenden Repo nicht klar genug ist**
- Repo-first bleibt erhalten, aber `vm-112` ist der zentrale Rueckraum fuer Verlauf, Kontext und Wiedereinstieg
- das Tagebuch ist damit **keine Parallel-Wahrheit**, sondern ein operatives Arbeitsgedaechtnis

## E) Sicht- und Bedien-Schicht (PWA)
Ergaenzend zur Repo-/Wiki-/Vault-Schicht soll pro Fabrik eine **Steuerungs-PWA** entstehen.

Fachliche Leitlinie:
- `vm-307` in RefactorCo ist die erste kanonische Zielrolle fuer diese Sichtschicht
- das Schwester-Pattern soll spaeter auch fuer andere Fabriken nutzbar werden

Beleg aus `RefactorCo-lab`:
- statische PWA
- Nginx als leichtgewichtiger Auslieferungspfad
- `manifest.webmanifest`
- `sw.js`
- Standalone-Install

Erweiterte Sicht:
- Multi-Produktfall-Sicht mit Typen wie `web_app`, `pwa`, `fitness_app`, `reminder_app`, `iphone_app`
- Bedienung ueber **Handy, Tablet und Laptop**

Rolle der PWA:
- Sicht- und Bedienebene
- keine Wahrheitsersatz-Schicht
- kein Ersatz fuer Repo, Review, Testbed oder Freigabe

## F) vm-112 Phase 1 — Stand 2026-05-08
### Ist-Stand
- **VM:** `vm-112-knowledge-portal`
- **IP:** `10.6.7.22`
- **Basis:** Debian 13 LXC
- **Laufzeit:** Node.js 22, nginx, Quartz v4
- **CLI-Helfer:** `ripgrep`, `fzf`, `bat`, `restic`
- **Timer aktiv:** `sync-repos.timer`, `quartz-build.timer`, `healthcheck.timer`
- **Tagebuch-Skelette:** 7 Fabrik-Skelette unter `/srv/knowledge/tagebuch`
- **Repo-Zielpfad:** `/srv/knowledge/repos` = **deferred bis Auth**
- **Health:** `/health` liefert JSON
- **Raw-Sicht:** `/raw/` mit Autoindex auf `/srv/knowledge`

### Bewusste Grenzen
- **AnythingLLM / RAG-Layer** bleibt vorerst **deferred**
- Grund: **Node-1-Leichtgewichts-Doktrin**
- `vm-112` hat nur **2 GB RAM**
- Power-Komponenten gehoeren auf **andere Nodes**, nicht in diese leichte Wissens-VM

### Klaus-Decisions offen
- **B3:** Repo-Auth via **PAT oder Deploy-Key**
- **B4:** HAProxy-Frontend `wiki.project-reloaded.org -> vm-112:80`

## G) Phasen-Plan
### Phase A — Session-Persistence
- `_ai/openclaw/sessions/` in alle 7 v5-Repos bringen
- cluster-weite `BOOTSTRAP.md`-Muster angleichen
- Handoff-/Neustart-Pfade standardisieren

### Phase B — zentraler Wissensraum
- Obsidian-Vault aufbauen
- Quartz hosten
- Cross-Repo-Linking zwischen den Fabriken und `cluster-docs` herstellen
- Wiki-/Export-Sicht aus Repo-Quellen ableiten

### Phase C — PWA-Portierung
- PWA-Pack aus `RefactorCo-lab/vm-107` bzw. der spaeteren RefactorCo-v5-Pendant-Rolle in weitere Fabriken portieren
- gemeinsame Sicht-/Statuskarten angleichen
- mobile Bedienmuster vereinheitlichen

## H) Verbindung zu `MODEL_ACCESS_ARCHITECTURE.md`
Der Knowledge-Continuity-Layer und die Modell-Zugriffs-Architektur ergaenzen sich, loesen aber **verschiedene Probleme**:

- `MODEL_ACCESS_ARCHITECTURE.md` regelt, **wie** Agenten und VMs technisch auf Modelle zugreifen
- `KNOWLEDGE_CONTINUITY_LAYER.md` regelt, **wie** Wissen, Handoffs, Kontexte und Entscheidungen dauerhaft erhalten bleiben

Gemeinsame Leitidee:
- Agenten duerfen nicht nur rechnen, sondern muessen ihren Arbeitsstand nachvollziehbar hinterlassen
- Modellrouting ohne Wissenskontinuitaet fuehrt zu Kontextverlust
- Wissenskontinuitaet ohne saubere Modellschicht fuehrt zu operativer Uneinheitlichkeit

Beide Dokumente gehoeren daher zusammen in die cluster-weite Architektur-Doktrin.

## I) Grenzen
Dieses Dokument ist eine **Doktrin- und Architekturvorgabe** mit einem teilweise bereits laufenden **Phase-1-Basisstand**, aber noch **keine** vollstaendig ausgerollte Cluster-Implementierung.

Noch offen bzw. nicht fertig belegt als cluster-weit produktiv:
- Repo-Auth fuer alle 8 Repos auf `vm-112`
- kompletter Pull aller Repos nach `/srv/knowledge/repos`
- HAProxy-Frontend auf `wiki.project-reloaded.org`
- AnythingLLM-/RAG-Layer
- PWA-Portierung in alle Fabriken

## J) Status
**PHASE 1 TEILWEISE LIVE-IDLE — Basis laeuft, Vollausbau noch offen.**
## K) Session-Hygiene & Context-Engineering-Doktrin

> Zweck: Token-Verbrauch senken und Agenten-Qualitaet ueber lange Laeufe stabil halten -- verbindlich fuer alle Cluster-Agenten (OpenClaw, Paperclip-/HQ-Agenten, jeder kuenftige Agent). Bewusst runtime-agnostisch formuliert.
> Quellen: destilliert aus muratcankoylan/Agent-Skills-for-Context-Engineering (MIT), Skills context-compression, context-optimization, filesystem-context, memory-systems. Adaption auf Cluster-Kontext.

Durchsetzung in drei Schichten: (1) Master-Invariant 7 in AGENT_SYSTEM.md bindet alle Agenten, die den Master erben; (2) AGENT_SPECIALIZATION-Template + diese Bootstrap-Doktrin binden jede kuenftig neu angelegte Fabrik; (3) das LiteLLM-Gateway (vm-110) ist die harte mechanische Grenze -- jeder Token fliesst durch das Gateway, ein Budget/Cache dort bindet jeden Agenten unabhaengig davon, ob er die Doktrin gelesen hat. Schicht 1+2 sind Verhaltensregeln, Schicht 3 ist die Garantie. Nur alle drei zusammen wirken.

### Die Regeln

1. Eine Aufgabe = eine Session. Auftrag fertig -> Handoff schreiben -> Session beenden. Neue Aufgabe -> frische Session, die zuerst den Handoff liest. Keine 200k-Session ueber mehrere Aufgaben weiterschleppen. In einer Agent-Schleife wird bei jedem Turn der gesamte Kontext neu mitgeschickt und bezahlt -- eine aufgeblaehte Session multipliziert die Kosten ueber jeden Folge-Turn.

2. Kontext-Schwellwert als Ausloeser. Bei 70-80% Kontext-Auslastung handeln, nicht erst bei 90%+ (Compaction unter Druck verliert genau die kritischen Details). Reihenfolge: erst maskieren (Bulk raus), dann kompaktieren (Rest zusammenfassen), dann ggf. frische Session.

3. Tool-Output in Dateien auslagern, nicht in den Kontext. Outputs > ~2000 Token (Downloads-Progress, Logs, lange Suchergebnisse, Terminal-Dumps) -> in eine Datei schreiben, nur kompakte Referenz + Kurz-Zusammenfassung in den Kontext zurueckgeben, bei Bedarf per grep/Zeilenbereich gezielt nachladen. Tool-Outputs sind 80%+ der Token in typischen Agent-Laeufen -- der groesste Hebel.

4. Strukturierter Handoff statt Freitext. Der Handoff ist die einzige Bruecke zwischen Session-Ende und naechstem Start -- ein schlechter Handoff verliert Kontext genauso wie verlustbehaftete Compaction. Pflicht-Abschnitte:

```markdown
## Auftrag / Intent
[Was sollte erreicht werden]

## Verifizierbarer Stand
[Was laeuft nachweislich -- mit Befehl/Check, nicht Bauchgefuehl]

## Artefakt-Spur
- Erstellt: <volle Pfade>
- Geaendert: <Pfad>: <was genau, inkl. Funktions-/Variablennamen>
- Gelesen (unveraendert): <Pfad>
- IDs verbatim: Fehlercodes, Commit-SHAs, Service-Namen, Ports

## Entscheidungen
[Was warum entschieden -- damit es nicht neu hergeleitet wird]

## Naechster Schritt
1. ...
```

Identifier (Pfade, Fehlercodes, Commit-SHAs, Ports) verbatim in eigenen Abschnitten halten, nicht in Prosa einbetten -- die "Artefakt-Spur" ist die schwaechste Dimension jeder Zusammenfassung.

5. Was NIE komprimiert/maskiert wird. System-Prompt, Tool-Definitionen/Schemas und aktive Fehlermeldungen (waehrend laufendem Debugging, Fehler in den letzten 3 Turns) bleiben unangetastet. Wer ein Tool-Schema wegfasst, zerstoert die Tool-Faehigkeit des Agenten; wer Fehlertexte maskiert, bricht die Debug-Schleife.

6. Cache-freundlicher Prompt-Aufbau. Stabiles zuerst, Dynamisches zuletzt: System-Prompt -> Tool-Defs -> Templates -> History -> aktuelle Anfrage. Keine Zeitstempel/Session-IDs/Zaehler im stabilen Prefix -- schon ein Whitespace-Unterschied invalidiert den ganzen KV-Cache dahinter. Stabiler Prefix = Prompt-Caching greift = bis zu ~50% guenstigere Input-Token bei Wiederholung.

7. Billiges Modell als Default, starkes nur fuer harte Brocken. Routine (SSH, Datei-Ops, Installs) braucht kein Flaggschiff. Default = guenstiges Modell, Eskalation auf das starke nur bei echtem Reasoning-Bedarf.

8. Memory: flachste Schicht, die reicht -- just-in-time laden. Working (Scratchpad) -> Short-term (Datei) -> Long-term (mem0/Qdrant), nur eskalieren wenn die flachere Schicht die Abruf-Qualitaet nicht mehr liefert. Memories just-in-time mit Relevanzfilter abrufen, nicht en bloc. Stale Memories verfallen lassen/entwerten (Zeitvaliditaet), sonst vergiften sie den Kontext. (Deckt sich mit vm-112-Tagebuch + mem0 + Memory-Markdown.)

### Harte Schicht: LiteLLM-Gateway vm-110

Bindet alle Agenten ohne deren Mitwirkung. Pro virtuellem Key einzustellen (separater Live-Schritt, erst nach Klaus' GO -- Doku vor Live): Per-Key-Budget mit Reset-Fenster (max_budget + budget_duration), Rate-Limits (rpm_limit/tpm_limit), Response-Caching (z.B. Redis), Prompt-/Prefix-Caching durchreichen, Fallback-Routing bei 429/Limit (mehrere Deployments, automatisch am Gateway), Spend-Tracking. Messen vor Optimieren: erst Spend-Tracking aktivieren und sehen wer die Token verbrennt, dann gezielt Budgets/Caching setzen.

Lizenz: Regeln destilliert aus muratcankoylan/Agent-Skills-for-Context-Engineering (MIT). Stand: 2026-06-04.

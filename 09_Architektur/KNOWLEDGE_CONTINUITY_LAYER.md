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

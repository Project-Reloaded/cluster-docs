# AGENT_SYSTEM — Master-Doktrin fuer Agenten-Infrastruktur

**Geltungsbereich:** Alle 7 Project-Reloaded-Fabriken (RefactorCo, Trading, Social-Media, Marketing, Ebook, Cluster-Control, Project-Reloaded).

**Quelle der Wahrheit:** Diese Datei beschreibt die fabrik-invarianten Pattern. Fabrik-spezifische Abweichungen stehen in `<repo>/_ai/AGENT_SPECIALIZATION.md` jeder Fabrik. RefactorCo behaelt zusaetzlich `docs/agents/REFACTORCO_AGENT_SYSTEM.md` als Pilot-Referenz.

## Kern-Invarianten

### 1. Session-Persistence
- Pfad: `_ai/session-ledger/`
- Pflicht: `CURRENT_STATE.md`, `LAST_SESSION_DATE.md`
- Pattern: vor Session-Ende `CURRENT_STATE.md` fortschreiben

### 2. Resume-/Handoff-Struktur
- Pfad: `_ai/handoffs/`
- Pflicht: bei Session-Start lesen, bei Session-Ende schreiben

### 3. BOOTSTRAP-Lesereihenfolge
- Datei: `_ai/openclaw/BOOTSTRAP.md`
- Definiert: in welcher Reihenfolge ein neuer Agent die Doku konsumiert

### 4. Operator-Start/Close-Commands
- Pfad: `docs/operators/UNIVERSAL_START_COMMAND.md`, `docs/operators/SESSION_CLOSE_COMMAND.md`

### 5. Repo-first / Truth-Hierarchie
- Repo > Memory > Conversation. Memory ist Cache, Repo ist Wahrheit.

### 6. OpenClaw-Nutzung-Norm
- OpenClaw als GitHub-Proxy + SSH-Bruecke fuer Cluster-Operationen
- Sessions persistieren in `/root/.openclaw/sessions/` auf vm-100

## Review-Triggers (Pflicht-Cross-Check)

Diese Datei MUSS geprueft und ggf. ergaenzt werden wenn:

1. Eine Fabrik fuehrt einen neuen invarianten Agent-Pattern ein
2. Zwei oder mehr Fabriken entwickeln unabhaengig dasselbe Pattern -> nicht mehr fabrikspezifisch, hochziehen
3. Major-Milestone einer Fabrik (Phase-Uebergang, Go-Live, Architektur-Schwenk)
4. Mindestens jaehrlich oder vor jeder groesseren Wave-Inkrement-Planung

**Verfahren bei Trigger:** Specialization-Files querlesen -> invariante Patterns identifizieren -> `AGENT_SYSTEM.md` ergaenzen -> Revision History aktualisieren -> in den Specialization-Files den nun-invarianten Eintrag entfernen.

## Revision History

| Datum | Anlass | Was geaendert | Wer |
|---|---|---|---|
| 2026-05-13 | Initial-Rollout | Erstanlage, alle 6 Invarianten kanonisiert, 7 Specializations verlinkt | OpenClaw + Claude (Klaus' GO) |

## Specializations-Index

- [RefactorCo (Pilot, voll)](https://github.com/Project-Reloaded/RefactorCo-Fabrik-v5/blob/main/docs/agents/REFACTORCO_AGENT_SYSTEM.md)
- [Trading](https://github.com/Project-Reloaded/Trading-Fabrik-v5/blob/main/_ai/AGENT_SPECIALIZATION.md)
- [Social-Media](https://github.com/Project-Reloaded/Social-Media-Fabrik-v5/blob/main/_ai/AGENT_SPECIALIZATION.md)
- [Marketing](https://github.com/Project-Reloaded/Marketing-Fabrik-v5/blob/main/_ai/AGENT_SPECIALIZATION.md)
- [Ebook](https://github.com/Project-Reloaded/Ebook-Fabrik-v5/blob/main/_ai/AGENT_SPECIALIZATION.md)
- [Cluster-Control](https://github.com/Project-Reloaded/Cluster-Control-v5/blob/main/_ai/AGENT_SPECIALIZATION.md)
- [Project-Reloaded-Cluster](https://github.com/Project-Reloaded/project-reloaded-cluster-v5/blob/main/_ai/AGENT_SPECIALIZATION.md)

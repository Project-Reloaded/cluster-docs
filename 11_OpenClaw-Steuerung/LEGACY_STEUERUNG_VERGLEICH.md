# LEGACY_STEUERUNG_VERGLEICH – Alt vs. v5 Steuerungsmuster

**Analyse:** 4 Legacy-Repos verglichen mit 7 v5-Repos 
**Erstellt:** 2026-04-16 
**Ziel:** Was war gut, was ist besser, was fehlt noch, was muss transferiert werden.

---

## 1. Analysierte Repos

### Legacy-Repos (Vorgänger)
| Repo | Hauptzweck | Reifegrad | Besonderheit |
|------|-----------|-----------|-------------|
| `trading-lab` | Trading Research + Replay | ★★★★★ Sehr reif | Vollständigste Steuerungsschicht |
| `Social-Media-Fabrik` | Content-Erstellung + Scheduling | ★★★★☆ Reif | K-R Bundle-System, Block-Derivation |
| `RefactorCo-lab` | Code-Refactoring Analyse | ★★★☆☆ Mittel | Multi-Case-System A–G |
| `project-reloaded-cluster-archive` | VPS-Audit + Cluster-Archiv | ★★★☆☆ Mittel | Automatisierte Tages-Audits |

### v5-Repos (aktuell)
project-reloaded-cluster-v5, Cluster-Control-v5, Marketing-Fabrik-v5,
Social-Media-Fabrik-v5, Ebook-Fabrik-v5, Trading-Fabrik-v5, RefactorCo-Fabrik-v5

---

## 2. Steuerungs-Muster im Vergleich

### 2.1 Session-Start / Bootstrap

**Legacy (trading-lab) — SEHR GUT ✅**
```
_ai/openclaw/BOOTSTRAP.md
```
- Explizite, geordnete Leseliste (Schritt 1 bis N)
- Datei zeigt genau in welcher Reihenfolge OpenClaw einlesen soll
- Trennung: was immer gelesen wird vs. was kontextabhängig ist
- Endergebnis: OpenClaw startet in einem definierten Zustand

**v5 (aktuell) — TEILWEISE ✅/⚠️**
```
docs/operators/OPENCLAW_START_COMMAND.md (nur RefactorCo hat das)
README.md → Abschnitt "Nächster Start"
```
- README hat "Nächster Start"-Sektion mit Startbefehl → gut für Menschen
- Kein maschinenlesbares BOOTSTRAP.md in den meisten Repos
- Kein dedizierter `_ai/openclaw/`-Ordner

**Was fehlt:** BOOTSTRAP.md im `_ai/openclaw/`-Pattern auf alle 7 Repos ausrollen.

---

### 2.2 OpenClaw Identität / Rolle

**Legacy (trading-lab) — EXZELLENT ✅✅**
```
_ai/openclaw/IDENTITY.md → Wer bin ich in diesem Repo?
_ai/openclaw/SOUL.md → Welche Werte leiten mich?
_ai/openclaw/AGENTS.md → Abgrenzung zu anderen Agenten
```
- OpenClaw weiß in jedem Repo genau: Darf ich X tun? Was ist mein Scope?
- IDENTITY.md unterscheidet explizit: "Meine Rolle hier ist Audit/GitOps, NICHT Bootstrap-Operator"
- SOUL.md codiert Verhaltensregeln die session-übergreifend gelten
- Verhindert Role-Drift zwischen Sessions

**v5 (aktuell) — GRUNDSTRUKTUR VORHANDEN ✅**
```
docs/architecture/OPENCLAW_ROLLENMODELL.md (alle Repos)
```
- Rollenmodell ist da, aber nicht als dedizierte `_ai/`-Schicht
- Kein SOUL.md / kein IDENTITY.md
- OpenClaw muss sich die Rolle aus docs/ zusammensuchen statt direkt zu haben

**Was fehlt:** IDENTITY.md + SOUL.md in `_ai/openclaw/` pro Repo hinzufügen (Phase 5+).

---

### 2.3 Wahrheitshierarchie

**Legacy (trading-lab) — GUT ✅**
```
03_truth_model.md (Root-Datei)
```
- Wahrheitsquellen klar definiert
- Aber: nur repo-spezifisch, kein cluster-weites Modell

**v5 (aktuell) — BESSER ✅✅**
```
docs/governance/WAHRHEITS_HIERARCHIE.md (alle 7 Repos)
```
- In ALLEN 7 Repos konsistent vorhanden
- Cluster-weite Gøltigkeit explizit
- Klarer als legacy: "GitHub-Repo > ZIP > Evidence > Legacy > Chat"
- **Eindeutig verbessert gegenüber Legacy**

---

### 2.4 Session-Handoffs und Kontinuität

**Legacy (trading-lab) — SEHR GUT ✅✅**
```
_ai/openclaw/sessions/[DATUM]-[THEMA].md
```
- Jede Session endet mit einem Handoff-Dokument
- Nächster Schritt, offene Gates, aktueller Stand
- OpenClaw liest die letzten 3 Session-Dateien beim Start
- Ermöglicht echte Kontinuität über Wochen

**v5 (aktuell) — FEHLT ❌**
```
Kein sessions/-Verzeichnis in keinem der 7 Repos
```
- Session-Kontinuität nur über README "Nächster Start"
- README wird schnell veraltet wenn viele Schritte gemacht werden
- Kein Audit-Trail der Session-Geschichte

**Was fehlt:** `_ai/openclaw/sessions/`-Ordner + Handoff-Convention einführen.

---

### 2.5 Globale Kommandos

**Legacy (trading-lab) — GUT ✅**
```
02_global_commands.md (Root-Datei)
```
- Klare Verhaltensregeln: repo-first, Schreibregeln, Konflikt-Protokoll
- Alle Agenten (ChatGPT, Codex, OpenClaw, Paperclip...) kennen diese Regeln
- Root-Level = erste Datei die jeder liest

**v5 (aktuell) — VERTEILT ⚠️**
```
docs/governance/WAHRHEITS_HIERARCHIE.md (Teilmenge der globalen Kommandos)
README.md (informell)
```
- Kein dediziertes `global_commands.md` auf Root-Level
- Regeln sind auf mehrere Dateien verteilt
- Neu eingestiegene Agenten møssen mehr suchen

**Was fehlt:** Eine zentrale `GLOBAL_COMMANDS.md` oder `AGENTS.md` auf Root-Level.

---

### 2.6 VM-Rollen-Dokumentation

**Legacy (trading-lab) — SEHR GUT ✅✅**
```
04_roles_and_agents.md → allgemein
08_agent_and_ops_model.md → Betrieb
_ai/openclaw/VM_AGENT_MAP.md → OpenClaw-spezifische VM-Zuweisung
vms/vm-10x/SOUL.md → Pro VM: Verhaltenscodex
vms/vm-10x/ROLES.md → Pro VM: Rollendetail
vms/vm-10x/AGENTS.md → Pro VM: Agenten-Definition
```
- Jede VM hat eigene SOUL.md / ROLES.md / AGENTS.md
- OpenClaw kennt seine Zuständigkeit pro VM exakt
- Sehr granular und vollständig

**v5 (aktuell) — BASISSCHICHT VORHANDEN ✅**
```
docs/vms/VM_ROLLEN.md (Tabelle in einer Datei)
```
- Alle VMs in einer Tabelle — einfacher zu pflegen
- Weniger granular als Legacy (kein pro-VM SOUL.md)
- Besser für den aktuellen Phase (Bootstrap) geeignet
- Für Betrieb später pro-VM-Schicht nachziehen

**Bewertung:** Für aktuellen Wave-Stand (2-3.x) ausreichend. Für Wave 5+ pro-VM-Schicht nachziehen.

---

### 2.7 Governance und Guardrails

**Legacy (trading-lab) — GUT ✅**
```
docs/governance/LIVE_PATH_GUARDRAILS.md
docs/governance/LIVE_SWITCH_AND_SIM_STATE.md
docs/governance/PHASED_ACTIVATION.md
```
- Sehr detaillierte Trading-Guardrails
- Phased Activation dokumentiert (was wann scharf geschalten werden darf)
- Aber: Scope nur Trading

**v5 (aktuell) — BESSER STRUKTURIERT ✅✅**
```
docs/governance/LIVE_KEY_GUARDRAIL.md (Trading-Fabrik-v5)
docs/governance/CONTENT_RELEASE_GUARDRAILS.md (Social-Media-Fabrik-v5)
docs/governance/WAHRHEITS_HIERARCHIE.md (alle 7 Repos)
```
- Fabrik-spezifische Guardrails → richtiger als ein generischer
- Cluster-weite Wahrheitshierarchie → besser als Legacy
- **Eindeutig verbessert**

---

### 2.8 Session-Prompts / Prompt-Bibliothek

**Legacy (trading-lab) — EINMALIG ✅✅**
```
_ai/openclaw/prompts/
```
- Wiederverwendbare Prompt-Vorlagen før OpenClaw
- Verhindert, dass jedes Mal der gleiche Prompt neu formuliert werden muss
- Konsistentes Verhalten über Sessions hinweg

**v5 (aktuell) — FEHLT KOMPLETT ❌**
```
Kein prompts/-Verzeichnis in keinem der 7 Repos
```
- Dieses Kapitel (`11_OpenClaw-Steuerung/OPENCLAW_KOMMANDOS.md`) ist der erste Schritt
- In v5-Repos fehlt eine lokale Prompt-Bibliothek noch

**Was fehlt:** `_ai/openclaw/prompts/`-Ordner mit Standard-Prompts einführen.

---

### 2.9 Cross-Repo-Koordination

**Legacy — FEHLT ❌**
- Legacy-Repos waren einzeln, kein formales Cluster-Mapping
- Kein offizielles Dokument welches Repo zu welchem Node gehört
- Jedes Repo "wusste" von sich selbst, nicht vom Cluster

**v5 (aktuell) — EXZELLENT NEU ✅✅✅**
```
docs/nodes/NODE_FABRIK_ZUORDNUNG.md (cluster-v5 + Cluster-Control-v5)
cluster-docs/10_Legacy-Delta/LEGACY_DELTA_ANALYSE.md
```
- Explizites Node-zu-Fabrik-Mapping (Node-1 = Infrastruktur, etc.)
- LEGACY_DELTA_ANALYSE als cluster-weiter Überblick
- **Massiv verbessert gegenøber Legacy — hier ist v5 wirklich besser**

---

## 3. Gesamtbewertung

| Muster | Legacy | v5 | Tendenz | Priorität |
|--------|--------|-----|---------|-----------|
| Session Bootstrap | ✅✅ BOOTSTRAP.md | ✅ README | Legacy besser | P2 nachrüsten |
| OpenClaw Identität | ✅✅ IDENTITY+SOUL | ✅ ROLLENMODELL | Legacy besser | P2 nachrüsten |
| Wahrheitshierarchie | ✅ repo-spezifisch | ✅✅ cluster-weit | **v5 besser** | — |
| Session-Handoffs | ✅✅ sessions/ | ❌ fehlt | Legacy besser | P1 nachrüsten |
| Globale Kommandos | ✅ global_commands | ⚠️ verteilt | Legacy besser | P2 nachrüsten |
| VM-Dokumentation | ✅✅ pro-VM | ✅ Tabelle | Legacy granularer | P3 (Wave 5+) |
| Governance/Guardrails | ✅ Trading-spezifisch | ✅✅ fabrik-spezifisch | **v5 besser** | — |
| Prompt-Bibliothek | ✅✅ prompts/ | ❌ fehlt | Legacy besser | P2 nachrüsten |
| Cross-Repo-Koordination | ❌ fehlt | ✅✅✅ NODE_ZUORDNUNG | **v5 massiv besser** | — |
| Commit-Disziplin | ✅ 1:1 regel | ✅ wave-basiert | Gleichwertig | — |

---

## 4. Was wurde aus Legacy in v5 übernommen

Bereits transferiert (Stand 2026-04-16):

- ✅ Wahrheitshierarchie (aus trading-lab `03_truth_model.md`) → `docs/governance/WAHRHEITS_HIERARCHIE.md` in alle 7 Repos
- ✅ VM-Rollen-Dokumentation (aus trading-lab `04_roles_and_agents.md`) → `docs/vms/VM_ROLLEN.md`
- ✅ Live-Key-Guardrail (aus trading-lab `LIVE_PATH_GUARDRAILS.md`) → `docs/governance/LIVE_KEY_GUARDRAIL.md`
- ✅ Trading-Progression (aus trading-lab Scope) → `docs/trading/TRADING_PROGRESSION.md`
- ✅ Content-Guardrails (aus Social-Media-Fabrik) → `docs/governance/CONTENT_RELEASE_GUARDRAILS.md`
- ✅ OpenClaw Rollenmodell (aus cluster-archive) → `docs/architecture/OPENCLAW_ROLLENMODELL.md`
- ✅ Node-Fabrik-Zuordnung (neu, kein Legacy-Vorbild) → `docs/nodes/NODE_FABRIK_ZUORDNUNG.md`
- ✅ Fehlende VMs Node-1 → `docs/vms/FEHLENDE_VMS_NODE1.md`

---

## 5. Offene Løcken — Noch zu transferieren

### P1 — Sollte bald in v5 kommen

**Session-Handoffs:**
```
Jedes v5-Repo braucht: _ai/openclaw/sessions/
Convention: [DATUM]-[THEMA].md
Inhalt: Was wurde gemacht | Nächster Schritt | offene Gates
```

**AGENTS.md auf Root-Level:**
```
Jedes v5-Repo braucht: AGENTS.md im Root
Inhalt: Wer darf dieses Repo nutzen, was sind die harten Regeln. Lesefolge
Vorlage: trading-lab/AGENTS.md
```

### P2 — Wichtig aber nicht sofort nötig

**Prompt-Bibliothek:**
```
_ai/openclaw/prompts/ mit Standard-Prompts für die wichtigsten Szenarien
```

**BOOTSTRAP.md:**
```
_ai/openclaw/BOOTSTRAP.md mit expliziter Schritt-für-Schritt Lesefolge
```

**IDENTITY.md + SOUL.md:**
```
Ab Wave 5 (Betrieb aktiv) pro Repo hinzufügen
```

### P3 — Langfristig (Wave 5+)

**Pro-VM-Dokumentation:**
```
vms/vm-10x/SOUL.md, ROLES.md, AGENTS.md
(nach Vorbild trading-lab, wenn VMs tatsächlich installiert)
```

---

## 6. Harte Wahrheiten über Legacy

Nicht alles im Legacy war gut:

| Was war schlecht im Legacy | Warum | Was v5 besser macht |
|---------------------------|-------|-------------------|
| Kein cluster-weites Mapping | Jedes Repo war eine Insel | NODE_FABRIK_ZUORDNUNG löst das |
| Kein formales Wave-Modell | Fortschritt war unklar messbar | 0.x–7.x Wave-Modell in v5 |
| Zu viele Root-Dateien (00–11) | Unübersichtlich für neue Agenten | v5 bündelt in docs/ |
| Session-Docs wuchsen unkontrolliert | Social-Media-Fabrik hatte 22 PR-Sessions | v5 braucht Aufräum-Convention |
| Legacy-Repos wurden nicht formal depreciert | Unklar was gilt | cluster-docs/10_Legacy-Delta dokumentiert das |
| Scope-Drift in Chat | Chat-Aussagen wurden manchmal wie Wahrheit behandelt | WAHRHEITS_HIERARCHIE löst das |

---

*Stand: 2026-04-16 | Analyse-Basis: trading-lab, Social-Media-Fabrik, RefactorCo-lab, project-reloaded-cluster-archive*

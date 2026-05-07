# CLUSTER_BOOTSTRAP

## A) Zweck
Diese Datei beschreibt die **cluster-weite Bootstrap-Doktrin** fuer jede neue Cowork-Session bzw. OpenClaw-Session.

Ziel ist, dass der Operator — **Klaus oder ein Agent** — sofort den richtigen Arbeitsstand hat, **ohne** sich auf Chat-Gedaechtnis oder implizite Vorgaenger-Kontexte verlassen zu muessen.

Diese Datei ist eine abgeleitete Arbeitsdoktrin unterhalb von:
- `09_Architektur/KNOWLEDGE_CONTINUITY_LAYER.md`

## B) Lesereihenfolge auf Cluster-Ebene (nur `cluster-docs`)
Die cluster-weite Bootstrap-Lesereihenfolge ist:

1. `cluster-docs/README.md`
2. `cluster-docs/CURRENT_STATE.md`
3. `cluster-docs/08_Betrieb/CROSS_REPO_STATUS.md`
4. `cluster-docs/11_OpenClaw-Steuerung/01_BEFEHLSLISTE-CLUSTER-ABSCHLUSS.md`
5. `cluster-docs/09_Architektur/MODEL_ACCESS_ARCHITECTURE.md`
6. `cluster-docs/09_Architektur/KNOWLEDGE_CONTINUITY_LAYER.md`
7. `cluster-docs/08_Betrieb/02_OpenClaw-Betriebshandbuch.md`

Zweck dieser Reihenfolge:
- zuerst Gesamtlage,
- dann Cross-Repo-Status,
- dann operatorische Abschluss-/Steuerlogik,
- dann Architektur-Doktrin fuer Modellzugriff und Wissenskontinuitaet,
- und zuletzt Betriebs-/Monitoring-/Wartungskontext.

## C) Lesereihenfolge pro Fabrik-Repo
Innerhalb eines einzelnen Fabrik-Repos ist die Bootstrap-Lesereihenfolge:

1. `README.md`
2. `_ai/openclaw/BOOTSTRAP.md` *(falls vorhanden)*
3. `_ai/session-ledger/CURRENT_STATE.md`
4. `_ai/session-ledger/NEXT_10.md`
5. `docs/agents/REFACTORCO_AGENT_SYSTEM.md` *(oder das jeweilige Pendant der Fabrik)*
6. `inventory/READINESS_SCORECARD.yaml`

Zweck dieser Reihenfolge:
- zuerst Repo-Scope und Grundkontext,
- dann sessionspezifische Startanweisung,
- dann Ist-Stand,
- dann naechste konkrete Arbeitspakete,
- dann Rollen-/Agentenrahmen,
- dann Readiness-/Gate-Lage.

## D) Pro-Fabrik-BOOTSTRAP.md als TODO
Naechster Ausbaupunkt ist eine **eigene `_ai/openclaw/BOOTSTRAP.md` in jedem der 7 v5-Repos**.

Diese Dateien sollen basieren auf:
- `RefactorCo-lab/_ai/openclaw/BOOTSTRAP.md`

Diese Rollout-Welle ist **Job 8 / Continuity-Phase-A**.

Ziel:
- jede Fabrik bekommt einen eigenen kanonischen Session-Einstieg,
- aber alle folgen derselben cluster-weiten Bootstrap-Doktrin.

## E) Status
- **Status:** PLANUNG
- **Stand:** 2026-05-07

Wichtig:
Dieses Dokument ist **sofort gueltig als Doktrin**, auch wenn die Pro-Fabrik-`BOOTSTRAP.md`-Dateien noch nicht in allen Repos ausgerollt sind.

## Verweisrahmen
- `09_Architektur/KNOWLEDGE_CONTINUITY_LAYER.md`
- `09_Architektur/MODEL_ACCESS_ARCHITECTURE.md`
- `08_Betrieb/02_OpenClaw-Betriebshandbuch.md`
- `11_OpenClaw-Steuerung/01_BEFEHLSLISTE-CLUSTER-ABSCHLUSS.md`
- `08_Betrieb/CROSS_REPO_STATUS.md`

# CROSS_REPO_STATUS — Querschnitts-Tabelle aller v5-Repos

> **Stand: 2026-04-25 (nach Block A für RefactorCo)** | Pfad: `cluster-docs/08_Betrieb/CROSS_REPO_STATUS.md`
> Wird referenziert in `OPENCLAW_BEFEHLSKATALOG.md` Abschnitt "CW1 — Cross-Repo-Status aktualisieren".
> Quelle: README.md + AGENTS.md jedes Repos auf `main`.

## Bootstrap-Diagnose

| Repo | AGENTS.md (Root) | _ai/openclaw/sessions/ | BOOTSTRAP.md | OPENCLAW_START_COMMAND.md | INSTALL_SEQUENCE.md | VM_SPEC.md | CLUSTER_DEPS.md |
|------|:----------------:|:----------------------:|:------------:|:-------------------------:|:-------------------:|:----------:|:---------------:|
| project-reloaded-cluster-v5 | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| Cluster-Control-v5          | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| Trading-Fabrik-v5           | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| Social-Media-Fabrik-v5      | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| Marketing-Fabrik-v5         | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| Ebook-Fabrik-v5             | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| **RefactorCo-Fabrik-v5**    | ✓ | ✗ | ✗ | **✓** | ✗ | ✗ | ✗ |

> Hinweis zu AGENTS.md: alle Repos haben sie auf Root-Level — auch wenn der Inhalt teilweise nur ein Stub-Header ist.
> RefactorCo ist das einzige Repo mit `OPENCLAW_START_COMMAND.md` → laut **CW2** auf alle anderen 6 Repos ausrollen.

## Wave-Stand pro Repo

| Repo | aktive Welle | Reifegrad | Statusfarbe | Nächste Welle blockt durch |
|------|:------------:|----------:|:-----------:|----------------------------|
| project-reloaded-cluster-v5 | 1 (Bootstrap) | n/a | gray | `cluster_integration_ready: FAIL` |
| Cluster-Control-v5          | 0.5 / 1 | n/a | gray | `control_shared_ready: FAIL` |
| Trading-Fabrik-v5           | 3.2 | 82 % | yellow | Welle-3 Legacy-Block schließen |
| Social-Media-Fabrik-v5      | 3.1 | 93 % | yellow | Legacy-Vergleichs-Gap-Matrix |
| Marketing-Fabrik-v5         | 3.1 | n/a | yellow | Legacy-Vergleichs-Gap-Matrix |
| Ebook-Fabrik-v5             | 3.x | 87 % | green | Welle-3.1 Pflicht-Dateien (4 Stück) |
| **RefactorCo-Fabrik-v5**    | **1-2 + Block B/C** | **52 %** | **yellow** | Block B (Welle 6 vorziehen), dann Block C (auf 80 %/grün) |

## Gates pro Repo (alle drei P1-Gates)

| Repo | legacy_compare_ready | delta_wave_ready | cross_repo_ready |
|------|:--------------------:|:----------------:|:----------------:|
| project-reloaded-cluster-v5 | n/a | (BLOCKED) | (BLOCKED) |
| Cluster-Control-v5          | n/a | (BLOCKED) | (BLOCKED) |
| Trading-Fabrik-v5           | **PASS** | FAIL | FAIL |
| Social-Media-Fabrik-v5      | **PASS** | FAIL | FAIL |
| Marketing-Fabrik-v5         | **PASS** | FAIL | FAIL |
| Ebook-Fabrik-v5             | **PASS** | FAIL | FAIL |
| RefactorCo-Fabrik-v5        | FAIL | FAIL | FAIL |

> Hinweis RefactorCo: Gates bleiben FAIL bis `main` ≥ 80 / grün (laut Roadmap-Leitplanke). Der Sprung auf 52 % gelb ist kein Gate-Pass, nur die Sichtbarmachung des realen Stands.

## Letzter Push pro Repo (laut GitHub API, 2026-04-25)

| Repo | letzter Commit auf `main` | Branches sonst |
|------|---------------------------|----------------|
| cluster-docs                | 2026-04-25 (laufende Aktualisierung) | + `Project-Reloaded-patch-1` |
| **RefactorCo-Fabrik-v5**    | **2026-04-25** (Block A: `f21ecf3`) | + 3 chatgpt/Project-Reloaded-patch Branches |
| project-reloaded-cluster-v5 | 2026-04-16 | + `bootstrap-test`, `chatgpt-test-tree` |
| Cluster-Control-v5          | 2026-04-16 | + `chatgpt/cluster-control-readme-naechster-start-fix` |
| Ebook-Fabrik-v5             | 2026-04-16 | + `chatgpt/ebook-readme-naechster-start-fix` |
| Marketing-Fabrik-v5         | 2026-04-16 | (nur main) |
| Social-Media-Fabrik-v5      | 2026-04-16 | + 2 chatgpt + 1 wave1-Branch |
| Trading-Fabrik-v5           | 2026-04-16 | + 4 chatgpt/wave/tree-test Branches |

> **Sauberkeits-Hinweis:** Mehrere Repos haben offene `chatgpt/...` Branches aus früheren Patches.
> Empfehlung: nach nächstem Welle-3-Push diese Branches durchgehen und mergen oder löschen.

## OpenClaw-Befehl zum Refresh dieser Datei

```
@OpenClaw: Aktualisiere cluster-docs/08_Betrieb/CROSS_REPO_STATUS.md.
Klone alle 7 v5-Repos nach /tmp/. Lies pro Repo: README.md, AGENTS.md, listing von _ai/openclaw/.
Fülle alle 4 Tabellen aus aktuellen Daten:
 1. Bootstrap-Diagnose (7 Spalten Datei-Vorhanden/Fehlt)
 2. Wave-Stand pro Repo
 3. Gates pro Repo (3 P1-Gates)
 4. Letzter Push pro Repo (git log -1 + git branch -r)
Committe mit: "docs(cross-repo): Status [DATUM] aktualisiert"
```

---

*Stand: 2026-04-25 (Block A für RefactorCo durchgezogen) | Aktualisierung: nach jedem cluster-weiten Sprung in einer Welle.*

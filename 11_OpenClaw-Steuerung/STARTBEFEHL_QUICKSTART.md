# STARTBEFEHL_QUICKSTART — Eine Zeile pro Szenario

> **Pfad:** `cluster-docs/11_OpenClaw-Steuerung/STARTBEFEHL_QUICKSTART.md`
> **Zweck:** Cheat-Sheet. Wenn du nur eine einzige Sache an OpenClaw schicken willst — die hier.
> Vollständige Befehle stehen in `OPENCLAW_BEFEHLSKATALOG.md`.

## C0 — Cluster-Statusbericht (Tag fängt an)

Sende an OpenClaw (WhatsApp / Telegram / WebSocket auf 192.168.1.20:18789):

```
Lies cluster-docs/CURRENT_STATE.md.
Lies dann das README.md jedes der 7 v5-Repos.
Aktualisiere cluster-docs/08_Betrieb/CROSS_REPO_STATUS.md mit dem aktuellen Stand.
Berichte mir in 8 Zeilen: pro Repo eine Zeile (Wave + nächster Schritt).
Committe mit: "docs(cross-repo): Status [HEUTE] aktualisiert"
```

## C1 — Tagesziel anstoßen (eine Fabrik)

```
Du arbeitest jetzt in [REPO-NAME]. Folge B0-Session-Start aus README.md.
Berichte: (1) Wave-Stand (2) letzte Session (3) nächste 4-5 Schritte aus Handoff.
Arbeite den nächsten Schritt ab. Speichere Handoff. Committe.
```

→ Ersetze `[REPO-NAME]` durch eines von: `project-reloaded-cluster-v5`, `Cluster-Control-v5`, `Trading-Fabrik-v5`, `Social-Media-Fabrik-v5`, `Marketing-Fabrik-v5`, `Ebook-Fabrik-v5`, `RefactorCo-Fabrik-v5`.

## C2 — System-Health prüfen (vor jedem Eingriff)

```
Führe AUDIT1 aus cluster-docs/11_OpenClaw-Steuerung/OPENCLAW_BEFEHLSKATALOG.md aus.
Speichere Report unter cluster-docs/_ai/openclaw/sessions/[HEUTE]-AUDIT1-cluster.md.
```

## C3 — Schnellcheck einer einzelnen Datei

```
Lies [PFAD] in [REPO-NAME]. Sage mir in 3 Zeilen was drin steht und was fehlt.
Keine Aktion, kein Commit.
```

## C4 — Schwächstes Glied weiterbringen

Aktuell (Stand 2026-04-25): **RefactorCo-Fabrik-v5** ist das schwächste Glied.

```
Du arbeitest jetzt in RefactorCo-Fabrik-v5.
Folge dem Startbefehl aus README.md (41-Punkte-Lesefolge).
Ziel: main auf 80 % grün bringen, BEVOR du in Welle 3 weiterarbeitest.
Berichte zuerst Wave-Stand + Cases A-G + offene Gates. Dann arbeite den nächsten konkreten Schritt ab.
Speichere Handoff. Committe.
```

## C5 — Cluster-weite Verbreitung (CW2 — START_COMMAND ausrollen)

```
Lies docs/operators/OPENCLAW_START_COMMAND.md aus RefactorCo-Fabrik-v5.
Erstelle eine angepasste Kopie in jedem dieser 6 Repos:
project-reloaded-cluster-v5, Cluster-Control-v5, Trading-Fabrik-v5,
Social-Media-Fabrik-v5, Marketing-Fabrik-v5, Ebook-Fabrik-v5
Pfad pro Repo: docs/operators/OPENCLAW_START_COMMAND.md
Pro Repo Scope/VM-Rollen anpassen. Patche README.md.
Pro Repo committen mit: "feat(wave3): OPENCLAW_START_COMMAND.md ausgerollt"
```

## C6 — Wave-4-Readiness prüfen (vor Installations-Start)

```
Lies alle 7 README.md aus den v5-Repos.
Prüfe für jedes Repo:
  - WAHRHEITS_HIERARCHIE.md vorhanden ✓/✗
  - VM_ROLLEN.md vorhanden ✓/✗
  - Legacy-P1-Transfer abgeschlossen ✓/✗
  - AGENTS.md vorhanden ✓/✗
  - _ai/openclaw/sessions/ vorhanden ✓/✗
  - BOOTSTRAP.md vorhanden ✓/✗
  - INSTALL_SEQUENCE.md vorhanden ✓/✗
  - VM_SPEC.md vorhanden ✓/✗
  - CLUSTER_DEPS.md vorhanden ✓/✗
Schreibe Ergebnis-Tabelle in cluster-docs/08_Betrieb/WAVE4_READINESS.md.
Committe mit: "docs(wave4): Readiness-Check [HEUTE]"
```

## C7 — Session sauber abschließen (jeden Tag, jede Session)

```
Erstelle _ai/openclaw/sessions/[HEUTE]-[REPO]-[THEMA].md im aktuellen Repo.
Inhalt:
  ## Was wurde heute gemacht — [Liste der Commits]
  ## Aktueller Wave-Stand — [X.x]
  ## Offene Gates — [Liste]
  ## Nächste 10 Schritte — [nummeriert, ausführbar]
  ## Wichtige Entscheidungen heute — [Was nicht zurückgenommen werden darf]
  ## Warnungen für nächste Session — [Was heikel ist]
Committe mit: "docs(session): Handoff [HEUTE] [REPO] gespeichert"
Aktualisiere danach cluster-docs/CURRENT_STATE.md (Reifegrad-Tabelle + nächste Schritte).
```

## C8 — Notfall: OpenClaw versteht den Stand nicht mehr

```
STOP. Lies in dieser Reihenfolge neu:
  1. cluster-docs/CURRENT_STATE.md
  2. cluster-docs/11_OpenClaw-Steuerung/00_GEBRAUCHSANWEISUNG.md
  3. README.md des aktuellen Repos
  4. _ai/openclaw/sessions/ — die letzten 3 Dateien nach Datum
Berichte was du jetzt für die Wahrheit hältst. KEINE Aktion bis ich bestätigt habe.
```

---

## Quick-Reference: Welche Datei für welche Frage?

| Frage | Datei in cluster-docs |
|-------|----------------------|
| "Wo stehen wir?" | `CURRENT_STATE.md` |
| "Welcher Repo hat welchen Status?" | `08_Betrieb/CROSS_REPO_STATUS.md` |
| "Welche Befehle gibt es überhaupt?" | `11_OpenClaw-Steuerung/OPENCLAW_BEFEHLSKATALOG.md` |
| "Wie baue ich ein neues v5-Repo?" | `11_OpenClaw-Steuerung/REPO_BUILD_ANLEITUNG.md` |
| "Wie funktioniert OpenClaw?" | `11_OpenClaw-Steuerung/00_GEBRAUCHSANWEISUNG.md` |
| "Was ist der Plan für die 7 Repos?" | `11_OpenClaw-Steuerung/01_BEFEHLSLISTE-CLUSTER-ABSCHLUSS.md` |
| "Was war der Legacy-Stand und was wurde übernommen?" | `10_Legacy-Delta/LEGACY_DELTA_ANALYSE.md` + `11_OpenClaw-Steuerung/LEGACY_STEUERUNG_VERGLEICH.md` |
| "Wie ist OpenClaw selbst zu benutzen?" | `08_Betrieb/02_OpenClaw-Betriebshandbuch.md` |

---

## Goldene Regeln (gelten für alle Befehle)

1. **Repo-first** — GitHub ist die Wahrheit. Chat, ZIP, Erinnerung sind nachrangig.
2. **Vor jeder Aktion: Plan zeigen, auf OK warten.** OpenClaw ist so konfiguriert.
3. **Token niemals committen.** OpenClaw nutzt `${GITHUB_TOKEN}` aus `/root/.openclaw/credentials.env`.
4. **Live-Keys NUR auf vm-106.** Trading-Fabrik-Sicherheitspflicht.
5. **Kein Push auf main ohne Gate-Check ab Wave 4.**
6. **Spätestens alle 8 Tool-Calls: Checkpoint-Commit.**
7. **Jede Session endet mit Handoff in `_ai/openclaw/sessions/`.**

---

*Stand: 2026-04-25 | Wenn du dieses File gelesen hast, weißt du wie der Tag startet.*

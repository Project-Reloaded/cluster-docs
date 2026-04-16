# OPENCLAW_KOMMANDOS – Steuerungs-Befehlskatalog

**Repo:** cluster-docs / 11_OpenClaw-Steuerung 
**Gilt für:** OpenClaw 2026.x auf VM 100 (192.168.1.20), Port 18789 
**Ziel:** Alle Befehle, die ein Operator an OpenClaw geben kann, um Repos sauber zu bauen, zu pflegen und die Session fortzusetzen.

---

## 1. Session-Start (Bootstrap)

Jede neue Session beginnt mit diesem Befehl. OpenClaw liest damit den aktuellen Repo-Stand ein und bringt sich selbst in den richtigen Kontext.

```
Du arbeitest jetzt in [REPO-NAME].
Lies zuerst das README.md und dann alle Dateien im Verzeichnis docs/.
Fasse danach in 3 Sätzen zusammen: (1) wo wir aktuell stehen, (2) was der nächste offene Schritt ist, (3) welche Gate-Bedingungen noch fehlen.
```

**Für Cluster-weite Sessions (alle 7 Fabrik-Repos):**
```
Du arbeitest jetzt im Project-Reloaded Cluster.
Repos: project-reloaded-cluster-v5, Cluster-Control-v5, Marketing-Fabrik-v5,
 Social-Media-Fabrik-v5, Ebook-Fabrik-v5, Trading-Fabrik-v5, RefactorCo-Fabrik-v5.
Lies zuerst cluster-docs/10_Legacy-Delta/LEGACY_DELTA_ANALYSE.md.
Dann lies README.md jedes Repos, das heute relevant ist.
Wahrheitshierarchie: GitHub-Repo > ZIP > Evidence > Legacy > Chat.
```

---

## 2. Repo sauber neu bauen (neues v5-Repo)

### 2.1 Leeres Repo initialisieren
```
Erstelle folgende Grundstruktur in [REPO-NAME]:
- docs/governance/
- docs/architecture/
- docs/operators/
- docs/vms/
- docs/product/
- _ai/openclaw/sessions/
Erstelle README.md mit: Zweck, Wave-Status (0.x), VM-Rollen-Übersicht,
Nächster-Start-Sektion.
Committe mit: "init: Grundstruktur [REPO-NAME] angelegt"
```

### 2.2 Wave 1 – Truth Bootstrap
```
Erstelle in [REPO-NAME] die Wave-1-Basisdokumente:
- docs/governance/WAHRHEITS_HIERARCHIE.md
- docs/architecture/OPENCLAW_ROLLENMODELL.md 
- docs/operators/OPENCLAW_START_COMMAND.md
Nutze die Vorlage aus project-reloaded-cluster-v5.
Passe VM-Rollen und Scope auf [REPO-NAME] an.
Committe mit: "feat(wave1): Truth-Bootstrap fuer [REPO-NAME]"
```

### 2.3 Wave 2 – VM-Rollen und Governance
```
Erstelle die VM-Rollen-Dokumentation für [REPO-NAME]:
- docs/vms/VM_ROLLEN.md (vm-101 bis vm-10x mit Funktion, Status, Gate)
- docs/governance/[FACHBEREICH]_GUARDRAILS.md
Stelle sicher, dass jede VM genau eine Hauptaufgabe hat.
Committe mit: "feat(wave2): VM-Rollen + Governance-Guardrails"
```

### 2.4 Wave 3 – Legacy-Transfer
```
Lies cluster-docs/10_Legacy-Delta/LEGACY_DELTA_ANALYSE.md.
Identifiziere die P1-Lücken für [REPO-NAME].
Erstelle alle fehlenden Dateien aus der Prioritätsliste.
Aktualisiere README.md: ergänze neue Dateien im Startbefehl-Abschnitt.
Committe mit: "feat(wave3): Legacy-Transfer P1 abgeschlossen fuer [REPO-NAME]"
```

---

## 3. Bestehende Repos aktualisieren

### 3.1 Neue Datei hinzufügen + README patchen
```
Erstelle docs/[PFAD]/[DATEINAME].md in [REPO-NAME] mit folgendem Inhalt:
[INHALT]

Patche danach README.md: Füge die neue Datei in die nummerierte Liste
im Abschnitt "Startbefehl" / "Verbindlich lesen" ein.
Committe beides zusammen: "docs: [DATEINAME] hinzugefuegt + README Startbefehl aktualisiert"
```

### 3.2 Mehrere Repos gleichzeitig aktualisieren
```
Führe folgende Änderung in allen 7 v5-Repos durch:
[BESCHREIBUNG DER ÄNDERUNG]

Repos: project-reloaded-cluster-v5, Cluster-Control-v5, Marketing-Fabrik-v5,
 Social-Media-Fabrik-v5, Ebook-Fabrik-v5, Trading-Fabrik-v5, RefactorCo-Fabrik-v5

Nutze ein Python-Skript via ssh_exec. Klone alle Repos nach /tmp/, führe die
Änderung durch, committe einheitlich und pushe.
Commit-Message: "feat: [BESCHREIBUNG] in allen 7 v5-Repos"
```

### 3.3 README Startbefehl prüfen
```
Lies README.md aus [REPO-NAME].
Prüfe: Sind alle Dateien unter docs/ auch im Startbefehl-Abschnitt gelistet?
Fehlt etwas? Ergänze es.
Committe mit: "docs: README Startbefehl auf aktuellen Stand gebracht"
```

---

## 4. Git-Operationen

### 4.1 Sauberer Push (Standardfall)
```
Klone [REPO-URL] nach /tmp/[REPO-DIR].
Führe die Änderungen durch.
git add -A
git commit -m "[COMMIT-MESSAGE]"
git push
Bestätige mit: PUSHED oder Fehlerausgabe.
```

### 4.2 Mehrere Commits in einem Repo
```
Nach jeder logischen Einheit committen.
Faustregel: 1 Commit = 1 Datei oder 1 zusammenhängende Gruppe.
Niemals README + neue Docs in separaten Commits ohne Grund.
```

### 4.3 Branch + PR (für größere Änderungen)
```
Erstelle Branch: feature/[KURZBESCHREIBUNG]
Führe alle Änderungen auf dem Branch durch.
Erstelle PR mit Titel: "[WAVE/BEREICH]: [WAS WURDE GEMACHT]"
Merge erst nach Prøfung.
```

---

## 5. Analyse-Befehle

### 5.1 Aktuellen Stand eines Repos ermitteln
```
Lies README.md und docs/governance/WAHRHEITS_HIERARCHIE.md aus [REPO-NAME].
Sage mir:
1. Welche Wave ist aktiv?
2. Welche Gates sind offen?
3. Welche Dateien fehlen laut README aber sind nicht im Repo?
```

### 5.2 Cross-Repo-Status
```
Vergleiche die README-Dateien aller 7 v5-Repos.
Erstelle eine Tabelle: Repo | Wave | offene Gates | letzte Aktivität.
Speichere das Ergebnis als cluster-docs/08_Betrieb/CROSS_REPO_STATUS.md.
```

### 5.3 Drift-Erkennung
```
Klone alle 7 v5-Repos.
Prüfe: Welche Dateien sind in Repo A vorhanden aber in Repo B fehlen,
obwohl sie laut WAHRHEITS_HIERARCHIE in allen Repos sein sollten?
Liste die Drifts auf.
```

---

## 6. Session-Abschluss (Handoff)

Am Ende jeder Arbeitssession:
```
Erstelle einen Session-Handoff in _ai/openclaw/sessions/[DATUM]-[THEMA].md.
Inhalt:
- Was wurde heute gemacht (Commits, Dateien)
- Aktueller Wave-Stand pro Repo
- Nächster priorisierter Schritt
- Offene Gates / Blocker
Committe mit: "docs(session): Handoff [DATUM] gespeichert"
```

---

## 7. Sicherheits-Regeln (nicht verhandelbar)

| Regel | Beschreibung |
|-------|-------------|
| Kein Hard-coded Token | Immer `${GITHUB_TOKEN}` als Platzhalter – OpenClaw ersetzt aus credentials.env |
| Kein Direkt-Push auf main ohne Prüfung | Bei großen Änderungen Branch + PR nutzen |
| Live-Keys nur auf vm-106 | Gilt für Trading – niemals in Repo commiten |
| Repo-first | Chat-Aussagen niemals über Repo-Stand stellen |
| 1 Commit = 1 logische Einheit | Keine gemischten Commits |
| Keine stillen Scope-Änderungen | Scope-Änderungen immer explizit benennen |

---

## 8. Häufige Fehlermuster und Korrekturen

### "OpenClaw hat alten Stand"
```
Lies zuerst README.md neu. Dann: git log --oneline -5 im Repo.
Sage mir: Was ist der letzte Commit und wann?
```

### "OpenClaw schreibt Token in den Code"
→ Antwort: *"go ahead"* – OpenClaw generiert dann selbst die sichere Variante mit `${GITHUB_TOKEN}`.

### "Commit-Message falsch"
```
Ändere die letzte Commit-Message zu: "[NEUE MESSAGE]"
Nutze: git commit --amend -m "[NEUE MESSAGE]" && git push --force
```

### "README-Patch hat falsche Nummerierung"
```
Lies README.md. Finde den letzten Eintrag in der nummerierten Liste.
Füge neue Einträge ab Nummer [N+1] ein.
```

---

*Stand: 2026-04-16 | Gilt für alle 7 v5-Repos + cluster-docs*

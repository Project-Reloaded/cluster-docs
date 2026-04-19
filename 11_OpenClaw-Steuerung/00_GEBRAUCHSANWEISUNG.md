# OpenClaw – Gebrauchsanweisung

**System:** OpenClaw (basiert auf Claude Code / Claude Agent SDK)
**VM:** VM 100 — 192.168.1.20 Port 18789
**Cluster:** Project-Reloaded
**Stand:** April 2026

---

## 1. Was ist OpenClaw?

OpenClaw ist ein KI-Agent, der auf Claude Code (Anthropic) basiert und als Gateway-Service
auf VM 100 deines Proxmox-Clusters läuft. Er verwaltet Git-Repos, baut Dokumentation auf,
führt SSH-Befehle aus und überwacht Cluster-Gesundheit.

OpenClaw verwaltet 7 "Fabrik"-Repos im GitHub-Konto Project-Reloaded:

| Repo | Funktion |
|------|----------|
| project-reloaded-cluster-v5 | Übergeordnete Cluster-Koordination |
| Cluster-Control-v5 | Orchestrierung, Monitoring, Failover |
| Trading-Fabrik-v5 | Trading/Krypto – Live-Keys auf Node-4 |
| Social-Media-Fabrik-v5 | Content-Pipelines, K-R Bundle-System |
| Marketing-Fabrik-v5 | Marketing-Funnel, Kampagnen |
| Ebook-Fabrik-v5 | Ebook-Produktion und Export |
| RefactorCo-Fabrik-v5 | Code-Refactoring, Multi-Case A-G |

Zusätzlich pflegt OpenClaw dieses `cluster-docs`-Repo als zentrales Wissensarchiv.

---

## 2. OpenClaw starten

### 2.1 Gateway starten (auf VM 100 / per SSH)

```bash
ssh root@192.168.1.20
openclaw gateway run
```

### 2.2 Tokenisierte Dashboard-URL abrufen

```bash
openclaw dashboard
```

Das gibt eine URL mit integriertem Token aus, die du direkt im Browser öffnest.

### 2.3 Web-Oberfläche öffnen

Öffne im Browser: **http://192.168.1.20:18789**

Dort findest du das **OpenClaw Gateway-Dashboard** mit:
- WebSocket-URL (aus Schritt 2.2 kopieren)
- Gateway-Token (aus Schritt 2.2 kopieren)

Füge URL und Token ein → **Verbinden**.

> **Hinweis:** Die UI benötigt eine sichere Verbindung (HTTPS oder localhost) für volle
> Funktionalität. Bei HTTP-Zugriff über LAN können manche Funktionen eingeschränkt sein.

### 2.4 Direkt über tokenisierte URL (empfohlen)

Der einfachste Weg: `openclaw dashboard` gibt eine vollständige URL mit eingebettetem Token aus.
Diese direkt im Browser öffnen – kein manuelles Eintippen von Token nötig.

---

## 3. Wichtigste Befehle an OpenClaw

OpenClaw versteht strukturierte Befehlstexte (Prompts). Du schreibst den Befehl im Chat-Feld
des Dashboards oder gibst ihn als Datei über die API.

### 3.1 Cluster-Gesundheit prüfen

**Vollständiger Cluster-Audit (täglich oder vor Änderungen):**
```
AUDIT1
```
Führt Netzwerk-Audit + Proxmox-Health + Service-Check in einem Durchgang aus und speichert
einen Bericht unter `_ai/openclaw/sessions/[DATUM]-AUDIT1-cluster.md`.

**Nur Netzwerk prüfen:**
```
NW1
```
Prüft alle 6 Netzwerkgeräte auf Erreichbarkeit:
UniFi Controller (192.168.1.1), OPNsense (192.168.1.49 / .50), Pi-hole (.16/.17),
TP-Link Switch (192.168.1.74)

**Nur Proxmox-VMs prüfen:**
```
VM1
```
Zeigt CPU/RAM/Disk-Auslastung aller VMs als Tabelle.

**Nur Services auf VMs prüfen:**
```
SYS1
```
Führt `systemctl --failed`, `df -h`, `free -m`, `uptime` auf kritischen VMs aus.

### 3.2 Session starten (jede neue Arbeitssession)

Vor allem anderen immer zuerst:
```
Du arbeitest jetzt in [REPO-NAME].
Lies zuerst README.md und dann alle Dateien im Verzeichnis docs/.
Fasse danach in 3 Sätzen zusammen: (1) wo wir aktuell stehen,
(2) was der nächste offene Schritt ist, (3) welche Gate-Bedingungen noch fehlen.
```

Für cluster-weite Sessions (alle 7 Repos):
```
Du arbeitest jetzt im Project-Reloaded Cluster.
Repos: project-reloaded-cluster-v5, Cluster-Control-v5, Marketing-Fabrik-v5,
Social-Media-Fabrik-v5, Ebook-Fabrik-v5, Trading-Fabrik-v5, RefactorCo-Fabrik-v5.
Lies zuerst cluster-docs/10_Legacy-Delta/LEGACY_DELTA_ANALYSE.md.
Wahrheitshierarchie: GitHub-Repo > ZIP > Evidence > Legacy > Chat.
```

### 3.3 Neue Datei in einem Repo erstellen

```
Erstelle docs/[PFAD]/[DATEINAME].md in [REPO-NAME] mit folgendem Inhalt:
[INHALT]
Patche danach README.md: Füge die neue Datei in die nummerierte Liste ein.
Committe beides zusammen: "docs: [DATEINAME] hinzugefügt + README aktualisiert"
```

### 3.4 Session-Handoff (am Ende jeder Session)

```
Erstelle _ai/openclaw/sessions/[DATUM]-[THEMA].md in [REPO-NAME].
Inhalt: Was wurde heute gemacht, aktueller Wave-Stand, nächste 10 Schritte, offene Gates.
Committe mit: "docs(session): Handoff [DATUM] gespeichert"
```

---

## 4. Wave-System – Repo-Aufbau

Jedes der 7 Fabrik-Repos wird nach einem 7-Stufen-Modell aufgebaut:

| Wave | Ziel | Schlüsseldatei | Gate |
|------|------|----------------|------|
| 0.x | Grundstruktur | README.md | Verzeichnisse angelegt |
| 1.x | Truth Bootstrap | WAHRHEITS_HIERARCHIE.md | 3 Governance-Docs vorhanden |
| 2.x | VM-Rollen + Regeln | VM_ROLLEN.md | Alle VMs definiert |
| 3.x | Legacy-Transfer | LEGACY_DELTA_ANALYSE P1 | Keine P1-Lücken |
| 4.x | Install-Bereit | INSTALL_SEQUENCE.md | Alle Gates grün |
| 5.x | Betrieb aktiv | RUNBOOK.md | VMs laufen |
| 6.x | Self-improving | TBD | Lernschleife bestätigt |
| 7.x | Freeze / 100% | CHANGELOG frozen | Keine offenen Punkte |

Den aktuellen Wave-Stand jedes Repos abfragen:
```
Lies README.md aus [REPO-NAME]. Sage mir den aktuellen Wave-Stand.
```

---

## 5. Credentials und Zugangsdaten

OpenClaw liest alle Zugangsdaten aus:

```
/root/.openclaw/credentials.env
```

Diese Datei enthält (mindestens):
- `GITHUB_TOKEN=...` – für alle GitHub/Git-Operationen
- SSH-Schlüssel-Pfade für Cluster-Nodes
- API-Zugänge (Proxmox, etc.)

> **Sicherheitsregel:** Token **niemals** in den Chat schreiben oder in Repos committen.
> OpenClaw verwendet intern immer `${GITHUB_TOKEN}` als Platzhalter.

---

## 6. Superpowers-Plugin – Erweiterte Agentic Skills

**Superpowers** (github.com/obra/superpowers) ist ein Framework für erweiterte KI-Fähigkeiten
(Werkzeuge, Skills, agentic Actions) für Claude Code / OpenClaw.

### 6.1 Superpowers installieren

Im OpenClaw-Chat-Interface oder direkt per Claude Code CLI auf VM 100:

```
/plugin install superpowers@claude-plugins-official
```

Alternativ über den Plugin-Marketplace in der Claude Code / OpenClaw UI.

### 6.2 Nach der Installation prüfen

```
/plugins list
```

Superpowers sollte in der Liste erscheinen. Die verfügbaren Befehle werden automatisch
in den Befehlskatalog von OpenClaw eingebunden.

### 6.3 Was Superpowers bietet

- Erweiterte Tool-Use-Fähigkeiten (Dateisystem, Web, Code-Execution)
- Agentic Skill-Chaining (mehrstufige Aufgaben automatisieren)
- Verbesserte Kontext-Verwaltung über Sessions hinweg
- Community-Skills aus dem Plugin-Ökosystem

> **Empfehlung:** Nach der Installation einen AUDIT1 durchführen, um sicherzustellen,
> dass alle bestehenden Workflows weiterhin funktionieren.

---

## 7. Wahrheitshierarchie

OpenClaw priorisiert Informationsquellen in dieser Reihenfolge:

```
GitHub-Repo > ZIP > Evidence > Legacy > Chat
```

Das bedeutet: Was im Repo steht, gilt immer über das, was im Chat gesagt wurde.
Chat-Aussagen können durch Repo-Inhalte widerlegt werden.

---

## 8. Sicherheitsregeln (nicht verhandelbar)

| Regel | Details |
|-------|---------|
| Kein Hard-coded Token | Immer `${GITHUB_TOKEN}` – nie im Klartext |
| Kein Direkt-Push auf main | Bei großen Änderungen Branch + PR |
| Live-Keys nur auf vm-106 | Gilt für Trading – niemals ins Repo committen |
| Repo-first | Chat niemals über Repo-Stand stellen |
| 1 Commit = 1 logische Einheit | Keine gemischten Commits |
| Keine stillen Scope-Änderungen | Immer explizit benennen |
| Kein Auto-Publish | Content immer durch Mensch freigeben |

---

## 9. Befehlsreferenz – Schnellübersicht

| Befehl | Beschreibung | Dokument |
|--------|-------------|----------|
| `AUDIT1` | Vollständiger Cluster-Audit (NW+VM+SYS) | OPENCLAW_BEFEHLSKATALOG.md |
| `NW1` | Netzwerk-Audit aller 6 Geräte | OPENCLAW_BEFEHLSKATALOG.md |
| `VM1` | Proxmox VM- und Node-Health | OPENCLAW_BEFEHLSKATALOG.md |
| `SYS1` | Service-Check auf allen VMs | OPENCLAW_BEFEHLSKATALOG.md |
| `B1` | Session-Start für ein Repo | OPENCLAW_BEFEHLSKATALOG.md |
| `B2–B5` | Repo-Aufbau-Schritte (Wave 3.x) | OPENCLAW_BEFEHLSKATALOG.md |
| `B6` | Session-Handoff speichern | OPENCLAW_BEFEHLSKATALOG.md |
| `CW1–CW7` | Cluster-weite Operationen | OPENCLAW_BEFEHLSKATALOG.md |

---

## 10. Verweise und weiterführende Dokumente

| Dokument | Inhalt |
|----------|--------|
| `11_OpenClaw-Steuerung/OPENCLAW_KOMMANDOS.md` | Alle Steuerungsbefehle mit Vorlagen |
| `11_OpenClaw-Steuerung/OPENCLAW_BEFEHLSKATALOG.md` | Vollständiger Katalog, alle 7 Repos |
| `11_OpenClaw-Steuerung/REPO_BUILD_ANLEITUNG.md` | Schritt-für-Schritt Repo-Aufbau |
| `11_OpenClaw-Steuerung/LEGACY_STEUERUNG_VERGLEICH.md` | Vergleich alt vs. neu |
| `08_Betrieb/CROSS_REPO_STATUS.md` | Aktueller Status aller 7 Repos |
| `09_OpenClaw-Memory/00_Memory-Uebersicht.md` | Dauerhafte Wissens-Ablage |
| `10_Legacy-Delta/LEGACY_DELTA_ANALYSE.md` | P1-Lücken aus Legacy-Analyse |

---

*Stand: April 2026 | OpenClaw auf VM 100 (192.168.1.20:18789) | cluster-docs*

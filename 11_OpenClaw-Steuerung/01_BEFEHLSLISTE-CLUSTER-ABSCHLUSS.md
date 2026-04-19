# OpenClaw - Komplette Befehlsliste: Cluster-Repos fertigstellen

> Stand: April 2026 | OpenClaw 2026.4.11 | VM 100 (192.168.1.20:18789)
> Alle Befehle = Nachrichten, die du an OpenClaw schickst (WhatsApp / Telegram / WebSocket)

---

## 1. Zur Wiki-Frage: Speichert OpenClaw automatisch?

**Teilweise ja, aber nicht 100% zuverlaessig.**

OpenClaw ist im System-Prompt angewiesen: *"After any significant change: Always update the wiki."*
Der `github-wiki` MCP-Server mit `wiki_write` ist vorhanden und aktiv.

**Praxis-Regel:** Am Ende JEDER Session immer diesen Befehl schicken:

```
Speichere den heutigen Fortschritt ins Wiki unter 09_OpenClaw-Memory/DATUM.md
mit einer Zusammenfassung was erledigt wurde und was noch offen ist.
```

---

## 2. Aktueller Status aller Repos (geprueft 19.04.2026)

| Repo | Wave | INSTALL_SEQUENCE.md | CLUSTER_DEPS.md | docs/VM_SPEC.md |
|------|------|---------------------|-----------------|-----------------|
| RefactorCo-Fabrik-v5 | Wave 2/3 | [FEHLT] | [FEHLT] | [FEHLT] |
| Cluster-Control-v5 | Wave 3 | [FEHLT] | [FEHLT] | [FEHLT] |
| Trading-Fabrik-v5 | Wave 3 | [FEHLT] | [FEHLT] | [FEHLT] |
| Social-Media-Fabrik-v5 | Wave 3 | [FEHLT] | [FEHLT] | [FEHLT] |
| Marketing-Fabrik-v5 | Wave 3 | [FEHLT] | [FEHLT] | [FEHLT] |
| Ebook-Fabrik-v5 | Wave 3 | [FEHLT] | [FEHLT] | [FEHLT] |
| project-reloaded-cluster-v5 | Wave 3 | [FEHLT] | [FEHLT] | [FEHLT] |

**Was fehlt ueberall (3 Dateien pro Repo = 21 Dateien gesamt):**
- `INSTALL_SEQUENCE.md` - Installationsreihenfolge der Services auf den VMs
- `CLUSTER_DEPS.md` - Abhaengigkeiten zu anderen Fabriken im Cluster
- `docs/VM_SPEC.md` - VM-Spezifikation (CPU, RAM, Disk, Netzwerk)

---

## 3. Reihenfolge der Abarbeitung

Repos EINZELN abarbeiten (nicht gleichzeitig).

```
1. RefactorCo-Fabrik-v5        <- Wave 2 abschliessen ZUERST
2. Cluster-Control-v5          <- Kern-Infrastruktur
3. Trading-Fabrik-v5
4. Social-Media-Fabrik-v5
5. Marketing-Fabrik-v5
6. Ebook-Fabrik-v5
7. project-reloaded-cluster-v5 <- ZULETZT (braucht alle anderen als Input)
```

---

## 4. SESSION-START - Immer zuerst senden

```
Lies den letzten Eintrag in cluster-docs/09_OpenClaw-Memory/ und gib mir
eine kurze Zusammenfassung was zuletzt erledigt wurde und was heute als
naechstes dran ist.
```

---

## 5. Befehlsliste pro Repo

---

### REPO 1: RefactorCo-Fabrik-v5
**Besonderheit:** Wave 2 zuerst abschliessen (VM_ROLLEN.md + Governance fehlen)

**Schritt 1 - Wave 2 pruefen:**
```
Lies RefactorCo-Fabrik-v5/README.md und zeige mir den aktuellen Wave-Status
und welche Wave-2-Dokumente noch fehlen.
```

**Schritt 2 - Wave 2 abschliessen:**
```
Erstelle in RefactorCo-Fabrik-v5 die fehlenden Wave-2-Dokumente.
Lese docs/governance/ und docs/architecture/ fuer den Kontext.
Erstelle VM_ROLLEN.md im Root mit Beschreibung der VM-Rollen.
Schreibe danach ins Wiki was erstellt wurde.
```

**Schritt 3 - INSTALL_SEQUENCE.md:**
```
Lies RefactorCo-Fabrik-v5/docs/architecture/ und WORKFLOW.md vollstaendig.
Erstelle INSTALL_SEQUENCE.md im Root: Voraussetzungen, VM-Setup,
Service-Deployment, Health-Checks.
```

**Schritt 4 - docs/VM_SPEC.md:**
```
Erstelle RefactorCo-Fabrik-v5/docs/VM_SPEC.md mit VM-Anforderungen:
CPU, RAM, Disk, Netzwerk-Interfaces, Hostname-Schema, IP-Bereich.
```

**Schritt 5 - CLUSTER_DEPS.md:**
```
Lies RefactorCo-Fabrik-v5/docs/integrations/ oder docs/architecture/ und
erstelle CLUSTER_DEPS.md: welche Services benoetigt diese Fabrik,
welche stellt sie bereit?
```

**Schritt 6 - Abschliessen:**
```
Pruefe ob INSTALL_SEQUENCE.md, CLUSTER_DEPS.md und docs/VM_SPEC.md vorhanden sind.
Aktualisiere README.md mit neuem Wave-Status.
Speichere Zusammenfassung in cluster-docs/09_OpenClaw-Memory/refactorco-wave3-complete.md
```

---

### REPO 2: Cluster-Control-v5

**Schritt 1 - Kontext laden:**
```
Lies Cluster-Control-v5/README.md, WORKFLOW.md und docs/architecture/ komplett.
Zusammenfassung: Was macht diese Komponente?
```

**Schritt 2 - INSTALL_SEQUENCE.md:**
```
Erstelle Cluster-Control-v5/INSTALL_SEQUENCE.md:
Voraussetzungen, VM-Setup, Control-Plane-Deployment, Integration-Tests, Health-Checks.
```

**Schritt 3 - docs/VM_SPEC.md:**
```
Erstelle Cluster-Control-v5/docs/VM_SPEC.md.
Control-VM braucht mehr CPU/RAM als Fabriken.
```

**Schritt 4 - CLUSTER_DEPS.md:**
```
Erstelle Cluster-Control-v5/CLUSTER_DEPS.md:
Alle Fabriken sind Downstream-Abhaengigkeiten.
Welche Infrastruktur braucht Control selbst?
```

**Schritt 5 - Wiki:**
```
Speichere Fortschritt in cluster-docs/09_OpenClaw-Memory/cluster-control-wave3-complete.md
```

---

### REPO 3: Trading-Fabrik-v5

**Schritt 1 - Kontext:**
```
Lies Trading-Fabrik-v5/README.md, WORKFLOW.md und docs/ komplett.
Welche Services, welche externen APIs?
```

**Schritt 2 - INSTALL_SEQUENCE.md:**
```
Erstelle Trading-Fabrik-v5/INSTALL_SEQUENCE.md.
Dokumentiere benoetigte Secrets/Credentials (ohne Werte!).
Hinweis: Trading-Daten duerfen NICHT ins Repo.
```

**Schritt 3 - docs/VM_SPEC.md:**
```
Erstelle Trading-Fabrik-v5/docs/VM_SPEC.md
```

**Schritt 4 - CLUSTER_DEPS.md:**
```
Erstelle Trading-Fabrik-v5/CLUSTER_DEPS.md mit Abhaengigkeiten zu anderen Fabriken.
```

**Schritt 5 - Wiki:**
```
Speichere Fortschritt in cluster-docs/09_OpenClaw-Memory/trading-wave3-complete.md
```

---

### REPO 4: Social-Media-Fabrik-v5

**Schritt 1:**
```
Lies Social-Media-Fabrik-v5/README.md, WORKFLOW.md und docs/ komplett.
```

**Schritt 2 - INSTALL_SEQUENCE.md:**
```
Erstelle Social-Media-Fabrik-v5/INSTALL_SEQUENCE.md inkl. OAuth/API-Key Setup.
```

**Schritt 3:** `Erstelle Social-Media-Fabrik-v5/docs/VM_SPEC.md`

**Schritt 4 - CLUSTER_DEPS.md:**
```
Erstelle Social-Media-Fabrik-v5/CLUSTER_DEPS.md.
Empfaengt Content von Marketing-Fabrik?
```

**Schritt 5:** `Speichere in cluster-docs/09_OpenClaw-Memory/social-media-wave3-complete.md`

---

### REPO 5: Marketing-Fabrik-v5

**Schritt 1:** `Lies Marketing-Fabrik-v5/README.md, WORKFLOW.md und docs/`

**Schritt 2:** `Erstelle Marketing-Fabrik-v5/INSTALL_SEQUENCE.md`

**Schritt 3:** `Erstelle Marketing-Fabrik-v5/docs/VM_SPEC.md`

**Schritt 4 - CLUSTER_DEPS.md:**
```
Erstelle Marketing-Fabrik-v5/CLUSTER_DEPS.md.
Marketing liefert Content an Social-Media - beide Richtungen dokumentieren.
```

**Schritt 5:** `Speichere in cluster-docs/09_OpenClaw-Memory/marketing-wave3-complete.md`

---

### REPO 6: Ebook-Fabrik-v5

**Schritt 1:**
```
Lies Ebook-Fabrik-v5/README.md, WORKFLOW.md und docs/ komplett.
Vorhandene Ordner: agents, architecture, factory, governance, knowledge,
migration, operators, process, runtime
```

**Schritt 2 - INSTALL_SEQUENCE.md:**
```
Erstelle Ebook-Fabrik-v5/INSTALL_SEQUENCE.md.
Beachte runtime/ - dort stehen die Deployment-Infos.
```

**Schritt 3:** `Erstelle Ebook-Fabrik-v5/docs/VM_SPEC.md`

**Schritt 4:** `Erstelle Ebook-Fabrik-v5/CLUSTER_DEPS.md (von welchen Fabriken kommen Inputs?)`

**Schritt 5:** `Speichere in cluster-docs/09_OpenClaw-Memory/ebook-wave3-complete.md`

---

### REPO 7: project-reloaded-cluster-v5 (ZULETZT!)

**Schritt 1 - Alle Repos pruefen:**
```
Pruefe ob in allen 6 Fabrik-Repos INSTALL_SEQUENCE.md, CLUSTER_DEPS.md
und docs/VM_SPEC.md vorhanden sind. Zeige Statusuebersicht.
```

**Schritt 2 - Master INSTALL_SEQUENCE.md:**
```
Lies alle INSTALL_SEQUENCE.md aus den 6 Repos und erstelle
project-reloaded-cluster-v5/INSTALL_SEQUENCE.md als Master-Anleitung.
Reihenfolge: Infrastruktur zuerst, dann Fabriken nach Abhaengigkeiten.
```

**Schritt 3 - Master VM_SPEC.md:**
```
Erstelle project-reloaded-cluster-v5/docs/VM_SPEC.md als Gesamtuebersicht
aller VMs mit Links auf die einzelnen Fabrik-VM_SPEC.md Dateien.
```

**Schritt 4 - Master CLUSTER_DEPS.md:**
```
Erstelle project-reloaded-cluster-v5/CLUSTER_DEPS.md als vollstaendigen
Dependency-Graph aller Fabriken untereinander.
```

**Schritt 5 - Gates setzen:**
```
Pruefe delta_wave_ready und cross_repo_ready Gates.
Wenn beide PASS: Erstelle project-reloaded-cluster-v5/docs/CLUSTER_INTEGRATION_READY.md
und aktualisiere alle README.md auf Wave 4.
```

**Schritt 6 - Abschlussbericht:**
```
Schreibe Abschlussbericht in cluster-docs/09_OpenClaw-Memory/CLUSTER-WAVE4-COMPLETE.md:
- Was wurde erledigt
- Alle erstellten Dateien
- Naechste Schritte Wave 5 (Testen, Deployment)
Aktualisiere cluster-docs/05_Fabriken/ mit neuem Status.
```

---

## 6. Schnell-Befehl: Gesamtstatus pruefen

```
Pruefe in allen 7 v5-Repos ob INSTALL_SEQUENCE.md, CLUSTER_DEPS.md und
docs/VM_SPEC.md vorhanden sind. Zeige Statusuebersicht als Tabelle.
```

---

## 7. Fehlerkorrektur

```
Der letzte Commit war falsch. Lese [REPO]/[DATEI] nochmal und
korrigiere [was falsch war]. Committe mit Message "fix: ..."
```

---

## 8. OpenClaw-Verbindung

| Kanal | Adresse |
|-------|---------|
| WebSocket | http://192.168.1.20:18789 |
| Health | http://192.168.1.20:18789/health |

---

## 9. Zusammenfassung

Pro Session: 1 Repo, 5-6 Schritte, Wiki-Save am Ende.
Gesamtaufwand: ~7 Sessions a 20-30 Minuten.
Ergebnis: Wave 4 + CLUSTER_INTEGRATION_READY Gate erfuellt.

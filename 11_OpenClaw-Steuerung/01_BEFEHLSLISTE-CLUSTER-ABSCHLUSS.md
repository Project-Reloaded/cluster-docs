# OpenClaw — Befehlsliste: Cluster-Repos fertigstellen
# (mit Alt-Repo-Analyse und Review-Gates)

> Stand: April 2026 | OpenClaw 2026.4.11 | VM 100 (192.168.1.20:18789)
> Alle Befehle = Nachrichten an OpenClaw (WhatsApp / Telegram / WebSocket)

---

## WICHTIGSTE REGEL: OpenClaw schreibt NIEMALS ohne deinen OK

OpenClaw ist so konfiguriert:
1. Zuerst altes + neues Repo LESEN
2. Einen PLAN praesentieren (was woher kommt, was uebernommen wird)
3. WARTEN auf deine Bestaetigung
4. Erst nach "ja" / "ok" / "mach es" wird geschrieben

Du musst also bei jedem Schritt aktiv zustimmen. Das ist Absicht.

---

## Alt-Repo-Mapping (wo die wertvollen Inhalte liegen)

| Neues v5 Repo | Altes Repo mit Inhalt |
|---------------|----------------------|
| RefactorCo-Fabrik-v5 | RefactorCo-lab |
| Social-Media-Fabrik-v5 | Social-Media-Fabrik |
| Ebook-Fabrik-v5 | ebook-agent |
| Trading-Fabrik-v5 | trading-lab |
| project-reloaded-cluster-v5 | project-reloaded-cluster-v3, v4, archive |
| Cluster-Control-v5 | (kein direkter Vorgaenger — aus v3/v4 ableiten) |
| Marketing-Fabrik-v5 | (kein direkter Vorgaenger — aus platform-docs) |

Weitere Quellen: webshop-core, webshop-forks, ops-automations, platform-docs

---

## Was aus den alten Repos ZWINGEND geprueft werden muss

Folgende Themen stecken in den alten Repos und muessen besprochen werden:

- **GPU-Konfiguration** — wie werden GPUs angesprochen, welche Hardware
- **AI-Modelle**: ChatGPT-Plus, Codex-Plus, MiniMax-API, OpenAI-API, lokale Modelle
- **API-Keys / Credentials-Struktur** — wie waren sie organisiert
- **Webshop-Integration** — webshop-core/forks relevanz fuer Fabriken
- **Workflow-Logik** — was war der tatsaechliche Ablauf in den alten Repos
- **VM-Rollen** — welche VMs liefen tatsaechlich wofuer

Keines davon darf OpenClaw einfach "erfinden" — es muss aus den alten Repos
gelesen und mit dir besprochen werden.

---

## SESSION-START — Immer zuerst senden

```
Lies den letzten Eintrag in cluster-docs/09_OpenClaw-Memory/ und zeige mir
eine Zusammenfassung was zuletzt erledigt wurde und was heute als naechstes dran ist.
```

---

## Reihenfolge der Repos

```
1. RefactorCo-Fabrik-v5  (hat altes Repo: RefactorCo-lab)
2. Cluster-Control-v5    (aus v3/v4 ableiten)
3. Trading-Fabrik-v5     (hat altes Repo: trading-lab)
4. Social-Media-Fabrik-v5 (hat altes Repo: Social-Media-Fabrik)
5. Marketing-Fabrik-v5   (aus platform-docs ableiten)
6. Ebook-Fabrik-v5       (hat altes Repo: ebook-agent)
7. project-reloaded-cluster-v5  (ZULETZT — braucht alle anderen)
```

---

## BEFEHLSLISTE PRO REPO

---

### REPO 1: RefactorCo-Fabrik-v5
**Altes Repo: RefactorCo-lab**

**Schritt A — Altes Repo analysieren (ERST LESEN):**
```
Analysiere das alte Repo RefactorCo-lab vollstaendig:
- Lies README.md
- Liste alle Dateien und Ordner auf
- Lies alle relevanten Docs (Architektur, Workflow, VM-Konfiguration)
- Suche nach: GPU-Konfigurationen, AI-Modell-Settings, API-Integrationen,
  VM-Specs, Installationsanleitungen, Abhaengigkeiten zu anderen Services
Erstelle NOCH NICHTS. Zeige mir eine strukturierte Zusammenfassung
was du gefunden hast und was du fuer uebernahme-wuerdig haeltst.
```

**Schritt B — Neues Repo gegenueberstellen:**
```
Lies jetzt RefactorCo-Fabrik-v5 vollstaendig und vergleiche mit RefactorCo-lab.
Zeige mir:
1. Was ist im alten Repo vorhanden aber noch nicht im neuen?
2. Was wurde im neuen Repo anders/besser geloest?
3. Was ist im alten Repo veraltet oder nicht mehr relevant?
4. Offene Fragen die ich entscheiden muss
Warte auf meine Antwort bevor du irgendetwas schreibst.
```

**Schritt C — Du entscheidest, dann erst erstellen:**
```
[NACH deiner Antwort auf den Vergleich]
OK, uebernehme folgende Punkte aus RefactorCo-lab: [deine Angaben]
Erstelle jetzt INSTALL_SEQUENCE.md, CLUSTER_DEPS.md und docs/VM_SPEC.md
basierend auf dem was wir besprochen haben.
Zeige mir den Entwurf jeder Datei BEVOR du committest.
```

**Schritt D — Commit nur nach finaler Freigabe:**
```
[NACH deiner Pruefung der Entwuerfe]
Die Entwuerfe sind gut. Committe alle drei Dateien jetzt.
Speichere danach den Fortschritt in cluster-docs/09_OpenClaw-Memory/refactorco-done.md
```

---

### REPO 2: Cluster-Control-v5
**Kein direkter Vorgaenger — aus project-reloaded-cluster-v3 und v4 ableiten**

**Schritt A — Quell-Repos analysieren:**
```
Analysiere project-reloaded-cluster-v3 und project-reloaded-cluster-v4:
Suche speziell nach: Cluster-Control Komponenten, Steuerlogik, Control-Plane-Konfiguration,
GPU-Orchestrierung, AI-Modell-Verteilung auf VMs, welche Services von wo gesteuert werden.
Erstelle NOCH NICHTS. Zeige mir Zusammenfassung + Vorschlag was uebernommen werden soll.
```

**Schritt B — Vergleich und Fragen:**
```
Lese Cluster-Control-v5 vollstaendig. Vergleiche mit was du in v3/v4 gefunden hast.
Welche Control-Logik fehlt noch im v5? Was muss ich entscheiden?
```

**Schritt C + D — wie bei Repo 1 (Entwurf zeigen, dann commit nach OK)**

---

### REPO 3: Trading-Fabrik-v5
**Altes Repo: trading-lab**

**Schritt A:**
```
Analysiere trading-lab vollstaendig.
Suche speziell nach: Trading-Algorithmen/Logik, API-Verbindungen (Broker, Exchanges),
AI-Modell-Nutzung im Trading, GPU-Anforderungen, Daten-Handling (WICHTIG: keine
Live-Trading-Daten ins Repo!), VM-Konfiguration, Workflow.
Erstelle NOCH NICHTS. Zeige mir was du gefunden hast.
```

**Schritt B:**
```
Vergleiche trading-lab mit Trading-Fabrik-v5.
Was fehlt im neuen Repo? Was muss besprochen werden?
Besondere Achtung: Credentials, API-Keys, Trading-Secrets — diese duerfen
NIEMALS direkt ins Repo, nur als Platzhalter/Referenz.
```

**Schritt C + D — Entwurf zeigen, dann commit nach OK**

---

### REPO 4: Social-Media-Fabrik-v5
**Altes Repo: Social-Media-Fabrik**

**Schritt A:**
```
Analysiere Social-Media-Fabrik vollstaendig.
Suche nach: Social-Media-Plattformen (welche?), Content-Generierung mit AI-Modellen,
Posting-Automatisierung, API-Integrationen (Instagram, LinkedIn, Twitter/X etc.),
GPU/AI-Modell-Nutzung fuer Content, Abhaengigkeiten zu Marketing-Fabrik.
Erstelle NOCH NICHTS. Zeige mir Zusammenfassung.
```

**Schritt B:**
```
Vergleiche Social-Media-Fabrik mit Social-Media-Fabrik-v5.
Was fehlt? Was wurde neu strukturiert? Offene Entscheidungen?
```

**Schritt C + D — Entwurf zeigen, dann commit nach OK**

---

### REPO 5: Marketing-Fabrik-v5
**Kein direkter Vorgaenger — aus platform-docs und Cluster-v3/v4 ableiten**

**Schritt A:**
```
Analysiere platform-docs vollstaendig auf Marketing-relevante Inhalte.
Pruefe auch project-reloaded-cluster-v4 auf Marketing-Komponenten.
Suche nach: Content-Pipeline, AI-Content-Generierung (welche Modelle?),
Marketing-Automatisierung, Verbindung zu anderen Fabriken.
Erstelle NOCH NICHTS. Zeige mir was du gefunden hast.
```

**Schritt B:**
```
Lies Marketing-Fabrik-v5 vollstaendig.
Was ist der aktuelle Stand? Was fehlt komplett?
Welche Entscheidungen brauche ich von dir um weiterzumachen?
```

**Schritt C + D — Entwurf zeigen, dann commit nach OK**

---

### REPO 6: Ebook-Fabrik-v5
**Altes Repo: ebook-agent**

**Schritt A:**
```
Analysiere ebook-agent vollstaendig.
Suche nach: Ebook-Generierungs-Pipeline, AI-Modelle fuer Content (welche?),
GPU-Nutzung, Input-Quellen (woher kommen die Inhalte?), Output-Format,
Abhaengigkeiten zu anderen Fabriken, Deployment-Konfiguration.
Ebook-Fabrik-v5 hat bereits: agents/, architecture/, factory/, governance/,
knowledge/, migration/, operators/, process/, runtime/ — vergleiche damit.
Erstelle NOCH NICHTS. Zeige mir Zusammenfassung + Vorschlag.
```

**Schritt B:**
```
Vergleiche ebook-agent mit Ebook-Fabrik-v5.
Was ist besser im alten Repo dokumentiert? Was fehlt noch?
```

**Schritt C + D — Entwurf zeigen, dann commit nach OK**

---

### REPO 7: project-reloaded-cluster-v5 (ZULETZT!)
**Alte Repos: v3, v4, archive — erst wenn alle anderen fertig**

**Schritt A — Nur starten wenn Repos 1-6 fertig:**
```
Pruefe ob in allen 6 Fabrik-Repos (RefactorCo, Cluster-Control, Trading,
Social-Media, Marketing, Ebook) die Dateien INSTALL_SEQUENCE.md,
CLUSTER_DEPS.md und docs/VM_SPEC.md committed wurden.
Zeige mir den Status als Tabelle.
```

**Schritt B — Grosse Analyse:**
```
Analysiere project-reloaded-cluster-v3, v4 und project-reloaded-cluster-archive
auf: Master-Installationsreihenfolge, Cluster-Topologie, GPU-Verteilung auf VMs,
AI-Modell-Zuweisung zu Fabriken, Netzwerk-Konfiguration zwischen Fabriken,
Webshop-Integration (webshop-core/webshop-forks Bezug), gemeinsame Infrastruktur.
Erstelle NOCH NICHTS. Zeige vollstaendige Zusammenfassung.
```

**Schritt C:**
```
Vergleiche jetzt alle Erkenntnisse mit project-reloaded-cluster-v5.
Was fehlt in der Master-Struktur? Welche Entscheidungen brauche ich von dir?
Besonders: GPU-Zuweisung, AI-Modell-Verteilung, Webshop-Integration — 
diese Punkte MUESSEN besprochen werden bevor ich schreibe.
```

**Schritt D — Master-Dateien nach deiner Entscheidung:**
```
[NACH deinen Antworten]
Erstelle Master-INSTALL_SEQUENCE.md basierend auf was wir besprochen haben.
Zeige mir Entwurf vor dem Commit.
```

**Schritt E — Gates und Abschluss:**
```
Pruefe delta_wave_ready und cross_repo_ready Gates.
Wenn beide PASS: Zeige mir Entwurf fuer CLUSTER_INTEGRATION_READY.md
und den Wave-4-Status-Update fuer alle READMEs.
Erst nach meinem OK alles committen.
```

**Schritt F — Abschlussbericht:**
```
Schreibe Abschlussbericht in cluster-docs/09_OpenClaw-Memory/CLUSTER-WAVE4-COMPLETE.md
und aktualisiere cluster-docs/05_Fabriken/.
```

---

## Schnell-Check: Aktueller Status

```
Pruefe in allen 7 v5-Repos ob INSTALL_SEQUENCE.md, CLUSTER_DEPS.md
und docs/VM_SPEC.md vorhanden sind. Zeige Tabelle.
```

## Schnell-Check: Was steckt im alten Repo?

```
Analysiere [REPO-NAME] und zeige mir alle Dateien + kurze Inhaltsangabe.
Suche besonders nach GPU, AI-Modellen, API-Konfigurationen und VM-Specs.
```

---

## Falls OpenClaw trotzdem blind schreiben will

```
STOP. Zeige mir zuerst den Plan was du schreiben willst und woher der Inhalt kommt.
Ich entscheide dann ob du fortfahren kannst.
```

---

## OpenClaw-Verbindung

| Kanal | Adresse |
|-------|---------|
| WebSocket | http://192.168.1.20:18789 |
| Health | http://192.168.1.20:18789/health |

# MODEL_ACCESS_ARCHITECTURE

**Status:** PLANUNG — noch nicht implementiert  
**Stand:** 2026-05-07

## A) Zweck
Dieses Dokument beschreibt die **cluster-weite Doktrin**, wie Agenten und VMs der 7 v5-Repos auf KI-Modelle zugreifen.
Es trennt bewusst zwischen:
- interaktiver Nutzung durch Klaus
- agentischem Laufzeit-Zugriff im Cluster
- spaeteren lokalen Modell-Backends

## B) Problem
User-Abo-basierter Zugriff ueber ChatGPT-Plus oder ChatGPT-Pro skaliert **nicht** als Cluster-Backend fuer Agenten.

Hauptgruende:
- Account-Rate-Limits gelten pro Benutzerkonto, nicht pro sauber getrenntem Agenten-Job
- Web-Auth und Session-Cookies sind fragil und fuer Automationsketten ungeeignet
- Bot-artige Mehrfachzugriffe koennen von OpenAI als missbraeuchliches Verhalten gewertet werden
- Kosten, Routing und Fehlerbilder lassen sich ueber User-Abos nicht sauber pro Agent steuern

## C) Loesung
Empfohlen wird ein **zentrales Model-Gateway** als Routing-Schicht zwischen Agenten und externen bzw. lokalen Modell-Backends.

Empfohlene Basis:
- **LiteLLM Open Source (MIT)** als zentrale Gateway- und Routing-Schicht

Zielbild:
- Agenten sprechen **nicht direkt** gegen einzelne Anbieter-Auths
- Agenten sprechen gegen ein internes Gateway
- das Gateway uebernimmt Routing, Policy, Fallback, Budgetierung und Logging

## D) Backends
Das Gateway soll schrittweise mehrere Backend-Klassen anbinden:

- **OpenAI API**  
  GPT-4o / GPT-5 / o1 / o3 ueber API-Key, pay-per-use, fuer hochwertige General- und Architekturaufgaben
- **MiniMax API**  
  kosten-effizient fuer Bulk-Tasks, breite Hintergrundjobs und leichtere Agentenarbeit
- **Anthropic API**  
  Claude Sonnet / Opus fuer tiefe Audits, schwere Review-Laeufe und anspruchsvolle Refactor-Analysen
- **spaeter: vLLM auf eigener GPU-VM**  
  fuer lokale Modelle, Kostenentlastung, sensible oder massenhafte Jobs

## E) Per-Agent Routing-Policies
Das Routing soll **nicht global gleich**, sondern pro Rolle / Jobklasse steuerbar sein.

Beispiele:
- **Doctor-Agent** -> bevorzugt MiniMax fuer guenstige Diagnose-, Drift- und Routinechecks
- **Heavy Refactoring auf vm-303** -> bevorzugt Claude Sonnet fuer tiefe Code- und Strukturarbeit
- **komplexe Architektur-Reviews** -> bevorzugt GPT-5 / o1
- **Quick Audits / Routinechecks** -> bevorzugt MiniMax oder spaeter lokales vLLM
- **Portal-/Status-nahe Hilfsjobs** -> moeglichst guenstige oder lokale Modelle

## F) Kosten-Kontrolle
Das Gateway soll cluster-weit die Kosten- und Nutzungssteuerung ermoeglichen.

Pflichtziele:
- Budgets pro Agent / Rolle / Jobklasse
- Token-Tracking pro Lauf oder Job
- Reporting an Dashboard-/Status-Sichten, insbesondere fuer vm-302 und vm-307
- klare Trennung zwischen interaktiver Nutzung und Agentenbudget

## G) ChatGPT-Plus / Pro-Abos
ChatGPT-Plus und ChatGPT-Pro bleiben **Klaus' interaktive Werkzeuge**.
Sie sind **nicht** als Agenten-Backend fuer den Cluster gedacht.

Doktrin:
- **NUR fuer Klaus' interaktive Nutzung** (Cowork-Sessions, Browser, manuelle Analyse)
- **NICHT** als skalierbarer Backend-Zugang fuer automatisierte Agenten
- ChatGPT-Pro-5x bleibt Klaus als starke interaktive Session-Schicht erhalten, nicht als Multi-Agent-Gateway

## H) Implementation-Plan
### Phase A
LiteLLM als erstes zentrales Gateway aufsetzen.

Standort:
- **OFFEN** — entweder auf `vm-100` oder auf einer dedizierten Gateway-VM

### Phase B
- Per-Agent-Policies aktivieren
- Kosten-Tracking und Routing-Regeln verdrahten
- Reporting an Dashboard-/Statussicht anbinden

### Phase C
- eigene GPU-Ressource als lokales Backend anbinden
- vLLM als lokales Modell-Serving einfuehren
- geeignete Jobs schrittweise auf lokale Modelle verschieben

## I) Migrations-Pfad fuer bestehende OpenClaw-Auth
Die bestehende OpenClaw-/OpenAI-Nutzung soll **schrittweise** von User-Auth auf API-Key-basierten Gateway-Zugriff umgestellt werden.

Leitplanke:
- keine harte Big-Bang-Umstellung
- zuerst Gateway einziehen
- dann Agentenrollen nacheinander auf Routing-Policies umstellen
- bestehende OpenClaw-Codex-Auth ist bereits abgelaufen und ist daher ein sinnvoller Umstellungszeitpunkt

## J) Status
**PLANUNG — noch nicht implementiert.**

Dieses Dokument ist eine **cluster-weite Doktrin-Vorgabe**.
Es beschreibt die Zielrichtung fuer den Modellzugriff aller v5-Fabriken, aber noch keine abgeschlossene technische Inbetriebnahme.

# MODEL_ACCESS_IMPLEMENTATION_GUIDE

> **Stand 2026-05-08:** `vm-110-model-gateway` ist **LIVE-IDLE** auf `10.6.7.20` (**Debian 13 LXC**). Installiert: **LiteLLM 1.83.14** mit 6 Modellen (`claude-opus-4-6`, `claude-sonnet-4-6`, `claude-haiku-4-5`, `gpt-4o`, `gpt-4o-mini`, `minimax-text-01`), `systemd`-Unit `litellm.service` = **active**, Health = **200 OK**. API-Keys bleiben **deferred bis Klaus GO Live**. Container-Netz: **Bridge `vmbr2`, Tag `17`**, **nicht VLAN 7**. SSH-Key `openclaw@proxmox-infra` liegt in `authorized_keys`. Env-Template liegt unter `/etc/litellm/litellm.env.template` mit Platzhaltern fuer `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `MINIMAX_API_KEY`.

**Status:** LIVE-IDLE — vorbereitet, aber noch nicht fuer Live-Providerbetrieb aktiviert  
**Stand:** 2026-05-08

## A) Zweck
Dieses Dokument ist die **Implementation-Vorbereitung** fuer das LiteLLM-Gateway aus:
- `09_Architektur/MODEL_ACCESS_ARCHITECTURE.md`

Es beschreibt den cluster-weiten Zielpfad fuer den Modellzugriff und dokumentiert zugleich den aktuellen **Idle-Live-Basisstand** auf `vm-110-model-gateway`.

Wichtig:
- Die Basis-VM und der Gateway-Stack sind **vorinstalliert und idle erreichbar**
- Dieses Dokument ist **keine** Aussage, dass Live-Providerbetrieb schon freigeschaltet ist
- API-Keys bleiben bis zur ausdruecklichen Live-Freigabe durch Klaus **absichtlich ausstehend**
- Keine Agenten-Migration, keine Provider-Tests und keine Live-Schaltung ohne ausdrueckliches GO

## B) VM-Wahl: dedizierte Service-VM `vm-110-model-gateway`

### Warum `vm-100` ausscheidet
- `vm-100` ist die **OpenClaw-Steuerungs-VM**
- eine zusaetzliche Gateway-Rolle dort wuerde **Betriebsrollen vermischen**
- fuer cluster-weite Modellsteuerung ist eine **saubere Trennung** vorzuziehen

### Warum `vm-308` ausscheidet
- `vm-308` ist der **RefactorCo-Slot auf Node-3**
- diese VM ist **nicht cluster-weit neutral**, sondern bereits fachlich vorgepraegt
- sie ist daher **kein sauberer Zielort** fuer einen zentralen Shared-Service

### Empfehlung
Empfohlen wird eine **dedizierte cluster-weite Service-VM**:
- **Name:** `vm-110-model-gateway`
- **Node:** `Node-1`
- **Slot-Lage:** zwischen `vm-108` (Tor) und `vm-200`
- **Service-IP:** `10.6.7.20`
- **Netz:** `vmbr2`, VLAN-Tag `17` (`10.6.7.x` / `VMs_DMZ`)

Diese Wahl schafft:
- saubere Trennung zwischen OpenClaw-Laufzeit und Model-Gateway
- cluster-weite Neutralitaet statt Fabrik-Sonderrolle
- klarere Betriebs-, Upgrade- und Fehlergrenzen
- bessere Grundlage fuer spaeteres Routing, Logging, Limits und Kostensteuerung
- Platzierung im **Service-VLAN `10.6.7.x` hinter OPNsense** statt im flacheren `192.168.1.x`-Bereich ohne vorgeschaltete Firewall

## C) VM-Spezifikation `vm-110-model-gateway`

### Ist-Stand 2026-05-08
- **Typ:** Debian 13 LXC
- **IP:** `10.6.7.20`
- **LiteLLM:** `1.83.14`
- **Service:** `litellm.service` = `active`
- **Health:** `200 OK`
- **SSH-Zugang:** `openclaw@proxmox-infra` in `authorized_keys`
- **Env-Template:** `/etc/litellm/litellm.env.template`
- **API-Keys:** bewusst **nicht** gesetzt

### Aufgaben
Die VM uebernimmt folgende Aufgaben:
1. **LiteLLM-Server** auf `127.0.0.1:4000` als reiner Loopback-Dienst
2. **Multi-Backend-Routing** fuer OpenAI, Anthropic und MiniMax
3. **Per-Agent-Auth-Tokens** fuer getrennte Zugriffe je Agent/Rolle
4. **Rate-Limiting** pro Agent und pro Backend
5. **Cost-Tracking** als `Tokens × Preis`, aggregiert pro Tag / Agent / Backend, mit JSON-Reports an Dashboard `vm-302`
6. **Request-Logging nur meta-only**, also ohne Klartext-Inhalte der Prompts/Antworten
7. **Health-Endpunkte** `/health` und `/readyz` fuer Doctor-/Audit-Pruefungen
8. **nginx davor auf Port 443** mit Wildcard-Zertifikat analog zum OpenClaw-Setup
9. **Optionaler Redis-Cache** fuer wiederholte Anfragen

### Sizing
Direkt produktiv auslegen:
- **CPU:** `2-4 vCPU`
- **RAM:** `4 GB`
- **Disk:** `20 GB`

### Betriebssystem
Zulaessige Basis:
- **Debian 13**
- **Ubuntu 22.04 LTS**
- **Ubuntu 24.04 LTS**

### Sicherheitsvorgaben
- LiteLLM **bindet ausschliesslich auf Loopback**
- **TLS endet in nginx**
- API-Keys liegen spaeter in `/etc/litellm/litellm.env` auf Basis des Templates `/etc/litellm/litellm.env.template`
- Rechte auf Env-Dateien: **`chmod 600`**
- **Rate-Limiting** und **Owner-Allowlist** werden in der LiteLLM-Konfiguration erzwungen
- **Doctor-Health-Probe** erfolgt von OpenClaw aus
- **kein direktes externes Lauschen** des LiteLLM-Backends

### Installierte Modell-Slots (Idle-Basis)
- `claude-opus-4-6`
- `claude-sonnet-4-6`
- `claude-haiku-4-5`
- `gpt-4o`
- `gpt-4o-mini`
- `minimax-text-01`

### Phase C (spaeter)
In einer spaeteren Ausbauphase kann zusaetzlich eine **separate `vm-vLLM`-VM mit GPU-Passthrough** entstehen.
Dann routet `vm-110-model-gateway` teilweise:
- zu **lokalen Modellen** auf der GPU-VM
- und teilweise weiter zu **externen Providern**

## D) API-Key-Schema
Pro Backend wird **genau ein eigener API-Key** vorgesehen.

### Zu beschaffende Keys
- `OPENAI_API_KEY` — aus der OpenAI Platform
- `ANTHROPIC_API_KEY` — aus der Anthropic Console
- `MINIMAX_API_KEY` — aus der MiniMax Console

### Ablage-Doktrin
Empfohlene Ablage auf dem Zielhost:
- `/etc/litellm/litellm.env`
- Vorlage: `/etc/litellm/litellm.env.template`

Regeln:
- **kein Klartext im Repo**
- keine API-Keys in Markdown, YAML oder Git-Commits
- Rotation als Doktrin **alle 90 Tage**
- an die bestehende **Cluster-Secret-Konvention** anschliessen
- Live-Befuellung erst nach ausdruecklichem **Klaus GO Live**

### Beispiel fuer `litellm.env.template`
```bash
ANTHROPIC_API_KEY=
OPENAI_API_KEY=
MINIMAX_API_KEY=
```

## E) Setup-Skript-Vorlage
Die Basiskomponenten sind auf `vm-110` bereits im **Idle-Live-Stand** vorhanden. Das folgende Schema bleibt als reproduzierbare Referenz fuer Neuaufbau oder Re-Setup erhalten.

```bash
set -euo pipefail

apt-get update
apt-get install -y python3 python3-venv python3-pip curl nginx

mkdir -p /opt/litellm
mkdir -p /etc/litellm
python3 -m venv /opt/litellm/.venv
/opt/litellm/.venv/bin/pip install --upgrade pip
/opt/litellm/.venv/bin/pip install litellm==1.83.14
```

## F) `config.yaml`-Template-Logik
Die spaetere Aktivierungs-Konfiguration soll mindestens diese Punkte abdecken:

### `model_list`
Drei Backend-Klassen:
- OpenAI fuer `gpt-4o`, `gpt-4o-mini`
- Anthropic fuer `claude-opus-4-6`, `claude-sonnet-4-6`, `claude-haiku-4-5`
- MiniMax fuer `minimax-text-01`

### Weitere Pflichtfelder fuer die Aktivierung
Diese Felder sollen in der realen Konfiguration bewusst gesetzt werden:
- `per_model_max_tokens`
- `rate_limit_per_minute`
- `fallback_chain`
- `owner_allowlist`

Diese Werte sind **betreiberseitig zu setzen** und werden hier nicht erfunden.
Sie muessen von Klaus anhand Budget, Provider-Limits und gewuenschter Lastgrenze eingetragen werden.

## G) Aktivierungs-Schritte (erst nach Klaus GO Live)
Die folgenden Schritte sind **nur dann auszufuehren**, wenn:
- **alle 7 Fabriken fertig gebaut sind**
- und **Klaus die Live-Phase explizit startet**

1. **API-Keys eintragen**
   - `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `MINIMAX_API_KEY` in `/etc/litellm/litellm.env` befuellen
2. **Owner-/Rate-/Budget-Policy finalisieren**
   - produktive Limits und Allowlists scharf schalten
3. **nginx- und Zertifikatspfad final pruefen**
   - Wildcard-/HAProxy-Pfad gegen den Cluster-Frontend-Stand verifizieren
4. **Provider-Health und Modellpfade testen**
   - echte Backend-Checks gegen die Live-Konfiguration ausfuehren
5. **Migration starten**
   - erste Agenten kontrolliert auf den Gateway-Pfad umstellen

## H) Aktivierungs-Tests (erst in der Live-Phase)
Nach Befuellung der API-Keys sollen lokale HTTP-Tests gegen **jedes Backend** laufen.

### Testziel
- Endpoint: `http://127.0.0.1:4000/v1/chat/completions`
- Erwartung: **HTTP 200** plus **JSON-Response**

### Idle-Health-Ziele (bereits relevant)
- `/health` muss **200 OK** liefern
- `/readyz` muss **200 OK** liefern
- OpenClaw-Doctor/Audit muss die Ziel-VM sauber sehen

## I) Status
- **Status:** LIVE-IDLE
- **Stand:** 2026-05-08
- **Reife:** Basis laeuft, aber bewusst **ohne API-Keys und ohne Live-Migration**

## Verweise
- `09_Architektur/MODEL_ACCESS_ARCHITECTURE.md`
- `09_Architektur/KNOWLEDGE_CONTINUITY_LAYER.md`

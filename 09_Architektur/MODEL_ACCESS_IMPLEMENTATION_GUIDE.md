# MODEL_ACCESS_IMPLEMENTATION_GUIDE

> **Wichtiger Hinweis:** Diese Datei ist **Doku-Vorbereitung**, **keine Live-Installation jetzt**. Die Implementation erfolgt **erst nach Fertigstellung aller 7 v5-Fabriken**. Bis dahin werden **keine API-Keys beschafft**, **kein Setup ausgefuehrt**, **keine Tests gefahren** und **keine Agenten-Migration** gestartet. Der Guide ist **fertig zur Aktivierung**, aber **nicht zur sofortigen Ausfuehrung**.

**Status:** PLANUNG — fertig zur spaeteren Aktivierung  
**Stand:** 2026-05-07

## A) Zweck
Dieses Dokument ist die **Implementation-Vorbereitung** fuer das LiteLLM-Gateway aus:
- `09_Architektur/MODEL_ACCESS_ARCHITECTURE.md`

Es beschreibt die praktische Startanleitung so weit vor, dass **Klaus** die technische Umsetzung spaeter gezielt starten kann, **wenn alle 7 v5-Fabriken fertig gebaut sind und die Live-Phase explizit freigegeben wird**.

Wichtig:
- Dieses Dokument ist **keine** Rueckmeldung "bereits implementiert"
- Dieses Dokument ist **keine** Aufforderung zum sofortigen Setup
- Fehlende Zugangsdaten oder Betreiberentscheidungen werden **nicht erfunden**
- Alles, was Klaus spaeter selbst liefern oder freigeben muss, ist unten klar markiert

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

Diese Wahl schafft:
- saubere Trennung zwischen OpenClaw-Laufzeit und Model-Gateway
- cluster-weite Neutralitaet statt Fabrik-Sonderrolle
- klarere Betriebs-, Upgrade- und Fehlergrenzen
- bessere Grundlage fuer spaeteres Routing, Logging, Limits und Kostensteuerung
- Platzierung im **Service-VLAN `10.6.7.x` hinter OPNsense** statt im flacheren `192.168.1.x`-Bereich ohne vorgeschaltete Firewall

## C) VM-Spezifikation `vm-110-model-gateway`

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
- API-Keys liegen in `/root/.litellm/keys.env`
- Rechte auf `keys.env`: **`chmod 600`**
- **Rate-Limiting** und **Owner-Allowlist** werden in der LiteLLM-Konfiguration erzwungen
- **Doctor-Health-Probe** erfolgt von OpenClaw aus
- **kein direktes externes Lauschen** des LiteLLM-Backends

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
- `/root/.litellm/keys.env`

Regeln:
- **kein Klartext im Repo**
- keine API-Keys in Markdown, YAML oder Git-Commits
- Rotation als Doktrin **alle 90 Tage**
- an die bestehende **Cluster-Secret-Konvention** anschliessen

### Beispiel fuer `keys.env`
```bash
OPENAI_API_KEY=...
ANTHROPIC_API_KEY=...
MINIMAX_API_KEY=...
```

## E) Setup-Skript-Vorlage
```bash
set -euo pipefail

apt-get update
apt-get install -y python3 python3-venv python3-pip curl

mkdir -p /opt/litellm
mkdir -p /root/.litellm
python3 -m venv /opt/litellm/.venv
/opt/litellm/.venv/bin/pip install --upgrade pip
/opt/litellm/.venv/bin/pip install litellm

cat > /root/.litellm/config.yaml <<'YAML'
model_list:
  - model_name: gpt-4o
    litellm_params:
      model: openai/gpt-4o
      api_key: os.environ/OPENAI_API_KEY
  - model_name: gpt-5
    litellm_params:
      model: openai/gpt-5
      api_key: os.environ/OPENAI_API_KEY
  - model_name: o1
    litellm_params:
      model: openai/o1
      api_key: os.environ/OPENAI_API_KEY
  - model_name: claude-sonnet-4
    litellm_params:
      model: anthropic/claude-sonnet-4
      api_key: os.environ/ANTHROPIC_API_KEY
  - model_name: minimax-text
    litellm_params:
      model: minimax/text-01
      api_key: os.environ/MINIMAX_API_KEY

router_settings:
  routing_strategy: simple-shuffle

model_groups:
  reasoning:
    models:
      - gpt-5
      - gpt-4o
      - o1
    fallback_models:
      - claude-sonnet-4
  code_review:
    models:
      - claude-sonnet-4
      - gpt-5
    fallback_models:
      - gpt-4o
  bulk:
    models:
      - minimax-text
      - gpt-4o
    fallback_models:
      - claude-sonnet-4

litellm_settings:
  drop_params: true
  set_verbose: false

general_settings:
  master_key: change-me-later
YAML

cat > /etc/systemd/system/litellm.service <<'UNIT'
[Unit]
Description=LiteLLM Gateway
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/opt/litellm
EnvironmentFile=/root/.litellm/keys.env
ExecStart=/opt/litellm/.venv/bin/litellm --config /root/.litellm/config.yaml --port 4000 --host 127.0.0.1
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl enable --now litellm.service
systemctl status litellm.service --no-pager
```

## F) `config.yaml`-Template-Logik
Die spaetere Aktivierungs-Konfiguration soll mindestens diese Punkte abdecken:

### `model_list`
Drei Backend-Klassen:
- OpenAI fuer `gpt-5`, `gpt-4o`, `o1`
- Anthropic fuer `claude-sonnet-4`
- MiniMax fuer Bulk-/Kostenpfade

### `model_groups` / Routing-Policies
Beispielhafte Gruppen:
- `reasoning` -> `gpt-5`, `gpt-4o`, `o1`
- `code_review` -> `claude-sonnet-4`, dann `gpt-5`
- `bulk` -> `minimax-text`, dann `gpt-4o`

### Weitere Pflichtfelder fuer die Aktivierung
Diese Felder sollen in der realen Konfiguration bewusst gesetzt werden:
- `per_model_max_tokens`
- `rate_limit_per_minute`
- `fallback_chain`

Diese Werte sind **betreiberseitig zu setzen** und werden hier nicht erfunden.
Sie muessen von Klaus anhand Budget, Provider-Limits und gewuenschter Lastgrenze eingetragen werden.

## G) Aktivierungs-Schritte (NICHT jetzt, erst nach Fabrik-Aufbau)
Die folgenden Schritte sind **nur dann auszufuehren**, wenn:
- **alle 7 Fabriken fertig gebaut sind**
- und **Klaus die Live-Phase explizit startet**

1. **API-Keys beschaffen**
   - erst dann `OPENAI_API_KEY`, `ANTHROPIC_API_KEY` und `MINIMAX_API_KEY` real anlegen
2. **VM-Slot bestaetigen**
   - `vm-110-model-gateway` auf Node-1 final freigeben
3. **Setup-Skript ausfuehren**
   - LiteLLM, Config, Service und nginx auf der Ziel-VM einrichten
4. **Tests fahren**
   - lokale Backend- und Health-Checks gegen die reale Installation ausfuehren
5. **Migration starten**
   - erste Agenten kontrolliert auf den Gateway-Pfad umstellen

## H) Aktivierungs-Tests (erst in der Live-Phase)
Nach Start des Services sollen lokale HTTP-Tests gegen **jedes Backend** laufen.

### Testziel
- Endpoint: `http://127.0.0.1:4000/v1/chat/completions`
- Erwartung: **HTTP 200** plus **JSON-Response**

### Beispieltests
```bash
curl -s http://127.0.0.1:4000/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "gpt-4o",
    "messages": [{"role":"user","content":"Sag nur: ok"}]
  }'
```

```bash
curl -s http://127.0.0.1:4000/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "claude-sonnet-4",
    "messages": [{"role":"user","content":"Sag nur: ok"}]
  }'
```

```bash
curl -s http://127.0.0.1:4000/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "minimax-text",
    "messages": [{"role":"user","content":"Sag nur: ok"}]
  }'
```

Zusatz fuer die Live-Phase:
- `/health` muss gruen antworten
- `/readyz` muss gruen antworten
- OpenClaw-Doctor/Audit muss die Ziel-VM sauber sehen

## I) Status
- **Status:** PLANUNG
- **Stand:** 2026-05-07
- **Reife:** fertig zur Aktivierung, aber bewusst **nicht jetzt** zur Ausfuehrung bestimmt

## Verweise
- `09_Architektur/MODEL_ACCESS_ARCHITECTURE.md`
- `09_Architektur/KNOWLEDGE_CONTINUITY_LAYER.md`

# MODEL_ACCESS_IMPLEMENTATION_GUIDE

**Status:** PLANUNG — fertig zur Ausfuehrung  
**Stand:** 2026-05-07

## A) Zweck
Dieses Dokument ist die **Implementation-Vorbereitung** fuer das LiteLLM-Gateway aus:
- `09_Architektur/MODEL_ACCESS_ARCHITECTURE.md`

Es beschreibt die praktische Startanleitung so weit vor, dass **Klaus** die technische Umsetzung auf `vm-100` oder einer spaeteren `vm-308` nur noch starten muss.

Wichtig:
- Dieses Dokument ist **keine** Rueckmeldung "bereits implementiert"
- Fehlende Zugangsdaten oder Betreiberentscheidungen werden **nicht erfunden**
- Alles, was Klaus selbst liefern muss, ist unten klar markiert

## B) VM-Wahl: `vm-100` vs. neue `vm-308`

### Variante 1 — `vm-100`
**Vorteile**
- bereits vorhanden
- OpenClaw-Naehe vereinfacht Phase A
- keine neue VM-Bereitstellung noetig
- schnelle Inbetriebnahme fuer den ersten Routing-Pfad

**Nachteile**
- Gateway und OpenClaw teilen sich denselben Host
- Betriebsrollen sind weniger sauber getrennt
- spaetere Last, Logs und Policies liegen enger auf derselben Maschine

### Variante 2 — neue `vm-308`
**Vorteile**
- saubere Trennung zwischen OpenClaw-Laufzeit und Model-Gateway
- klarere Betriebs-, Upgrade- und Fehlergrenzen
- bessere Ausgangslage fuer spaetere Laststeigerung

**Nachteile**
- neue VM muss zuerst bereitgestellt werden
- mehr Initialaufwand fuer Netz, Service und Pflege
- Phase A dauert laenger bis zum ersten produktiven Test

### Empfehlung
- **Phase A:** auf `vm-100` mit LiteLLM auf **Port 4000**
- **OpenClaw bleibt** parallel auf `127.0.0.1:18789`
- **Phase B:** Migration auf `vm-308`, sobald Last, Routing-Komplexitaet oder Trennungsbedarf steigen

## C) API-Key-Schema
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

## D) Setup-Skript-Vorlage
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

## E) `config.yaml`-Template-Logik
Die Phase-A-Konfiguration soll mindestens diese Punkte abdecken:

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

### Weitere Pflichtfelder fuer Phase A
Diese Felder sollen in der realen Konfiguration bewusst gesetzt werden:
- `per_model_max_tokens`
- `rate_limit_per_minute`
- `fallback_chain`

Diese Werte sind **betreiberseitig zu setzen** und werden hier nicht erfunden.
Sie muessen von Klaus anhand Budget, Provider-Limits und gewuenschter Lastgrenze eingetragen werden.

## F) Test-Plan
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

## G) Klaus-Aktionen kompakt
1. drei API-Keys beschaffen
2. zwischen `vm-100` und `vm-308` entscheiden
3. Setup-Skript-Block ausfuehren
4. lokale Backend-Tests laufen lassen
5. erste Agenten-Migration auf den Gateway-Pfad starten

## H) Status
- **Status:** PLANUNG
- **Stand:** 2026-05-07
- **Reife:** fertig zur Ausfuehrungsvorbereitung, aber noch nicht live implementiert

## Verweise
- `09_Architektur/MODEL_ACCESS_ARCHITECTURE.md`
- `09_Architektur/KNOWLEDGE_CONTINUITY_LAYER.md`

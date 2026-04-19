# OpenClaw Steuerung - Gebrauchsanweisung

> Stand: April 2026 | OpenClaw 2026.4.11 auf VM 100 (192.168.1.20:18789) | cluster-docs

## Was ist OpenClaw?

OpenClaw ist ein **KI-Gateway** (kein Code-Editor), der Nachrichten aus WhatsApp, Telegram und WebSocket
empfaengt und an ein KI-Modell weiterleitet. Das aktuelle Modell ist **OpenAI Codex gpt-5.4**.

OpenClaw ist NICHT Claude Code. Es hat ein eigenes Plugin-System und eigene MCP-Server.

## Architektur

```
WhatsApp / Telegram / WebSocket
        |
   OpenClaw Gateway (VM 100, Port 18789)
        |
   OpenAI Codex gpt-5.4
        |
   MCP-Server (Tools)
   +--> ssh-exec      (Shell-Befehle auf VMs)
   +--> github-wiki   (Wiki-Zugriff)
   +--> proxmox-api   (Proxmox REST API)
   +--> github-repos  (Direkter GitHub API Zugriff auf alle v5-Repos)
```

## MCP-Server

Alle MCP-Server sind Python-Skripte in `/root/mcp-servers/` auf VM 100.
Sie kommunizieren ueber JSON-RPC auf stdin/stdout (MCP-Protokoll).

### github-repos MCP-Server (NEU)

Gibt OpenClaw direkten Lese-/Schreibzugriff auf alle 7 v5-Repos via GitHub API.

**Verfuegbare Tools:**

| Tool | Parameter | Beschreibung |
|------|-----------|--------------|
| `repo_read_file` | repo, path | Datei aus GitHub lesen |
| `repo_write_file` | repo, path, content, message | Datei in GitHub schreiben/updaten |
| `repo_list_dir` | repo, path | Verzeichnis auflisten |
| `repo_get_readme` | repo | README lesen |
| `repo_wave_status` | repo | Wave-Status aller Repos |

**Repos:**
- project-reloaded-cluster-v5
- Cluster-Control-v5
- Trading-Fabrik-v5
- Social-Media-Fabrik-v5
- Marketing-Fabrik-v5
- Ebook-Fabrik-v5
- RefactorCo-Fabrik-v5
- cluster-docs

## Wave-System (0-7)

Alle Repos befinden sich aktuell in **Wave 3.x**.

| Gate | Status | Bedingung |
|------|--------|-----------|
| delta_wave_ready | [FAIL] | Fehlende INSTALL_SEQUENCE.md und VM_SPEC.md in allen Fabriken |
| cross_repo_ready | [FAIL] | Fehlende CLUSTER_DEPS.md in allen Fabriken |
| CLUSTER_INTEGRATION_READY | [BLOCKED] | Wartet auf delta_wave_ready |

## Naechste Schritte (Prioritaet)

1. **RefactorCo**: Wave 2 abschliessen (VM_ROLLEN.md + Governance-Docs)
2. **Alle Fabriken**: INSTALL_SEQUENCE.md erstellen
3. **Alle Fabriken**: VM-Spec-Datei erstellen (docs/VM_SPEC.md)
4. **project-reloaded-cluster-v5**: CLUSTER_INTEGRATION_READY Gate dokumentieren
5. **cross_repo_ready**: Jede Fabrik bekommt CLUSTER_DEPS.md

## Workflow: Repo auf Wave 4 bringen

```
1. delta_wave_ready pruefen:
   - INSTALL_SEQUENCE.md vorhanden?
   - VM_SPEC.md in docs/ vorhanden?
   - Alle bisherigen Wave-Gates bestanden?

2. cross_repo_ready pruefen:
   - CLUSTER_DEPS.md vorhanden?
   - Abhaengigkeiten zu anderen Fabriken dokumentiert?

3. Nach Wave 4:
   - Cluster-Integration testen
   - CLUSTER_INTEGRATION_READY Gate in project-reloaded-cluster-v5 setzen
```

## Konfiguration

- Config: `~/.openclaw/openclaw.json`
- Credentials: `~/.openclaw/credentials.env`
- System-Prompt: `~/.openclaw/system_prompt.md`
- MCP-Server: `/root/mcp-servers/`
- Logs: `/var/log/openclaw/`
- Health-Check: `curl http://192.168.1.20:18789/health`

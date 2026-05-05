# OpenClaw Betriebshandbuch — Projekt Reloaded

**Version:** 1.0 | **Datum:** April 2026 | **Autor:** Klaus Seemann  
**OpenClaw Version:** 2026.4.11 | **Proxmox VE:** 9.1.7  
**Status:** Aktiv in Betrieb

---

## Inhaltsverzeichnis

1. [Systemübersicht](#1-systemübersicht)
2. [Infrastruktur & Hardware](#2-infrastruktur--hardware)
3. [OpenClaw Plattform](#3-openclaw-plattform)
4. [Skills & Agents](#4-skills--agents)
5. [Gateway & Dienste](#5-gateway--dienste)
6. [Betriebsabläufe (Runbooks)](#6-betriebsabläufe-runbooks)
7. [Monitoring & Wartung](#7-monitoring--wartung)
8. [Sicherheit & Backup](#8-sicherheit--backup)
9. [Troubleshooting](#9-troubleshooting)
10. [Anhang & Referenz](#10-anhang--referenz)

---

## 1. Systemübersicht

Projekt Reloaded ist eine privat betriebene Homelab-Infrastruktur mit Proxmox VE als Hypervisor-Plattform und OpenClaw als KI-gesteuertem Cluster-Management-System.

### Architekturüberblick

```
Internet
    |
    v
[OPNsense Firewall Cluster]
  192.168.1.101 (Master) / 192.168.1.104 (Slave)
    |
    v
[Proxmox Cluster]
  node-1-Network-Master  192.168.1.15
  node-2-prx-master      192.168.1.16
    |
    +-- VM 100 (openclaw)      192.168.1.20  — KI-Steuerung
    +-- VM 102 (OPNsense-M)    192.168.1.101
    +-- VM 104 (OPNsense-S)    192.168.1.104
    +-- VM 106 (pi-hole-a)     DHCP-vergeben
    +-- VM 107 (pihole-b)      DHCP-vergeben
    +-- VM 300-305 (VLAN-Test) Testnetz
```

### Schlüsselkomponenten

| Komponente | Beschreibung | Version |
|---|---|---|
| Proxmox VE | Hypervisor-Plattform | 9.1.7 |
| OpenClaw | KI-Cluster-Management | 2026.4.11 |
| OPNsense | Firewall / Router | aktuell |
| Pi-hole | DNS / Ad-Blocking | aktuell |
| Ubuntu 24.04 | Basis-OS für OpenClaw VM | LTS |

---

## 2. Infrastruktur & Hardware

### Netzwerk-Segmente

| VLAN | Netz | Zweck |
|---|---|---|
| VLAN 1 (Default) | 192.168.1.0/24 | Management / Infrastruktur |
| VLAN 11 | Test-Netz 11 | VM 301 Tests |
| VLAN 12 | Test-Netz 12 | VM 302 Tests |
| VLAN 13 | Test-Netz 13 | VM 303 Tests |
| VLAN 15 | Test-Netz 15 | VM 305 Tests |
| VLAN 17 | Test-Netz 17 | VM 300 Tests |

### Proxmox-Zugang

| Parameter | Wert |
|---|---|
| URL | https://192.168.1.15:8006 |
| Benutzer | root |
| Auth | PAM |
| API-Port | 8006 |

---

## 3. OpenClaw Plattform

OpenClaw ist ein KI-gesteuertes Cluster-Management-System, das auf VM 100 läuft und über Skills, Agents und Plugins erweitert werden kann.

### Installation & Konfiguration

**Installationspfad:** `/usr/local/bin/openclaw`  
**Konfiguration:** `~/.openclaw/config`  
**Workspace:** `~/.openclaw/workspace/`

### Konfigurationsdatei (`~/.openclaw/config`)

```yaml
gateway:
  port: 18789
  host: 0.0.0.0
  protocol: websocket

proxmox:
  host: 192.168.1.15
  port: 8006
  user: root@pam
  verify_ssl: false

logging:
  level: info
  path: /var/log/openclaw/

workspace: ~/.openclaw/workspace/
```

### Basis-Befehle

```bash
# Version prüfen
openclaw --version

# Status anzeigen
openclaw status

# Skills auflisten
openclaw skills list

# Agents auflisten
openclaw agents list

# Plugins auflisten
openclaw plugins list

# Integrations auflisten
openclaw integrations list

# Gateway neu starten
systemctl restart openclaw-gateway
```

---

## 4. Skills & Agents

Skills sind SKILL.md-basierte Module, die OpenClaw mit spezifischen Fähigkeiten erweitern.

### Installierte Skills

| Name | Beschreibung | Pfad |
|---|---|---|
| cluster-smoke | Cluster Health-Check Automatisierung | `~/.openclaw/workspace/skills/cluster-smoke/` |
| doc-scribe | Professionelle Dokumenten-Erstellung | `~/.openclaw/workspace/skills/doc-scribe/` |
| proxmox-control | Proxmox VM/CT Management via API | `~/.openclaw/workspace/skills/proxmox-control/` |

### Skill-Verwaltung

```bash
# Skills auflisten
openclaw skills list

# Skill installieren
openclaw skills install <skill-name>

# Skill deinstallieren
openclaw skills uninstall <skill-name>

# Skill-Details anzeigen
openclaw skills info <skill-name>
```

### Skill-Verzeichnis-Struktur

```
~/.openclaw/workspace/skills/
├── cluster-smoke/
│   ├── SKILL.md          # Skill-Definition & Prompts
│   └── scripts/          # Hilfsskripte
├── doc-scribe/
│   ├── SKILL.md
│   └── templates/
└── proxmox-control/
    ├── SKILL.md
    └── api/
```

### Installierte Agents

```bash
# Agent-Liste abrufen
openclaw agents list
```

Agents laufen als eigenständige Prozesse und koordinieren mehrere Skills für komplexe Aufgaben.

---

## 5. Gateway & Dienste

### OpenClaw Gateway

Der OpenClaw Gateway ist ein WebSocket-Dienst für die Echtzeit-Kommunikation zwischen OpenClaw-Komponenten.

| Parameter | Wert |
|---|---|
| Protokoll | WebSocket |
| Host | 0.0.0.0 (alle Interfaces) |
| Port | 18789 |
| Systemd Unit | `openclaw-gateway.service` |

### Dienstverwaltung

```bash
# Gateway-Status prüfen
systemctl status openclaw-gateway

# Gateway starten
systemctl start openclaw-gateway

# Gateway stoppen
systemctl stop openclaw-gateway

# Gateway neu starten
systemctl restart openclaw-gateway

# Gateway-Logs anzeigen
journalctl -u openclaw-gateway -f

# Gateway beim Boot aktivieren
systemctl enable openclaw-gateway
```

### Verbindungstest

```bash
# WebSocket-Verbindung testen
curl -i -N -H "Connection: Upgrade" \
  -H "Upgrade: websocket" \
  -H "Sec-WebSocket-Version: 13" \
  -H "Sec-WebSocket-Key: test" \
  http://192.168.1.20:18789/

# Port-Erreichbarkeit prüfen
nc -zv 192.168.1.20 18789
```

---

## 6. Betriebsabläufe (Runbooks)

### Runbook 1: Täglicher Health-Check

```bash
# 1. System-Status
systemctl status openclaw-gateway
openclaw status

# 2. Proxmox-Cluster prüfen
pvecm status

# 3. VM-Status (alle VMs)
qm list

# 4. Ressourcen-Auslastung
htop
df -h
free -h

# 5. Log-Rotation prüfen
journalctl --disk-usage
```

### Runbook 2: VM starten/stoppen øber OpenClaw

```bash
# VM via OpenClaw starten
openclaw proxmox vm start --vmid 100

# VM via OpenClaw stoppen
openclaw proxmox vm stop --vmid 100

# VM-Status abfragen
openclaw proxmox vm status --vmid 100
```

### Runbook 3: Neuen Skill installieren

```bash
# 1. Skill-Quelle vorbereiten
mkdir -p ~/.openclaw/workspace/skills/mein-skill/

# 2. SKILL.md erstellen (mindestens: name, description, trigger)
cat > ~/.openclaw/workspace/skills/mein-skill/SKILL.md << 'EOF'
# Mein Skill
**Trigger:** mein-skill
**Beschreibung:** Beschreibung des Skills
## Anweisungen
...
EOF

# 3. Skill registrieren
openclaw skills install mein-skill

# 4. Verifizieren
openclaw skills list | grep mein-skill
```

### Runbook 4: OpenClaw aktualisieren

```bash
# 1. Aktuelle Version prüfen
openclaw --version

# 2. Update durchführen (je nach Installationsmethode)
openclaw update
# oder:
pip install --upgrade openclaw --break-system-packages

# 3. Dienst neu starten
systemctl restart openclaw-gateway

# 4. Version bestätigen
openclaw --version
```

### Runbook 5: Cluster Smoke-Test

```bash
# Vollständigen Cluster-Smoke-Test ausführen
openclaw run cluster-smoke

# Ergebnis-Report anzeigen
openclaw report last
```

---

## 7. Monitoring & Wartung

### Wichtige Log-Dateien

| Datei | Beschreibung |
|---|---|
| `/var/log/openclaw/gateway.log` | Gateway-Logs |
| `/var/log/openclaw/agents.log` | Agent-Aktivitäten |
| `/var/log/openclaw/skills.log` | Skill-Ausføhrungen |
| `journalctl -u openclaw-gateway` | Systemd Journal |

### Monitoring-Befehle

```bash
# Echtzeit-Logs verfolgen
journalctl -u openclaw-gateway -f --no-pager

# Fehler der letzten 24h
journalctl -u openclaw-gateway --since "24 hours ago" -p err

# Ressourcen-Nutzung von OpenClaw-Prozessen
ps aux | grep openclaw
top -p $(pgrep -d',' -f openclaw)

# Disk-Nutzung im Workspace
du -sh ~/.openclaw/workspace/
```

### Wartungsintervalle

| Aufgabe | Intervall | Verantwortlich |
|---|---|---|
| Health-Check | Täglich | OpenClaw (cluster-smoke) |
| Log-Rotation prüfen | Wöchentlich | Manuell |
| Skill-Updates | Monatlich | Klaus |
| Vollbackup | Wöchentlich | Proxmox Backup |
| OpenClaw-Update | Nach Bedarf | Klaus |
| Firewall-Rules-Review | Monatlich | Klaus |

### GitHub-gepflegte Zusatztools

| Tool | Status | Quelle | Primaerer Einsatzort | Kanonischer Verweis | Update-Check |
|---|---|---|---|---|---|
| RepoLens | trial | `TheMorpheus407/RepoLens` | `vm-303` in `RefactorCo-Fabrik-v5`, optional `vm-305` fuer Smoke-Audits | `RefactorCo-Fabrik-v5/docs/operators/REPOLENS_INTEGRATION.md` | Pflicht, woechentlich |

**Hinweis:** RepoLens ist als externes Review- und Audit-Werkzeug eingeplant. Es ersetzt keine repo-first-Wahrheitspruefung und keine manuelle Freigabe fuer groessere Architekturentscheidungen.

---

## 8. Sicherheit & Backup

### Sicherheitsrichtlinien

- **SSH-Zugang:** Nur øber Proxmox Node Shell oder direkten SSH-Zugriff im LAN
- **API-Token:** GitHub PAT in `~/.git-credentials` gespeichert (nicht in Skripten hardcoden)
- **Passwörter:** In `/etc/pve/` (Proxmox-intern) und `~/.openclaw/config` (verschlüsselt)
- **Firewall:** OPNsense-Cluster schützt alle Zugriffe von außen

### Backup-Strategie

| Was | Wo | Intervall |
|---|---|---|
| VM-Snapshots | Proxmox lokaler Storage | Täglich |
| OpenClaw-Config | `~/.openclaw/` | Bei Änderungen (Git) |
| Cluster-Docs | GitHub (dieses Repo) | Bei Änderungen |
| Proxmox-Config | `/etc/pve/` | Wöchentlich |

### Backup-Befehle

```bash
# OpenClaw-Konfiguration sichern
tar -czf ~/openclaw-config-backup-$(date +%Y%m%d).tar.gz ~/.openclaw/config ~/.openclaw/workspace/

# Proxmox-VM-Snapshot erstellen
qm snapshot 100 snap-$(date +%Y%m%d) --description "Manueller Snapshot"

# Snapshots auflisten
qm listsnapshot 100
```

---

## 9. Troubleshooting

### Problem: Gateway startet nicht

```bash
# 1. Fehler-Logs prüfen
journalctl -u openclaw-gateway -n 50 --no-pager

# 2. Port-Konflikt prüfen
ss -tlnp | grep 18789

# 3. Config-Syntax prüfen
openclaw config validate

# 4. Manuell starten (Debug-Modus)
openclaw gateway --debug

# 5. Dienst neu starten
systemctl restart openclaw-gateway
```

### Problem: Skill wird nicht ausgeführt

```bash
# 1. Skill-Liste prüfen
openclaw skills list

# 2. SKILL.md auf Syntax-Fehler prüfen
cat ~/.openclaw/workspace/skills/<skillname>/SKILL.md

# 3. Skill neu registrieren
openclaw skills uninstall <skillname>
openclaw skills install <skillname>

# 4. Logs auf Fehler prüfen
journalctl -u openclaw-gateway -f
```

### Problem: Proxmox-Verbindung fehlgeschlagen

```bash
# 1. Proxmox-Erreichbarkeit prüfen
ping 192.168.1.15
curl -k https://192.168.1.15:8006/api2/json/version

# 2. OpenClaw-Config prüfen
cat ~/.openclaw/config | grep proxmox

# 3. Credentials testen
pvesh get /version --hostname 192.168.1.15 --username root@pam

# 4. Firewall-Regeln prüfen (OPNsense)
# GUI: https://192.168.1.101 -> Firewall -> Rules
```

### Problem: VM antwortet nicht auf Konsole

```bash
# Alternative 1: Proxmox Node Shell (øber Proxmox-GUI)
# Node -> Shell -> SSH zur VM

# Alternative 2: SSH direkt
ssh root@192.168.1.20

# Alternative 3: Proxmox API
pvesh post /nodes/node-1-Network-Master/qemu/100/agent/exec \
  --command '["ls", "/"]'
```

### Häufige Fehlercodes

| Code | Bedeutung | Lösung |
|---|---|---|
| `GATEWAY_CONN_REFUSED` | Gateway nicht erreichbar | `systemctl restart openclaw-gateway` |
| `SKILL_NOT_FOUND` | Skill nicht registriert | `openclaw skills install <name>` |
| `PROXMOX_AUTH_FAIL` | API-Auth fehlgeschlagen | Config prüfen, Passwort reset |
| `SKILL_EXEC_TIMEOUT` | Skill-Timeout | Timeout in SKILL.md erhöhen |

---

## 10. Anhang & Referenz

### Vollständige Befehlsreferenz

```bash
# ─── OpenClaw Core ───────────────────────────────────────
openclaw --version              # Version anzeigen
openclaw status                 # System-Status
openclaw config validate        # Config-Syntax prüfen
openclaw config show            # Aktuelle Config anzeigen
openclaw update                 # OpenClaw aktualisieren

# ─── Skills ──────────────────────────────────────────────
openclaw skills list            # Alle Skills anzeigen
openclaw skills install <name>  # Skill installieren
openclaw skills uninstall <name># Skill entfernen
openclaw skills info <name>     # Skill-Details
openclaw skills update <name>   # Skill aktualisieren
openclaw run <skill-name>       # Skill ausführen

# ─── Agents ──────────────────────────────────────────────
openclaw agents list            # Alle Agents anzeigen
openclaw agents start <name>    # Agent starten
openclaw agents stop <name>     # Agent stoppen
openclaw agents status <name>   # Agent-Status

# ─── Plugins ─────────────────────────────────────────────
openclaw plugins list           # Alle Plugins anzeigen
openclaw plugins install <name> # Plugin installieren
openclaw plugins remove <name>  # Plugin entfernen

# ─── Proxmox-Integration ─────────────────────────────────
openclaw proxmox vm list        # VMs auflisten
openclaw proxmox vm start --vmid <id>   # VM starten
openclaw proxmox vm stop --vmid <id>    # VM stoppen
openclaw proxmox vm status --vmid <id>  # VM-Status
openclaw proxmox node list      # Nodes auflisten
openclaw proxmox cluster status # Cluster-Status

# ─── Gateway                                              
openclaw gateway status         # Gateway-Status
openclaw gateway start          # Gateway starten
openclaw gateway stop           # Gateway stoppen
openclaw gateway --debug        # Debug-Modus

# ─── Integrations ────────────────────────────────────────
openclaw integrations list      # Integrationen anzeigen
openclaw integrations add <name>    # Integration hinzufügen
openclaw integrations remove <name> # Integration entfernen
```

### Netzwerk-Adressen Schnellreferenz

| Host | IP | Dienst |
|---|---|---|
| node-1-Network-Master | 192.168.1.15 | Proxmox Node 1 (Port 8006) |
| node-2-prx-master | 192.168.1.16 | Proxmox Node 2 (Port 8006) |
| openclaw (VM 100) | 192.168.1.20 | OpenClaw Gateway (Port 18789) |
| OPNsense-Master (VM 102) | 192.168.1.101 | Firewall GUI (Port 443) |
| OPNsense-Slave (VM 104) | 192.168.1.104 | Firewall Slave |
| pi-hole-a (VM 106) | DHCP | DNS / Ad-Blocking |
| pi-hole-b (VM 107) | DHCP | DNS / Ad-Blocking Backup |

### Wichtige Dateipfade

| Pfad | Beschreibung |
|---|---|
| `/usr/local/bin/openclaw` | OpenClaw-Hauptprogramm |
| `~/.openclaw/config` | Hauptkonfiguration |
| `~/.openclaw/workspace/` | Workspace-Root |
| `~/.openclaw/workspace/skills/` | Installierte Skills |
| `~/.openclaw/workspace/agents/` | Agent-Definitionen |
| `/var/log/openclaw/` | Log-Verzeichnis |
| `/etc/systemd/system/openclaw-gateway.service` | Systemd-Unit |
| `~/.git-credentials` | Git-Zugangsdaten (PAT) |

### Verwandte Dokumentation in diesem Repo

| Dokument | Beschreibung |
|---|---|
| `11_OpenClaw-Steuerung/00_GEBRAUCHSANWEISUNG.md` | OpenClaw Gebrauchsanweisung |
| `11_OpenClaw-Steuerung/01_BEFEHLSLISTE-CLUSTER-ABSCHLUSS.md` | Cluster-Abschluss Befehle |
| `11_OpenClaw-Steuerung/OPENCLAW_BEFEHLSKATALOG.md` | Vollständiger Befehlskatalog |
| `11_OpenClaw-Steuerung/OPENCLAW_KOMMANDOS.md` | Kommando-Übersicht |
| `08_Betrieb/01_Runbooks.md` | Betriebsrunbooks |
| `06_Services/01_OpenClaw-AI-Gateway.md` | Gateway-Dokumentation |

---

*Letzte Aktualisierung: April 2026 | Erstellt mit OpenClaw doc-scribe Skill*
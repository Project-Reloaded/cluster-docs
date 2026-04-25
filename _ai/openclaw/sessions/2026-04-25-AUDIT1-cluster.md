# AUDIT1 — Cluster-Gesamtaudit

**Datum:** 2026-04-25 09:36 UTC
**Durchgefuehrt von:** OpenClaw + Cowork (parallel)
**Methode:** NW1 + VM1 + SYS1 nach `OPENCLAW_BEFEHLSKATALOG.md`

---

## Zusammenfassung

```
=== CLUSTER AUDIT REPORT 2026-04-25 ===
NETZWERK:  GELB    — 4/6 Geraete erreichbar (Pi-holes down)
VMs:       UNBEKANNT — Proxmox-API-Token fehlt
SERVICES:  GRUEN   — 0 failed auf VM 100, andere VMs nicht erreichbar
GESAMT:    GELB
========================================
```

**Top-Befunde fuer naechste Session:**
1. **Proxmox-API-Token fehlt** in `/root/.openclaw/credentials.env` (PVE_USER/PVE_TOKEN_ID/PVE_TOKEN_SECRET = None). Konsequenz: Alle `pve_*`-Tools im OpenClaw-MCP funktionieren nicht. **Top-Prio fuer Beheben.**
2. **Pi-hole-Subnetz (10.6.7.x) ist isoliert** von VM 100. Vermutlich VLAN-/Routing-Problem oder die Pi-holes laufen schlicht (noch) nicht. Fuer DNS-Redundanz im Cluster relevant.
3. **VM 100 selbst kerngesund** — keine harten Probleme, viel Reserve auf Disk + RAM.

---

## NW1 — Netzwerk-Geraete

| Geraet | IP | PING | HTTP | Status |
|--------|----|----|------|--------|
| UniFi Cloud Gateway Ultra | 192.168.1.1 | ✓ | 200 | **GRUEN** |
| OPNsense Master | 192.168.1.49 | ✓ | 200 | **GRUEN** |
| OPNsense Slave/HA | 192.168.1.50 | ✓ | 200 | **GRUEN** |
| TP-Link Switch SG3428X | 192.168.1.74 | ✓ | 200 | **GRUEN** |
| Pi-hole 1 | 10.6.7.16 | ✗ | timeout | **ROT** |
| Pi-hole 2 | 10.6.7.17 | ✗ | timeout | **ROT** |

**Score:** 4/6 (66 %) — **GELB**

**Hypothese fuer 10.6.7.x:**
- Klaus' PC haengt im 10.6.1.x VLAN (laut frueherer Diagnose), Pi-holes sollten in 10.6.7.x laufen — also separates VLAN
- VM 100 (192.168.1.20) hat keine Route ins 10.6.7.x Netz oder die Pi-holes existieren noch nicht als VMs
- **To-do:** OPNsense-Routing pruefen + Proxmox-VM-Liste durchgehen, ob vm-106-pihole-a / vm-107-pihole-b ueberhaupt laufen (geht erst wenn PVE-Token da ist)

---

## VM1 — Proxmox VM/Node-Health

**Status:** ⚠ **BLOCKIERT** — Proxmox-API-Token fehlt

`/root/.openclaw/credentials.env` enthaelt nur folgende Variablen:
- `GITHUB_TOKEN` ✓
- `OPNSENSE_*` ✓
- `PIHOLE_*` ✓
- `TPLINK_*` ✓
- `UNIFI_*` ✓

**Fehlt:**
- `PVE_USER`
- `PVE_TOKEN_ID`
- `PVE_TOKEN_SECRET`

`/root/mcp-servers/proxmox_api.py` hat zwar Defaults fuer `PVE_HOST=https://192.168.1.15:8006` und `PVE_NODE=node-1-Network-Master` eingebaut, aber alle Auth-Variablen sind `None`.

**API-Probe:** `curl -k https://192.168.1.15:8006/api2/json/cluster/status` ohne Token → leere/nicht-JSON-Antwort.

**Konsequenz:**
- `pve_list_vms()`, `pve_vm_status()`, `pve_vm_start()`, `pve_node_status()` — alle nicht funktional
- OpenClaw kann den eigenen Cluster nicht autonom inspizieren oder VMs starten

**Behebungs-Pfad** (Prio 1):
1. Auf Proxmox 192.168.1.15 einen API-Token erstellen: Datacenter → Permissions → API Tokens → Add
2. User: ein dedizierter Service-User (nicht root@pam direkt), z.B. `openclaw@pve`
3. Token-Privileges auf Datacenter-Level: PVEVMAdmin (oder restriktiver)
4. Drei Variablen in `/root/.openclaw/credentials.env` ergaenzen:
   ```
   PVE_USER=openclaw@pve
   PVE_TOKEN_ID=openclaw-token
   PVE_TOKEN_SECRET=<UUID>
   ```
5. OpenClaw-Service hot-reloaden, AUDIT1 wiederholen.

---

## SYS1 — Service-Status

### VM 100 (openclaw, local)
- **Hostname:** openclaw
- **Uptime:** 1 day, 14:18
- **Failed services:** 0
- **Disk /:** 4.6 GB von 99 GB belegt (5 %)
- **RAM:** 966 MB von 3922 MB belegt (25 %), 2.9 GB frei, kein Swap-Druck
- **Bewertung:** **GRUEN**

### vm-106-pi-hole-a (10.6.7.16)
- SSH connect timed out (siehe NW1)
- **Bewertung:** **ROT** (Erreichbarkeit, nicht Service)

### vm-107-pihole-b (10.6.7.17)
- SSH connect timed out (siehe NW1)
- **Bewertung:** **ROT** (Erreichbarkeit, nicht Service)

### Andere VMs
- Nicht in Audit-Scope (PVE-API blockiert) — koennen erst nach Token-Fix vollstaendig erfasst werden.

---

## Konkrete naechste Schritte (priorisiert)

**P1 — Diese Woche (blockiert OpenClaw-Autonomie):**
1. Proxmox-API-Token einrichten + in `credentials.env` eintragen
2. AUDIT1 wiederholen mit funktionalem PVE-API
3. Pi-hole-Routing/VLAN-Diagnose: Sind die VMs angelegt? Wenn ja, Routing auf OPNsense pruefen

**P2 — Cluster-Aufbau (laut Reihenfolge in CURRENT_STATE.md):**
1. **RefactorCo-Fabrik-v5** auf 80 % gruen bringen (Bremsklotz, blockt cluster-weite Gates)
2. Cluster-Control-v5 analog wie cluster-v5 mit `_ai/openclaw/` Bootstrap-Struktur
3. Trading-Fabrik-v5 Welle 3.2 fortsetzen (Legacy-Quellen v1-v4 ins Repo bringen)
4. Social-Media + Marketing parallel weiterfuehren (beide Welle 3.1)

**P3 — Nice-to-haves:**
- Bot-Token rotieren (alter Token war kurz im Chat)
- Bot-Profilbild via @BotFather setzen
- Healthcheck-Skill konfigurieren (`/usr/lib/node_modules/openclaw/skills/healthcheck/`)

---

## Diagnose-Referenz fuer naechste AUDIT1

**Wenn Pi-holes weiter rot bleiben:**
```bash
# Auf VM 100:
ip route show
traceroute 10.6.7.16
# Wenn keine Route: OPNsense-Webui pruefen welcher Interface Pi-hole-Subnetz bedient
```

**Wenn Proxmox-Token gesetzt aber Calls 403:**
```bash
# Prueft Token-Permissions:
curl -k -H "Authorization: PVEAPIToken=$PVE_USER!$PVE_TOKEN_ID=$PVE_TOKEN_SECRET" \
  https://192.168.1.15:8006/api2/json/access/permissions
```

---

*AUDIT1_DONE — Stand 2026-04-25 09:36 UTC*
*Naechster Audit empfohlen: nach PVE-Token-Fix oder taeglich per Cron*

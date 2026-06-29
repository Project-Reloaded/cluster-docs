---
title: OPNsense / Netzwerk-Kern — Bestandsaufnahme & Disaster-Recovery
stand: 2026-06-29
quelle: Live aus /conf/config.xml Master (.49) + Slave (.50), pfctl, HAProxy-Config, Pi-hole/TOR-Container
zweck: Nachbau-taugliche Doku. Bei Ausfall einer OPNsense (oder beider) hiermit rekonstruierbar.
---

# OPNsense / Netzwerk-Kern — Bestandsaufnahme & DR

> **Diese Datei ist die Quelle der Wahrheit für den Netzwerk-Kern.** Sie beschreibt beide OPNsense-Firewalls,
> das komplette Regelwerk, HAProxy, SSL, Pi-hole und TOR — und wie man alles nach einem Ausfall wieder aufbaut.
> Gepflegt von Hand (nicht vom Wiki-Auto-Scanner, der OPNsense-Interna nicht lesen kann).

---

## 0 — Kritische DR-Hinweise zuerst (⚠️)

1. **Beide OPNsense-VMs laufen auf node-1** (Master = VMID **103**, Slave = VMID **104**, beide auf 192.168.1.15).
   → **HA schützt gegen VM-/OPNsense-Ausfall, NICHT gegen node-1-Hardware-Ausfall.** Stirbt node-1, ist das
   gesamte Cluster-Netz weg. Empfehlung: Slave (104) auf node-2 migrieren, sobald möglich.
2. **Wildcard-Zertifikat `*.project-reloaded.org` läuft am 2026-08-10 ab.** Das os-acme-client-Plugin ist aktuell
   **disabled/leer** (`settings/enabled=0`, keine accounts/certificates/validations) → **Auto-Renewal ist nicht
   armiert.** Vor dem 2026-08-10 Renewal verifizieren/neu einrichten, sonst brechen ALLE Klarnamen-HTTPS-Dienste.
3. **Master↔Slave Config-Sync ist EINSEITIG** (Master→Slave via XMLRPC). Änderungen immer am **Master** machen,
   dann `rc.filter_synchronize`. Der Slave pusht nie zurück (synctoip leer).
4. **Recovery-Zugang** wenn Home-LAN→Master-SSH gekappt: über den Slave auf Mgmt-VLAN (10.6.5.3 → Master 10.6.5.2),
   siehe §11.3.

---

## 1 — Topologie & Interfaces

### Knoten
| Rolle | VMID | Host | WAN-IP | Hostname | CARP |
|---|---|---|---|---|---|
| Master | 103 | node-1 (192.168.1.15) | 192.168.1.49 | OPNsense-Master | advskew 0 (MASTER) |
| Slave | 104 | node-1 (192.168.1.15) | 192.168.1.50 | OPNsense-Slave | advskew 100 (BACKUP) |

PVE-Gast-Agent ist auf den OPNsense-VMs **nicht** installiert (`qm guest exec` geht nicht).

### Interface-Zuordnung (identisch auf beiden, nur IP unterscheidet sich)
| IF | Name | VLAN | Device | Master-IP | Slave-IP | CARP-VIP (Gateway) | vhid |
|---|---|---|---|---|---|---|---|
| wan | WAN (Heim-LAN-Uplink) | untagged | vtnet0 | 192.168.1.49 | 192.168.1.50 | 192.168.1.48 | 16 |
| opt1 | Nodes_MGMT | 15 | vtnet1_vlan15 | 10.6.5.2 | 10.6.5.3 | 10.6.5.1 | 15 |
| opt2 | USER | 11 | vtnet2_vlan11 | 10.6.1.2 | 10.6.1.3 | 10.6.1.1 | 11 |
| opt3 | IOT_WLAN | 12 | vtnet2_vlan12 | 10.6.2.2 | 10.6.2.3 | 10.6.2.1 | 12 |
| opt4 | GUEST_WLAN | 13 | vtnet2_vlan13 | 10.6.3.2 | 10.6.3.3 | 10.6.3.1 | 13 |
| opt5 | TOR | 14 | vtnet2_vlan14 | 10.6.4.2 | 10.6.4.3 | 10.6.4.1 | 14 |
| opt6 | VMs_DMZ | 17 | vtnet1_vlan17 | 10.6.7.2 | 10.6.7.3 | 10.6.7.1 | 17 |

**Zusätzliche CARP-VIP:** `10.6.7.5` (vhid **5**, opt6) = dediziertes VIP für **Traefik-Frontend** (fe-traefik).

**Physik:** `vtnet0` = WAN (untagged, Heim-LAN). `vtnet1` trägt VLAN 15 + 17 (Mgmt + DMZ). `vtnet2` trägt VLAN
11/12/13/14 (USER/IOT/GUEST/TOR). Default-Gateway = **192.168.1.1** (FritzBox/UniFi) via vtnet0.

### CARP / HA
- 8 CARP-VIPs (s.o.), Master advskew 0, Slave advskew 100 → Master ist aktiv für alle.
- **pfsync** (State-Sync): Interface **opt1** (Mgmt-VLAN), Peer 10.6.5.3, Version 1400.
- **Config-Sync** (XMLRPC): `synchronizetoip = 10.6.5.3` (nur am Master gesetzt), User `root`, Sync-Items =
  **aliases, rules, nat, staticroutes, virtualip**. `disablepreempt = 0` (Master übernimmt nach Recovery wieder).
- ⚠️ **HAProxy-Config + Zertifikate sind NICHT in den syncitems** → die müssen separat auf beiden Knoten gepflegt
  werden (bzw. via HAProxy-eigenem Sync / manuell). Bei Slave-Neuaufbau HAProxy + Cert dort eigens einspielen.

---

## 2 — NAT

**Outbound-Modus: `hybrid`** (manuelle Regeln + Auto-Regeln). Reihenfolge wichtig (No-NAT vor Auto-NAT):

| # | IF | Quelle | Ziel | Zweck |
|---|---|---|---|---|
| 1 | wan | 10.6.7.0/24 | 192.168.1.0/24 | **No-NAT** DMZ→Heim-LAN (Hairpin-Fix) |
| 2 | wan | 10.6.1.0/24 | 192.168.1.0/24 | **No-NAT** USER→Heim-LAN (Linux-PC-Erreichbarkeit) |
| 3-8 | wan | 10.6.1/2/3/4/5/7.0/24 | (any) | Auto-NAT je VLAN → Internet (SNAT auf WAN-IP) |

**Port-Forward (rdr):** `wan udp 51820 → 10.6.7.44:51820` (WireGuard, vm-240).

> Egress-Lehre (2026-06-28): Fehlt das SNAT, ist Internet trotz korrektem Routing tot. Target „Interface-Adresse"
> muss als **leeres** target gesetzt sein. Apply: `configctl configd restart` DANN `configctl filter reload`.

---

## 3 — Aliases
| Name | Typ | Inhalt | Zweck |
|---|---|---|---|
| `PiholeDNS` | host | 10.6.7.16, 10.6.7.17 | Pi-hole-DNS-Ziele (DNS-Ausnahme bei VLAN-Isolation) |
| `OPENCLAW_PIHOLE_DNS_SERVERS` | host | 10.6.7.16, 10.6.7.17 | dito (Automation-Regel) |
| `RFC1918` | network | 10/8, 172.16/12, 192.168/16 | private Netze (Inter-VLAN-Deny via „→ !RFC1918") |
| `OPENCLAW_OPNSENSE_ADMIN_PORTS` | port | 22, 80, 443 | Anti-lockout Mgmt→OPNsense |

---

## 4 — Firewall-Regelwerk (vollständig)

OPNsense hat **zwei** Regel-Ebenen: klassisch (`<filter>`, GUI „Firewall ▸ Rules") **und** Automation
(`OPNsense/Firewall/Filter`, GUI „Firewall ▸ Rules [new]"). **Beide** zählen; beim Dichtmachen beide beachten.
Default ist Inter-VLAN-**Deny** (greift, weil pro VLAN nur explizite Allows + „→ !RFC1918" statt „→ any").

### 4.1 Klassische Regeln (`<filter>`, in Reihenfolge)
**opt1 Nodes_MGMT (15):**
- `pass carp` + `pass pfsync` (HA, alle IF)
- `pass tcp 10.6.5.0/24 → 10.6.5.3:443` (XMLRPC-Sync) · `pass icmp 10.6.5.0/24 ↔ 10.6.5.0/24` (HA-Ping)
- `pass tcp opt1 → 10.6.7.16:80` + `pass icmp opt1 → 10.6.7.16` (TEMP vm-106-Web)
- `pass opt1 → !RFC1918` (Internet) · `pass opt1 → 192.168.1.0/24` (Home-LAN/Cluster-Admin)

**Gruppen-Regel (opt1,opt2,wan):** `pass tcp → 10.6.7.0/24` (LAN/Mgmt → DMZ, inkl. HAProxy-VIP)

**wan (Heim-LAN 192.168.1.0/24 → Cluster):**
- `pass tcp 192.168.1.0/24 → 10.6.7.16:80` + `pass icmp → 10.6.7.16` (vm-106)
- `pass icmp 192.168.1.0/24 → 10.6.7.0/24` (Admin-Ping DMZ)
- **`pass any wan → any`** = Blanket „Heim-LAN darf alles" (Trust-Zone; trägt u.a. OPNsense-Selbst-Mgmt + Drucker). Bewusst belassen.
- `pass tcp 192.168.1.0/24 → 10.6.7.0/24` (Web/SSH zu DMZ) · `:80` (Pi-hole-UI) · `tcp/udp :53` (Pi-hole-DNS)
- `pass udp any → 10.6.7.44:51820` (WireGuard)

**opt2 USER (11):**
- `pass tcp 10.6.1.0/24 → 192.168.1.0/24` no-state (ASYM-Return)
- `pass tcp/udp opt2 → PiholeDNS:53` (DNS)
- `pass tcp 10.6.1.0/24 → 10.6.2.38 :631 / :9100 / :515` (**Drucker** Brother MFC-J6530DW, IPP/raw/LPD)
- `pass opt2 → !RFC1918` (Internet; Rest-RFC1918 = implizit deny)

**opt3 IOT_WLAN (12):** `pass tcp 10.6.2.38 → 10.6.7.32:445` (Drucker scan-to-Paperless vm-210) · `pass opt3 → PiholeDNS:53` · `pass opt3 → !RFC1918`

**opt4 GUEST_WLAN (13):** `pass opt4 → PiholeDNS:53` · `pass opt4 → !RFC1918` (nur DNS + Internet)

**opt6 VMs_DMZ (17):** `pass opt6 → !RFC1918` (Internet/Updates) · `pass opt6 → 192.168.1.0/24` (Prometheus-Scrape + Pi-hole-Upstream) · `pass tcp 10.6.7.16/.17 → any:80/443` (Pi-hole-Gravity)

### 4.2 Automation-Regeln (`OPNsense/Firewall/Filter`)
- **en=1** `pass opt1 → (self):ADMIN_PORTS` — **Anti-lockout** Mgmt→OPNsense WebUI/SSH (NIE löschen)
- **en=1** `pass opt6 tcp/udp 10.6.0.0/16 → PiholeDNS:53` — DNS-to-Pi-hole von allen internen VLANs
- **en=1** `pass opt5 → 10.6.4.10` + `block opt5 → any` (quick) — **TOR relay-only** (s. §7)
- **en=0** 6× „Allow optX to anywhere (Standard-Grundregel)" — die alten Bootstrap-any→any, deaktiviert (Segmentierung)
- **en=0** `pass wan 192.168.1.0/24 → 10.6.0.0/16` — deaktivierter LAN→intern-Pass

### 4.3 Erreichbarkeits-Matrix (Soll = Ist)
Jedes interne VLAN erreicht nur noch: eigene explizite Allows + DNS→Pi-hole + Internet (außer TOR = relay-only).
**GUEST/IOT** = Internet+DNS only (IOT zusätzlich Drucker→Paperless). **USER** = Internet+DNS+DMZ+Drucker+Home-LAN-Return.
**DMZ/Mgmt** = Internet+Home-LAN. **Heim-LAN** = alles (Trust-Zone, Blanket). Inter-VLAN-Default-Deny sonst.

---

## 5 — HAProxy (Reverse-Proxy / Klarnamen)

HAProxy läuft auf OPNsense, terminiert TLS und routet per **Host-Header** (`hdr`) auf interne Backends.

**Frontends:**
- **`fe-main`** bind **10.6.7.1:443** (DMZ-CARP-VIP), Wildcard-Cert, defaultBackend = `bk-openclaw`.
- **`fe-traefik`** bind **10.6.7.5:443** (eigener CARP-VIP vhid 5), Wildcard-Cert, defaultBackend = `be-vm-200-traefik`.

**Routing-Tabelle (Host → Backend → Server), Stand 2026-06-29:**

| Klarname | Backend | Server (IP:Port) |
|---|---|---|
| wiki.project-reloaded.org | bk-vm112-knowledge-portal | 10.6.7.22:80 |
| models.project-reloaded.org | bk-vm110-model-gateway | 10.6.7.20:4000 |
| pihole-master.project-reloaded.org | bk-pihole-master | 10.6.7.16:443 |
| pihole-slave.project-reloaded.org | bk-pihole-slave | 10.6.7.17:443 |
| opnsense-master.project-reloaded.org | bk-opnsense-master | 192.168.1.49:443 |
| opnsense-slave.project-reloaded.org | bk-opnsense-slave | 192.168.1.50:443 |
| proxmox.project-reloaded.org | bk-proxmox | 192.168.1.15:8006 |
| openclaw.project-reloaded.org | bk-openclaw (default) | 192.168.1.20:443 |
| unifi.project-reloaded.org | bk-unifi | 192.168.1.1:443 |
| tor.project-reloaded.org | bk-tor | 10.6.4.10:443 |
| portainer / traefik.project-reloaded.org | be-vm-200-traefik | 10.6.7.28:80 |
| vaultwarden.project-reloaded.org | be-vm-240-vaultwarden | 10.6.7.44:80 |
| cloud.project-reloaded.org | be-vm-210-nextcloud | 10.6.7.32:11000 |
| cloud-aio.project-reloaded.org | be-vm-210-aio | 10.6.7.32:8080 |
| paperless.project-reloaded.org | be-vm-210-paperless | 10.6.7.32:8000 |
| kuma.project-reloaded.org | be-uptime-kuma | 10.6.7.24:3001 |
| grafana.project-reloaded.org | be-vm-250-grafana | 10.6.7.48:3000 |
| outline.project-reloaded.org | be-vm-235-outline | 10.6.7.42:3000 |
| openweb-ui.project-reloaded.org | be-vm-200-openwebui | 10.6.7.28:8080 |
| paperclip.project-reloaded.org | be-vm-200-paperclip | 10.6.7.28:3100 |
| cowork.project-reloaded.org | be-vm-201-cowork | 10.6.7.52:3000 |
| architekt.project-reloaded.org | be-vm-201-architekt | 10.6.7.52:3002 |

> Alle Backends `mode=http`, healthcheck aktiv. Klarnamen, die kein ACL matchen, landen auf `bk-openclaw` (default).
> **HAProxy-Stolperfallen (Memory):** `configctl haproxy restart` (nicht nur reload — staging-vs-live);
> nach Restart prüfen, dass HAProxy an die CARP-VIP 10.6.7.1:443 gebunden hat (VIP-Bind-Race); ACL-IDs nicht
> per Deepcopy duplizieren (kollabieren). Plugin braucht vollständiges MVC-Model (Minimal-XML wird ignoriert).

---

## 6 — SSL / Zertifikate

- **Wildcard `*.project-reloaded.org`** (+ SAN `project-reloaded.org`), Let's Encrypt (CA „E8").
- Aktiv genutzt von HAProxy: Cert-Descr **„project-reloaded.org (ACME Client)"** (refid `6a035aa88e044`),
  **gültig bis 2026-08-10**. Weitere Wildcard-Certs im Store: `wildcard-project-reloaded-srv` (+fullchain), gültig bis 2026-07-30.
- Web-GUI-Cert: self-signed `OPNsense.internal`, bis 2027.
- **Validierung:** DNS-01 über **Cloudflare** (DNS-Record `*.project-reloaded.org` → 10.6.7.1; Cloudflare-API-Token
  liegt in `/conf/config.xml`, Prefix `cfut`).
- ⚠️ **RENEWAL-RISIKO:** os-acme-client-Plugin ist aktuell `enabled=0` / leer (keine accounts/certificates/validations).
  D.h. das Cert wird **nicht automatisch erneuert**. **Vor 2026-08-10** entweder das Plugin neu einrichten
  (Account LE + Cloudflare-DNS-01-Validation + Certificate `*.project-reloaded.org` + autoRenew + HAProxy-Restart-Action)
  ODER manuell via acme.sh erneuern und ins HAProxy-Cert importieren. **Sonst brechen alle HTTPS-Klarnamen.**
- Cert-Sync zum Slave: **nicht** in den HA-syncitems → bei Renewal/Slave-Neuaufbau Cert auf beiden Knoten aktualisieren.

---

## 7 — TOR (vm-108, 10.6.4.10)

Transparenter Tor-Gateway für das TOR-VLAN (14). Tor 0.4.9.6.
- **torrc:** `SocksPort 0.0.0.0:9050` (SocksPolicy accept 10.6.0.0/16), `TransPort 0.0.0.0:9040`,
  `DNSPort 0.0.0.0:5353`, `AutomapHostsOnResolve 1`, `VirtualAddrNetworkIPv4 10.192.0.0/10`, `ExitRelay 0`.
- **iptables NAT (im Container):** PREROUTING auf eth0 → DNS (udp/tcp 53) REDIRECT auf 5353, alle TCP-SYN REDIRECT
  auf 9040. D.h. jeder Client im TOR-VLAN, der vm-108 als Gateway nutzt, wird **komplett transparent durch Tor**
  geleitet (inkl. DNS), ohne Client-Konfiguration.
- **OPNsense erzwingt relay-only:** opt5 = `pass → 10.6.4.10` dann `block → any` (quick). Direkter Internet-/DNS-Bypass
  unmöglich. GUEST-Muster (Pi-hole+Direkt-Internet) hier NICHT anwenden (DNS-Leak/Tor-Bypass).
- ✋ Bei Rebuild verifizieren, wie vm-108 selbst ins Internet kommt (Tor-Guards): TOR-VLAN-Auto-NAT existiert; prüfen
  dass vm-108-Egress nicht vom eigenen `block opt5 → any` getroffen wird.

---

## 8 — Pi-hole A/B (DNS)

Zwei **unabhängige** Pi-hole-v6-Instanzen (kein Auto-Sync zwischen A/B — orbital/gravity-sync NICHT installiert):
- **Pi-hole A** = vm-106 = **10.6.7.16** · **Pi-hole B** = vm-107 = **10.6.7.17** (LXC auf node-1).
- **Upstreams (beide):** `10.6.7.1` + `192.168.1.1` (FritzBox; effektiv beobachtet = FritzBox). Keine revServers.
- listeningMode `ALL`, interface eth0.
- **Client-DNS-Weg:** alle internen VLANs dürfen per Automation-Regel `→ PiholeDNS:53`; UniFi-DHCP verteilt die
  Pi-hole-IPs als DNS an Clients. Klarnamen `pihole-master/-slave` via HAProxy auf :443.
- ⚠️ Da kein Sync: Blocklisten/lokale DNS-Einträge auf **beiden** Pi-holes pflegen.

---

## 9 — Backup / Config-Speicherorte

- **OPNsense-Config:** `/conf/config.xml` (komplette Box-Config: Interfaces, VIPs, NAT, Regeln, HAProxy, Certs, ACME).
  Backups dieser Session: `/conf/config.xml.bak-claude-*` auf dem Master. **DR-Pflicht:** regelmäßig `config.xml`
  beider Knoten extern sichern (GUI: System ▸ Configuration ▸ Backups; ideal automatisch + off-host).
- **Cloudflare-Token** + **HA-Sync-Passwort** stecken in der config.xml → Backups entsprechend schützen.
- Diese DR-Doku liegt in `cluster-docs` (Repo) + im Cluster-Wiki.

---

## 10 — Rebuild: einzelne OPNsense neu aufbauen

**Fall A — Slave (104) neu:** 1) OPNsense installieren (gleiche Version wie Master). 2) Interfaces zuweisen
(vtnet0=WAN, vtnet1=VLAN15/17, vtnet2=VLAN11-14). 3) IPs setzen: WAN 192.168.1.50, opt1 10.6.5.3, opt2 10.6.1.3,
opt3 10.6.2.3, opt4 10.6.3.3, opt5 10.6.4.3, opt6 10.6.7.3. 4) CARP-VIPs anlegen (alle vhid wie §1, **advskew 100**).
5) HA: pfsync auf opt1, **kein** synctoip (Slave pusht nicht). 6) Am **Master** `synchronizetoip=10.6.5.3` + Sync
auslösen → Aliases/Rules/NAT/VIPs kommen automatisch. 7) HAProxy + Wildcard-Cert **manuell** auf den Slave
(nicht in syncitems). 8) Verifizieren: `pfctl -sr` Count == Master, CARP = BACKUP.

**Fall B — Master (103) neu / komplett von 0:** 1) Install + Interfaces + IPs (Master-Werte §1, WAN .49, opt .2,
advskew **0**). 2) Aliases (§3), NAT (§2, Modus hybrid + No-NAT-Regeln zuerst), Gateways: Default via WAN→192.168.1.1.
3) CARP-VIPs (§1). 4) Firewall-Regeln (§4) — **erst Allows, dann Default-Deny**; Automation-Regeln inkl. Anti-lockout
+ TOR relay-only + DNS-to-Pi-hole. 5) HAProxy (§5): Frontends fe-main (10.6.7.1:443) + fe-traefik (10.6.7.5:443),
Backends/Server/ACLs/Actions laut Tabelle. 6) SSL (§6): ACME-Plugin mit LE-Account + Cloudflare-DNS-01 + Wildcard-Cert,
HAProxy bindet Cert. 7) HA-Config-Sync zum Slave einrichten. 8) Voll-Verifikation (alle Klarnamen 200/302, Egress, Pi-hole).
> **Schnellster Weg:** ein aktuelles `/conf/config.xml`-Backup einspielen (System ▸ Configuration ▸ Backups ▸ Restore),
> dann nur IP/advskew/Hostname-Deltas prüfen. Voraussetzung: aktuelle Backups existieren (§9).

---

## 11 — Recovery-Zugänge & Standard-Checks

### 11.1 Zugang (über Klaus' Windows + Desktop Commander)
`python -i C:\Users\Klaus\clutil.py` → `M()`=Master.49, `S()`=Slave.50, `vm100()`=OpenClaw, `n1()`=node-1.
Kette: Windows → node-1 (192.168.1.15) → vm-100 (192.168.1.20, Key id_ed25519_openclaw) → OPNsense (Key
id_ed25519_opnsense). OPNsense-Shell = **csh** (keine `2>&1`/`2>/dev/null`-Redirects; grep über die Kette
unzuverlässig → Output holen, in Python filtern; box-seitige Skripte via `echo <b64> | openssl base64 -d -A | python3`).

### 11.2 Standard-Verifikation (beide Knoten)
`M("pfctl -sr")` / `S("pfctl -sr")` Regelzahl gleich · `M("ifconfig")` CARP MASTER (Slave BACKUP) für alle 8 vhid ·
nach jeder Regeländerung: `configctl filter reload` + `/usr/local/etc/rc.filter_synchronize` (am Master) + `pfctl`-Check beidseitig.

### 11.3 Master-Reparatur wenn Home-LAN→Master-SSH (.49) tot
1) Key auf Slave: `vm100("scp -i /root/.ssh/id_ed25519_opnsense /root/.ssh/id_ed25519_opnsense root@192.168.1.50:/tmp/mk")` + `S("chmod 600 /tmp/mk")`.
2) Slave→Master über Mgmt (Anti-lockout): `S("ssh -i /tmp/mk root@10.6.5.2 <cmd>")`.
3) Fix (z.B. Config zurück): `cp /conf/config.xml.bak-... /conf/config.xml; configctl filter reload`.
4) `S("rm -f /tmp/mk")`. Alternativen: Proxmox-Konsole (`qm terminal 103`, braucht root-PW) oder `n1("qm stop 103")` (Slave übernimmt).

### 11.4 Bekannte Risiken (offen)
- ⚠️ Beide OPNsense auf node-1 (§0.1) · ⚠️ Cert-Renewal nicht armiert (§0.2, §6) · Pi-hole A/B ohne Sync (§8) ·
  USV für node-1/Switch/UniFi offen.

---

*Stand 2026-06-29. Erhoben live aus beiden OPNsense + Pi-hole/TOR-Containern. Bei Änderungen am Netzwerk-Kern
diese Datei nachziehen (Quelle der Wahrheit, Hand-gepflegt).*

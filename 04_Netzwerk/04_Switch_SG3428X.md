# Switch – TP-Link SG3428X

## Gerät

| Eigenschaft         | Wert                                                       |
|---------------------|------------------------------------------------------------|
| Modell              | TP-Link SG3428X (Omada L2+)                                |
| Firmware            | 1.30.0 Build 20231019 Rel.60485                            |
| Hardware-Revision   | SG3428X 1.30                                               |
| IP-Adresse          | 192.168.1.74                                               |
| MAC-Adresse         | F0-09-0D-2A-CE-13                                          |
| Ports               | 24x GbE Kupfer + 4x 10GE SFP+                             |
| LAG                 | LAG1 = Port 25+26 (LACP, Uplink zu OPNsense vtnet1)       |

---

## VLAN-Konfiguration

| VLAN ID | Name       | Zweck                                 |
|---------|------------|---------------------------------------|
| 1       | System     | Management-VLAN, Switch-Weboberfläche |
| 11      | USER       | Normales LAN für Endgeräte            |
| 12      | IOT_WLAN   | IoT-Geräte über WLAN                  |
| 13      | GUEST_WLAN | Gäste-WLAN (isoliert)                 |
| 14      | TOR        | TOR-Exit / anonymes Netz              |
| 15      | Nodes_MGMT | Proxmox Node Management               |
| 17      | VMs_DMZ    | VM-DMZ / externe Dienste              |

> VLANs 7 und 10 wurden gelöscht.

---

## Portbelegung

### Access-Ports USER (VLAN 11, PVID 11)

| Port   | PVID | Netz |
|--------|------|------|
| 1/0/1  | 11   | USER |
| 1/0/2  | 11   | USER |
| 1/0/3  | 11   | USER |
| 1/0/4  | 11   | USER |
| 1/0/5  | 11   | USER |
| 1/0/6  | 11   | USER |
| 1/0/7  | 11   | USER |
| 1/0/8  | 11   | USER |
| 1/0/9  | 11   | USER |
| 1/0/10 | 11   | USER |
| 1/0/11 | 11   | USER |
| 1/0/12 | 11   | USER |
| 1/0/15 | 11   | USER |
| 1/0/16 | 11   | USER |
| 1/0/17 | 11   | USER |
| 1/0/18 | 11   | USER |

### Access-Ports TOR (VLAN 14, PVID 14)

| Port   | PVID | Netz |
|--------|------|------|
| 1/0/13 | 14   | TOR  |
| 1/0/14 | 14   | TOR  |

### Trunk-Ports UniFi APs (PVID 1)

Tagged: VLAN 1, 11, 12, 13, 14

| Port   | PVID | Gerät     |
|--------|------|-----------|
| 1/0/19 | 1    | UniFi AP  |
| 1/0/20 | 1    | UniFi AP  |
| 1/0/21 | 1    | UniFi AP  |
| 1/0/22 | 1    | UniFi AP  |
| 1/0/23 | 1    | UniFi AP  |
| 1/0/24 | 1    | UniFi AP  |

### SFP+-Ports Uplinks 10 GbE

| Port   | PVID | Tagged VLANs | Funktion                          |
|--------|------|--------------|-----------------------------------|
| 1/0/25 | 1    | alle         | LAG1 - OPNsense vtnet1            |
| 1/0/26 | 1    | alle         | LAG1 - OPNsense vtnet1            |
| 1/0/27 | 1    | 1, 15, 17    | Proxmox / Server-Uplink           |
| 1/0/28 | 1    | 1, 15, 17    | Proxmox / Server-Uplink           |

---

## VLAN-Mitgliedschaften

| VLAN | Name       | Untagged (Access)    | Tagged (Trunk)              |
|------|------------|----------------------|-----------------------------|
| 1    | System     | -                    | 1/0/19-24, 1/0/27-28, LAG1  |
| 11   | USER       | 1/0/1-12, 1/0/15-18  | 1/0/19-28                   |
| 12   | IOT_WLAN   | -                    | 1/0/19-28                   |
| 13   | GUEST_WLAN | -                    | 1/0/19-28                   |
| 14   | TOR        | 1/0/13-14            | 1/0/19-28                   |
| 15   | Nodes_MGMT | -                    | 1/0/25-28                   |
| 17   | VMs_DMZ    | -                    | 1/0/25-28                   |

---

## LAG-Konfiguration

- **LAG1**: Ports 1/0/25 + 1/0/26 (LACP)
- Ziel: OPNsense vtnet1
- Traegt alle VLANs getaggt
- 20 Gbps aggregierte Bandbreite

---

## Verwaltung

- **Web-UI**: http://192.168.1.74
- **Zugang**: Laptop an Port 19-24 (Trunk) anschliessen oder ueber OPNsense erreichbar
- **Konfiguration speichern**: Oben rechts Save -> Yes

> Warnung: Ports 1-18 haben PVID=11 (USER) bzw. PVID=14 (TOR). Fuer Switch-Management Port 19-24 verwenden.

---

## Aenderungshistorie

| Datum      | Aenderung                                        |
|------------|--------------------------------------------------|
| 2026-04-19 | Erstdokumentation; PVID fuer alle Ports gesetzt  |
| 2026-04-19 | VLANs 7 und 10 geloescht                         |
| 2026-04-19 | PVID=11 auf Ports 1-12 und 15-18 gesetzt         |
| 2026-04-19 | PVID=14 auf Ports 13-14 gesetzt                  |
| 2026-04-19 | Konfiguration im Flash gespeichert               |

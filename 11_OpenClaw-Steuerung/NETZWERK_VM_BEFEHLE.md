# NETZWERK_VM_BEFEHLE — Konfigurations- und Diagnose-Befehlssatz NW2-NW9, VM2+, SYS2+

> **Pfad:** `cluster-docs/11_OpenClaw-Steuerung/NETZWERK_VM_BEFEHLE.md`
> **Erweiterung zu:** `OPENCLAW_BEFEHLSKATALOG.md` (das die Audit-Befehle NW1, VM1, SYS1, AUDIT1 definiert).
> **Voraussetzung:** Vor jedem dieser Befehle MUSS `NW1` erfolgreich gelaufen sein (Audit aller 6 Geräte).
> **Sicherheitsregel:** Alle Konfigurationsbefehle (NW2+) zeigen ZUERST den Plan, warten auf "ok", dann erst Ausführung.

---

## NETZWERK-BEFEHLE NW2-NW9

### NW2 — UniFi: AP-Adoption prüfen + neu auslösen

**Zweck:** Prüft ob UniFi APs adopted sind. Falls Reset nötig: ausführen nach `cluster-docs/04_Netzwerk/05_UAP-AC-PRO_Reset_und_Adoption.md`.

```
Voraussetzung: NW1 muss bestanden sein.
1. Logge dich auf https://192.168.1.1 ein (UniFi Controller)
2. Liste alle APs: Status (Connected/Adopting/Disconnected)
3. Bei Status != Connected: zeige mir AP-Name + MAC + IP + letzter Heartbeat
4. Wenn ich "fix [AP-Name]" sage: führe Adoption-Workflow aus 04_Netzwerk/05_UAP-AC-PRO_Reset_und_Adoption.md aus
5. Bestätige mit: NW2_DONE oder Liste der betroffenen APs
```

### NW3 — OPNsense: Regel-Drift gegen Soll-Stand prüfen

**Zweck:** Vergleicht aktuelle Firewall-Regeln auf 192.168.1.49 gegen Soll-Stand in `cluster-docs/04_Netzwerk/02_OPNsense-Firewalls.md`.

```
Voraussetzung: NW1 bestanden.
1. SSH auf OPNsense Master (192.168.1.49) — Credentials aus credentials.env
2. Exportiere aktuelle Regeln: configctl filter list rules > /tmp/fw_now.json
3. Lese cluster-docs/04_Netzwerk/02_OPNsense-Firewalls.md (Soll-Stand)
4. Diff: welche Regeln sind nur in einer Quelle?
5. Bericht: "DRIFT|+rule_xyz" / "DRIFT|-rule_abc" / "OK keine Drift"
6. KEIN Schreibzugriff auf OPNsense — nur Diagnose. Bei Drift: Mensch muss entscheiden.
```

### NW4 — Switch SG3428X: VLAN-Konfiguration verifizieren

**Zweck:** Prüft VLAN-Zuweisung am SG3428X (192.168.1.74) gegen `cluster-docs/04_Netzwerk/04_Switch_SG3428X.md`.

```
Voraussetzung: NW1 bestanden.
1. HTTP-Login auf 192.168.1.74 (Web-UI) mit Credentials aus credentials.env
2. Lies VLAN-Konfiguration jeden Ports
3. Lies Soll-Stand aus 04_Netzwerk/04_Switch_SG3428X.md
4. Bericht pro Port: VLAN_OK / VLAN_DRIFT_FROM=X_TO=Y / PORT_DOWN
5. Bei Drift: KEINE automatische Korrektur. Mensch entscheidet.
6. Bestätige mit: NW4_DONE
```

### NW5 — Pi-hole: Adlists synchronisieren (beide Instanzen identisch)

**Zweck:** Stellt sicher, dass Pi-hole 1 (10.6.7.16) und Pi-hole 2 (10.6.7.17) gleichen Stand haben.

```
Voraussetzung: NW1 bestanden, beide Pi-holes erreichbar.
1. SSH auf Pi-hole 1: pihole -a -l > /tmp/ph1.txt
2. SSH auf Pi-hole 2: pihole -a -l > /tmp/ph2.txt
3. Diff auf VM 100. Bericht: identisch / Drift mit Liste
4. Bei Drift: Vorschlag, welche Quelle führend sein soll (Default: Pi-hole 1)
5. Auf "ok" warten. Dann erst syncen.
6. Bestätige mit: NW5_DONE
```

### NW6 — DNS-Auflösung clusterweit testen

**Zweck:** Stellt sicher, dass alle VMs gleiche DNS-Antworten bekommen.

```
1. Liste alle VMs mit `ssh_exec`-fähigem Zugriff aus credentials.env
2. Auf jeder VM ausführen: dig +short google.com @192.168.1.49 (intern) und @8.8.8.8 (extern)
3. Sammle Ergebnisse: VM | intern | extern | Latenz
4. Markiere Abweichungen
5. Bestätige mit: NW6_DONE oder Liste auffälliger VMs
```

### NW7 — Routing-Tabelle aller Network-VMs erfassen

**Zweck:** Snapshot aller IP-Routing-Tabellen für Drift-Erkennung.

```
1. Auf VM 100, OPNsense Master/Backup, Pi-hole 1+2: ausführen `ip route show` und `ip rule show`
2. Speichere als /tmp/routes_VMNAME_DATUM.txt
3. Vergleiche gegen letzten Snapshot in cluster-docs/_ai/openclaw/sessions/[VORLETZTES_DATUM]-NW7-routes/
4. Bericht: Drift ja/nein, Liste neuer/entfernter Routen
5. Speichere neuen Snapshot, committe in cluster-docs.
6. Bestätige mit: NW7_DONE
```

### NW8 — VLAN-Trunk-Test zwischen Switch und OPNsense

**Zweck:** Verifiziert dass alle VLAN-Tags durchkommen (kein Trunk-Drop).

```
Voraussetzung: NW1, NW4 grün.
1. Auf VM 100: tcpdump -i any -nn vlan
2. Triggere von einer Test-VM in jedem VLAN ein Ping zur OPNsense
3. Prüfe ob alle VLAN-IDs im Capture auftauchen
4. Bericht: VLAN_X: SEEN / NOT_SEEN
5. Bestätige mit: NW8_DONE
```

### NW9 — End-to-End-Konnektivität (jede VM zu jeder VM)

**Zweck:** Vollständige Konnektivitätsmatrix für 5x5 oder 7x7 VM-Grid.

```
1. Liste alle aktiven VMs (aus VM1-Output)
2. Erstelle Ping-Matrix: jede VM pingt jede andere
3. Markiere: OK / TIMEOUT / UNREACHABLE
4. Erstelle Matrix als Markdown-Tabelle
5. Speichere als cluster-docs/08_Betrieb/CONNECTIVITY_MATRIX_[DATUM].md
6. Committe mit: "docs(network): Konnektivitätsmatrix [DATUM]"
7. Bestätige mit: NW9_DONE
```

---

## VM-BEFEHLE VM2-VM9

### VM2 — VM-Backup-Status

```
1. Rufe pve_api_get /cluster/backup ab
2. Pro VM: letzter Backup-Zeitpunkt, Größe, Status
3. Markiere kritisch: VM ohne Backup > 24h
4. Bericht als Tabelle
5. Bestätige mit: VM2_DONE
```

### VM3 — VM-Snapshot-Übersicht

```
1. pve_list_vms + qm listsnapshot pro VM
2. Pro VM: Anzahl Snapshots, ältester, neuester
3. Markiere: VMs mit > 5 Snapshots (Konsolidierungs-Empfehlung)
4. Bericht
5. Bestätige mit: VM3_DONE
```

### VM4 — Disk-Belegung pro VM (Storage-Sicht)

```
1. pve_api_get /storage und /nodes/NODE/storage/STORAGE/content
2. Pro VM: Disk-Größe, belegt, frei
3. Markiere: VM > 90% disk
4. Bericht
5. Bestätige mit: VM4_DONE
```

### VM5 — VM-Migration-Readiness

```
1. Pro VM: prüfe ob shared storage genutzt (nötig für Live-Migration)
2. Liste: VM | shared? | letzter Migrationstest | OK/NICHT_GETESTET
3. Empfehlung: welche VMs sind Migration-fähig
4. Bestätige mit: VM5_DONE
```

### VM6 — VM-Resource-Profil (CPU/RAM-Sollvergleich)

```
1. Lese pro Repo: docs/VM_SPEC.md (Soll-Werte)
2. Lese aktuelle VM-Konfig: pve_api_get /nodes/NODE/qemu/VMID/config
3. Diff: Soll vs. Ist (cores, memory, balloon)
4. Bericht: VMs mit Drift
5. Bestätige mit: VM6_DONE
```

### VM7 — VM-Templates aktuell?

```
1. Liste alle Templates auf jedem Node
2. Pro Template: Erstellungsdatum, ob Updates verfügbar (apt list --upgradable in Template-Container)
3. Markiere: Templates älter als 90 Tage
4. Bestätige mit: VM7_DONE
```

### VM8 — VM-IP-Inventar (gegen Soll-Stand)

```
1. pve_list_vms + qm guest cmd VMID network-get-interfaces
2. Lese cluster-docs/04_Netzwerk/01_VLANs.md (Soll-IP-Plan)
3. Diff: VM hat IP X, sollte Y haben
4. Bestätige mit: VM8_DONE
```

### VM9 — Auto-Start-Reihenfolge prüfen

```
1. pve_api_get /nodes/NODE/qemu/VMID/config — onboot, startup
2. Erwartet (aus INSTALL_SEQUENCE.md jedes Repos):
   - Infra-VMs zuerst (OPNsense, DNS)
   - Dann VM 100 (OpenClaw)
   - Dann Fachfabriken
3. Markiere: Reihenfolge OK / Drift
4. Bestätige mit: VM9_DONE
```

---

## SERVICE-BEFEHLE SYS2-SYS9

### SYS2 — Tägliche Logs auf Anomalien scannen

```
1. Auf VM 100 + alle aktiven VMs: journalctl --since "1 day ago" --priority=err
2. Aggregiere: Top-10 Fehlermeldungen
3. Bericht mit Beispielen
4. Bestätige mit: SYS2_DONE
```

### SYS3 — systemd-Timer + Cron-Jobs auflisten

```
1. Pro VM: systemctl list-timers --all + crontab -l (root + jeder User)
2. Aggregiere: welche Tasks wann
3. Markiere: Doppelläufer (gleicher Job auf mehreren VMs)
4. Bestätige mit: SYS3_DONE
```

### SYS4 — Software-Aktualisierungs-Stand

```
1. Pro VM: apt list --upgradable | wc -l + Liste der Sicherheits-Updates
2. Markiere: VMs mit > 10 ausstehenden Sec-Updates
3. KEIN Auto-Update — Mensch entscheidet
4. Bericht
5. Bestätige mit: SYS4_DONE
```

### SYS5 — SSH-Key-Audit (wer darf wo rein?)

```
1. Pro VM: cat /root/.ssh/authorized_keys + cat /etc/ssh/sshd_config (PermitRoot, AllowUsers)
2. Erstelle Matrix: User | VM | Key-Typ | Kommentar
3. Markiere: Keys ohne Kommentar (Quelle unklar)
4. Bericht
5. Bestätige mit: SYS5_DONE
```

### SYS6 — Open Ports Scan (lokal pro VM)

```
1. Pro VM: ss -tnlp + ss -unlp
2. Vergleiche gegen Soll-Stand pro VM (aus VM_SPEC.md)
3. Markiere: unerwartete offene Ports
4. Bericht
5. Bestätige mit: SYS6_DONE
```

### SYS7 — Backup-Integritätsprüfung

```
1. Lese letzte Backups (aus VM2)
2. Stichprobe: 1 Backup restoren in Sandbox-Storage, prüfen
3. Bericht: Restore_OK / Restore_FAIL pro Stichprobe
4. Bestätige mit: SYS7_DONE
```

### SYS8 — OpenClaw-Health vollständig

```
1. curl http://192.168.1.20:18789/health
2. Auf VM 100: systemctl status openclaw, journalctl -u openclaw --since "1 hour ago"
3. Lese ~/.openclaw/openclaw.json — Modell, MCP-Server-Liste
4. Test: einen einfachen Befehl an OpenClaw "echo OK" — Antwortzeit messen
5. Bericht: OK / DEGRADED / DOWN
6. Bestätige mit: SYS8_DONE
```

### SYS9 — Container/Docker-Status (falls vorhanden)

```
1. Pro VM mit Docker: docker ps -a, docker images
2. Markiere: Container restarting > 3x in letzten 24h, Images älter als 90 Tage
3. Bestätige mit: SYS9_DONE
```

---

## Erweiterter Audit AUDIT2

```
Erweiterung von AUDIT1: nach NW1 + VM1 + SYS1 zusätzlich
NW6 (DNS), NW7 (Routes), VM2 (Backups), VM4 (Disk), SYS4 (Updates), SYS8 (OpenClaw).
Schreibe Gesamtreport in cluster-docs/_ai/openclaw/sessions/[DATUM]-AUDIT2-cluster.md.
Bestätige mit: AUDIT2_DONE
```

---

*Stand: 2026-04-25 | Erweitert OPENCLAW_BEFEHLSKATALOG um Konfigurations-/Tiefen-Diagnose.*
*Pflicht: Vor JEDEM Konfigurationsbefehl (NW2+) muss NW1 grün sein.*

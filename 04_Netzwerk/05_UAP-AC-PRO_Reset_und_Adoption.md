# UAP-AC-PRO – Reset & Adoption (Gebrauchsanweisung)

## Überblick

Diese Anleitung beschreibt, wie ein UniFi UAP-AC-PRO auf Werkseinstellungen zurückgesetzt
und anschliessend in den UniFi Network Controller (Cloud Gateway Ultra, 192.168.1.1) eingebunden wird.

**Benötigt:**
- Büroklammer oder dünner Stift (für Reset-Taste)
- PoE-Switch oder PoE-Injector (802.3af/at)
- Netzwerkkabel (Cat5e oder besser)
- Zugriff auf http://192.168.1.1 (UniFi Network Controller)

---

## Schritt 1 – Werksreset

### Reset-Taste finden

Die Reset-Taste befindet sich an der **Unterseite** des APs, direkt am Rand des Gehäuses –
erkennbar als kleine Vertiefung mit Beschriftung "Reset".

### Reset durchführen

1. PoE-Kabel einstecken – warten bis LED **dauerhaft weiss leuchtet** (AP vollständig gestartet, ~60 Sek.)
2. Reset-Taste mit Büroklammer **gedrückt halten**
3. Nach ca. **10 Sekunden** beginnt die LED zu blinken, dann kurz aus – **Taste loslassen**
4. AP startet automatisch neu (~90 Sekunden)
5. LED **langsam weiss blinkend** = Reset erfolgreich, AP im Werkszustand

> **Achtung:** Stromverbindung während des Resets NICHT unterbrechen.
> Der AP ist erst bereit, wenn die LED langsam weiss blinkt.

### LED-Referenz

| LED-Muster              | Bedeutung                          |
|-------------------------|------------------------------------|
| Langsam weiss blinkend  | Nicht adoptiert / Pending          |
| Dauerhaft weiss         | Online und verbunden               |
| Schnell weiss blinkend  | Startet / wird provisioniert       |
| Blau blinkend           | Firmware-Upgrade läuft             |
| Dauerhaft gelb          | Kein Uplink / kein Controller      |
| Aus                     | Kein Strom                         |

---

## Schritt 2 – Physischer Anschluss

Der AP muss am **gleichen Layer-2-Netzwerk** wie der UniFi Controller hängen
(Management-VLAN 1), damit er automatisch erkannt wird.

### Anschluss-Schema

```
UniFi Cloud Gateway (192.168.1.1)
        |
   Switch SG3428X (192.168.1.74)
        |
   Port 19–24  [Trunk, PVID=1, tagged: VLAN 1/11/12/13/14]
        |
   PoE-Switch oder PoE-Injector (802.3af)
        |
   UAP-AC-PRO
```

### Wichtig zu den Switch-Ports

- Ports **19–24** am SG3428X sind Trunk-Ports mit PVID=1
- VLAN 1 (Management) ist dabei untagged übertragen – der AP kommuniziert über VLAN 1 mit dem Controller
- Kein zusätzliches VLAN-Tagging am Switch-Port nötig

---

## Schritt 3 – Adoption im UniFi Controller

1. Browser öffnen: **http://192.168.1.1**
2. Zu **Devices** (Geräte) navigieren
3. AP erscheint mit Status **"Pending Adoption"** – falls nicht sichtbar: 1–2 Minuten warten und Seite neu laden
4. Auf den AP klicken → **"Adopt"** klicken
5. Warten – der AP durchläuft folgende Phasen:

```
Pending → Adopting → Provisioning → Connected
```

6. Wenn LED **dauerhaft weiss**, ist der AP vollständig eingebunden und betriebsbereit

> Die Adoption dauert je nach Firmware-Stand 2–5 Minuten.
> Erscheint der AP nach 5 Minuten nicht unter Devices, siehe Abschnitt "Fehlerbehebung".

---

## Schritt 4 – WLAN-Konfiguration durch Claude

Sobald der AP den Status **"Connected"** hat, kann Claude die WLAN-Konfiguration
vollständig automatisiert vornehmen. Dazu gehören:

| Aufgabe                        | Details                                      |
|--------------------------------|----------------------------------------------|
| SSIDs zuweisen                 | USER, IOT, Gast, TOR je nach VLAN            |
| VLAN-Tagging pro SSID          | VLAN 11 / 12 / 13 / 14                       |
| Sendeleistung einstellen       | Auto oder manuell (dBm)                      |
| Kanalbreite konfigurieren      | 2,4 GHz und 5 GHz separat                    |
| Band-Steering aktivieren       | Clients automatisch auf 5 GHz lenken         |
| AP-Gruppe zuordnen             | Für Einzel- oder Multi-AP-Setup              |
| Fast Roaming (802.11r)         | Für nahtloses Roaming zwischen mehreren APs  |

**Voraussetzung für Claude:** AP muss unter Devices mit Status "Connected" erscheinen.

---

## Fehlerbehebung

### AP erscheint nicht unter "Pending Adoption"

- Sicherstellen, dass AP und Controller im selben Layer-2-Netzwerk sind (VLAN 1)
- AP-LED muss langsam weiss blinken (nicht gelb oder aus)
- PoE-Versorgung prüfen (802.3af mind. 15W erforderlich)
- AP nochmals resetten (Schritt 1 wiederholen)

### AP bleibt bei "Adopting" hängen

- Prüfen ob der AP die Firmware-Version des Controllers unterstützt
- Im Controller unter **Devices → AP → Upgrade** Firmware manuell aktualisieren
- Controller und AP kurz vom Strom trennen und neu starten

### AP zeigt dauerhaft gelbe LED

- Kein Uplink erkannt – Kabelverbindung prüfen
- Switch-Port-Status prüfen (Link up/down)
- PoE-Budget am Switch prüfen

### AP verliert nach Adoption die Verbindung

- Routing zwischen VLAN 1 und Controller-IP prüfen
- Firewall-Regeln in OPNsense prüfen (Controller-Port TCP 8080 und 8443)

---

## Netzwerk-Referenz

| Gerät                  | IP-Adresse    | Zugriff                  |
|------------------------|---------------|--------------------------|
| UniFi Cloud Gateway    | 192.168.1.1   | https://192.168.1.1      |
| Switch SG3428X         | 192.168.1.74  | http://192.168.1.74      |
| UAP-AC-PRO (nach Reset)| DHCP (VLAN 1) | Nur über Controller      |

---

## Änderungshistorie

| Datum      | Änderung                        |
|------------|---------------------------------|
| 2026-04-19 | Erstdokumentation               |

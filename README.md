# BoltCore

BoltCore is een drop-in submap voor een bestaande [AnanCore](https://github.com/ChasingCoffee/AnanCore) installatie. Het serveert de **bolt-web interface** via dezelfde poorten als AnanCore (6060/6443), zodat je bij het opstarten kunt kiezen tussen de lichtgewichte BoltSDR UI en de standaard zeus-web interface.

AnanCore blijft volledig intact. BoltCore gebruikt `ZEUS_WEBROOT` — een omgevingsvariabele die AnanCore al ondersteunt — om de frontend te wisselen zonder de server te wijzigen.

---

## Structuur na installatie

```
<anacore-install>/
│   OpenhpsdrZeus[.exe]          ← AnanCore (onaangeroerd)
│   wwwroot/                     ← zeus-web interface
│
└── BoltCore/                    ← drop-in submap
        bolt-web/                ← bolt-web interface (gekopieerd door install)
        install.sh / .bat        ← installatie
        uninstall.sh / .bat      ← verwijdering
        start-boltcore.sh / .bat ← start met bolt-web interface
        start-anacore.sh / .bat  ← start met standaard zeus-web interface
        README.md
```

---

## Installatie

### Vereisten
- AnanCore geïnstalleerd ([win-anancore](https://github.com/pe5jw/win-anancore) of Linux tarball)
- bolt-web gebouwd (`npm run build` in `bolt-web/`)

### Linux / macOS / Raspberry Pi
```bash
chmod +x install.sh
./install.sh
# Of met expliciete paden:
./install.sh --anacore-dir /opt/anancore --bolt-web-dir /home/joeri/bolt-web/dist
```

### Windows
```
install.bat
```
Of dubbelklik op `install.bat` — het script zoekt AnanCore automatisch op in de bovenliggende map.

---

## Gebruik

### BoltCore starten (bolt-web interface)

**Linux / Pi:**
```bash
./BoltCore/start-boltcore.sh
```

**Windows:**
```
BoltCore\start-boltcore.bat
```

Open daarna: `http://<ip>:6060`

### AnanCore starten (zeus-web interface)

**Linux / Pi:**
```bash
./BoltCore/start-anacore.sh
# Of direct:
./OpenhpsdrZeus
```

**Windows:**
```
BoltCore\start-anacore.bat
# Of direct:
OpenhpsdrZeus.exe
```

> ⚠️ Start nooit BoltCore en AnanCore tegelijk — ze gebruiken dezelfde poorten.

---

## Hoe het werkt

AnanCore's server ondersteunt de omgevingsvariabele `ZEUS_WEBROOT`. Als die gezet is, serveert de server die map als wwwroot in plaats van de standaard map naast de executable.

`start-boltcore.sh` / `.bat` zet simpelweg:
```
ZEUS_WEBROOT=<BoltCore>/bolt-web
```
...en start daarna `OpenhpsdrZeus` vanuit de AnanCore map. Alles werkt op de bestaande poorten en met de bestaande appsettings.

---

## Verwijderen

**Linux / Pi:**
```bash
./BoltCore/uninstall.sh
```

**Windows:**
```
BoltCore\uninstall.bat
```

Alleen de `BoltCore/` submap wordt verwijderd. AnanCore blijft intact.

---

## Platforms

| Platform    | Getest |
|-------------|--------|
| Windows x64 | ✓      |
| Linux x64   | ✓      |
| Linux arm64 | ✓      |
| Raspberry Pi| ✓      |

---

## Licentie

GPL-2.0-or-later — zie [LICENSE](../LICENSE).

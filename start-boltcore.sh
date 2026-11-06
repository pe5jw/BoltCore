#!/usr/bin/env bash
# BoltCore starten — Linux / macOS / Raspberry Pi
#
# Start AnanCore (OpenhpsdrZeus) met bolt-web als interface.
# Poorten 6060 (HTTP) en 6443 (HTTPS) — dezelfde als AnanCore.
#
# Nooit tegelijk met start-anacore.sh draaien.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANACORE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ANACORE_EXE="$ANACORE_DIR/OpenhpsdrZeus"
BOLT_WEBROOT="$SCRIPT_DIR/bolt-web"

# ── Controles ────────────────────────────────────────────────────────────────
if [[ ! -f "$ANACORE_EXE" ]]; then
  echo "✗  OpenhpsdrZeus niet gevonden in: $ANACORE_DIR" >&2
  echo "   Zorg dat BoltCore in een submap van de AnanCore installatie staat." >&2
  exit 1
fi

if [[ ! -f "$BOLT_WEBROOT/index.html" ]]; then
  echo "✗  bolt-web niet gevonden in: $BOLT_WEBROOT" >&2
  echo "   Voer eerst install.sh uit." >&2
  exit 1
fi

# ── Poortconflict check ───────────────────────────────────────────────────────
for port in 6060 6443; do
  if command -v lsof &>/dev/null; then
    if lsof -iTCP:"$port" -sTCP:LISTEN -P &>/dev/null; then
      echo "✗  Poort $port is al in gebruik." >&2
      echo "   AnanCore of een andere instantie draait al. Stop die eerst." >&2
      exit 1
    fi
  fi
done

# ── Banner ────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║  BoltCore — bolt-web interface                   ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "  Interface : bolt-web"
echo "  HTTP      : http://$(hostname -I 2>/dev/null | awk '{print $1}' || echo localhost):6060"
echo "  HTTPS     : https://$(hostname -I 2>/dev/null | awk '{print $1}' || echo localhost):6443"
echo "  wwwroot   : $BOLT_WEBROOT"
echo ""
echo "  Ctrl+C om te stoppen."
echo ""

# ── Start AnanCore met bolt-web als wwwroot ───────────────────────────────────
# ZEUS_WEBROOT overschrijft de standaard wwwroot naast de executable.
# Starten vanuit de AnanCore map zodat appsettings.json en lib-paden kloppen.
cd "$ANACORE_DIR"
export ZEUS_WEBROOT="$BOLT_WEBROOT"
exec ./OpenhpsdrZeus

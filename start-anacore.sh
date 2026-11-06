#!/usr/bin/env bash
# AnanCore starten vanuit BoltCore map — Linux / macOS / Raspberry Pi
#
# Start AnanCore normaal met de standaard zeus-web interface.
# Poorten 6060 (HTTP) en 6443 (HTTPS).
#
# Nooit tegelijk met start-boltcore.sh draaien.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANACORE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ANACORE_EXE="$ANACORE_DIR/OpenhpsdrZeus"

# ── Controles ────────────────────────────────────────────────────────────────
if [[ ! -f "$ANACORE_EXE" ]]; then
  echo "✗  OpenhpsdrZeus niet gevonden in: $ANACORE_DIR" >&2
  exit 1
fi

# ── Poortconflict check ───────────────────────────────────────────────────────
for port in 6060 6443; do
  if command -v lsof &>/dev/null; then
    if lsof -iTCP:"$port" -sTCP:LISTEN -P &>/dev/null; then
      echo "✗  Poort $port is al in gebruik." >&2
      echo "   BoltCore of een andere instantie draait al. Stop die eerst." >&2
      exit 1
    fi
  fi
done

# ── Banner ────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║  AnanCore — zeus-web interface                   ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "  Interface : zeus-web (AnanCore standaard)"
echo "  HTTP      : http://$(hostname -I 2>/dev/null | awk '{print $1}' || echo localhost):6060"
echo "  HTTPS     : https://$(hostname -I 2>/dev/null | awk '{print $1}' || echo localhost):6443"
echo ""
echo "  Ctrl+C om te stoppen."
echo ""

# ── Start AnanCore normaal (zonder ZEUS_WEBROOT → standaard wwwroot) ──────────
# Zorg dat ZEUS_WEBROOT niet gezet is (bijv. na eerder BoltCore gebruik)
unset ZEUS_WEBROOT

cd "$ANACORE_DIR"
exec ./OpenhpsdrZeus

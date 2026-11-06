#!/usr/bin/env bash
# BoltCore verwijderen — Linux / macOS / Raspberry Pi
#
# Verwijdert de volledige BoltCore submap.
# AnanCore blijft volledig intact.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANACORE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║  BoltCore — Verwijderen                          ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "  Te verwijderen : $SCRIPT_DIR"
echo "  AnanCore       : $ANACORE_DIR  (onaangeroerd)"
echo ""

# Controleer of OpenhpsdrZeus actief is op onze poort
if command -v lsof &>/dev/null; then
  if lsof -iTCP:6060 -sTCP:LISTEN -P &>/dev/null; then
    echo "✗  Een server draait nog op poort 6060." >&2
    echo "   Stop BoltCore of AnanCore eerst." >&2
    exit 1
  fi
fi

read -rp "  BoltCore verwijderen? (ja/nee): " confirm
[[ "$confirm" =~ ^(ja|j|yes|y)$ ]] || { echo "  Verwijderen afgebroken."; exit 0; }

# Verwijder de BoltCore map
# Dit script verwijdert zichzelf — dat werkt in bash omdat het script
# al in geheugen geladen is tegen de tijd dat de map verdwijnt.
rm -rf "$SCRIPT_DIR"

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║  BoltCore verwijderd.                            ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "  AnanCore in $ANACORE_DIR is onaangeroerd."
echo "  Start AnanCore normaal via ./OpenhpsdrZeus"
echo ""

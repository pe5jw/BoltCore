#!/usr/bin/env bash
# BoltCore installer — Linux / macOS / Raspberry Pi
#
# Gebruik:
#   ./install.sh
#   ./install.sh --anacore-dir /opt/anancore
#   ./install.sh --bolt-web-dir /home/joeri/dev/BoltSDRv2/bolt-web/dist
#
# Installeert bolt-web als BoltCore submap naast de AnanCore executable.
# AnanCore blijft volledig onaangeroerd.

set -euo pipefail

# ── Helpers ──────────────────────────────────────────────────────────────────
ok()   { echo "  ✓  $*"; }
warn() { echo "  !  $*"; }
err()  { echo "  ✗  $*" >&2; exit 1; }
step() { echo "  →  $*"; }

# ── Argumenten ───────────────────────────────────────────────────────────────
ANACORE_DIR=""
BOLT_WEB_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --anacore-dir)  ANACORE_DIR="$2";  shift 2 ;;
    --bolt-web-dir) BOLT_WEB_DIR="$2"; shift 2 ;;
    *) err "Onbekend argument: $1" ;;
  esac
done

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║          BoltCore — Installatie                  ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# ── AnanCore locatie ─────────────────────────────────────────────────────────
if [[ -z "$ANACORE_DIR" ]]; then
  # Zoek OpenhpsdrZeus naast of boven dit script
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [[ -f "$SCRIPT_DIR/../OpenhpsdrZeus" ]]; then
    ANACORE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
  elif [[ -f "$SCRIPT_DIR/OpenhpsdrZeus" ]]; then
    ANACORE_DIR="$SCRIPT_DIR"
  else
    read -rp "  AnanCore map (bevat OpenhpsdrZeus): " ANACORE_DIR
  fi
fi

[[ -f "$ANACORE_DIR/OpenhpsdrZeus" ]] || err "OpenhpsdrZeus niet gevonden in: $ANACORE_DIR"
ok "AnanCore gevonden: $ANACORE_DIR"

# ── bolt-web dist locatie ────────────────────────────────────────────────────
if [[ -z "$BOLT_WEB_DIR" ]]; then
  # Zoek automatisch op veelgebruikte plekken
  for candidate in \
    "$HOME/dev/BoltSDRv2/bolt-web/dist" \
    "/home/$(whoami)/dev/BoltSDRv2/bolt-web/dist" \
    "$(dirname "${BASH_SOURCE[0]}")/../bolt-web/dist"
  do
    if [[ -f "$candidate/index.html" ]]; then
      BOLT_WEB_DIR="$candidate"
      break
    fi
  done
fi

if [[ -z "$BOLT_WEB_DIR" ]]; then
  read -rp "  bolt-web dist map (bevat index.html): " BOLT_WEB_DIR
fi

[[ -f "$BOLT_WEB_DIR/index.html" ]] || err "index.html niet gevonden in: $BOLT_WEB_DIR"
ok "bolt-web dist gevonden: $BOLT_WEB_DIR"

# ── Doelmap ──────────────────────────────────────────────────────────────────
BOLTCORE_DIR="$ANACORE_DIR/BoltCore"
if [[ -d "$BOLTCORE_DIR" ]]; then
  warn "BoltCore map bestaat al: $BOLTCORE_DIR"
  read -rp "  Overschrijven? (ja/nee): " confirm
  [[ "$confirm" =~ ^(ja|j|yes|y)$ ]] || { echo "  Installatie afgebroken."; exit 0; }
fi
step "Doelmap: $BOLTCORE_DIR"

# ── Kopieer bolt-web ─────────────────────────────────────────────────────────
mkdir -p "$BOLTCORE_DIR/bolt-web"
step "bolt-web kopiëren..."
cp -r "$BOLT_WEB_DIR/." "$BOLTCORE_DIR/bolt-web/"
ok "bolt-web gekopieerd"

# ── Kopieer scripts vanuit dezelfde map als dit script ───────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for f in start-boltcore.sh start-anacore.sh uninstall.sh; do
  if [[ -f "$SCRIPT_DIR/$f" ]]; then
    cp "$SCRIPT_DIR/$f" "$BOLTCORE_DIR/"
    chmod +x "$BOLTCORE_DIR/$f"
    ok "Script: $f"
  fi
done
if [[ -f "$SCRIPT_DIR/README.md" ]]; then
  cp "$SCRIPT_DIR/README.md" "$BOLTCORE_DIR/"
fi

# ── Verificatie ──────────────────────────────────────────────────────────────
echo ""
echo "  Verificatie..."
[[ -f "$BOLTCORE_DIR/bolt-web/index.html" ]] && ok "bolt-web/index.html" || err "bolt-web/index.html ONTBREEKT"
[[ -f "$BOLTCORE_DIR/start-boltcore.sh"   ]] && ok "start-boltcore.sh"   || warn "start-boltcore.sh ontbreekt"
[[ -f "$BOLTCORE_DIR/start-anacore.sh"    ]] && ok "start-anacore.sh"    || warn "start-anacore.sh ontbreekt"
[[ -f "$BOLTCORE_DIR/uninstall.sh"        ]] && ok "uninstall.sh"        || warn "uninstall.sh ontbreekt"

# ── Klaar ─────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║  BoltCore geïnstalleerd!                         ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "  Locatie : $BOLTCORE_DIR"
echo ""
echo "  Starten:"
echo "    BoltCore  →  $BOLTCORE_DIR/start-boltcore.sh"
echo "    AnanCore  →  $BOLTCORE_DIR/start-anacore.sh"
echo ""
echo "  Verwijderen:"
echo "    $BOLTCORE_DIR/uninstall.sh"
echo ""
echo "  Let op: start nooit BoltCore en AnanCore tegelijk —"
echo "  ze gebruiken dezelfde poorten (6060/6443)."
echo ""

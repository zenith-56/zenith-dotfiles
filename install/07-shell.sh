#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Shell Setup
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

FISH_PATH=$(command -v fish 2>/dev/null) || true

if [ -z "$FISH_PATH" ]; then
    err "Fish not found. Install fish first."
fi

if [ ! -f /etc/shells ]; then
    err "/etc/shells not found"
fi

if ! grep -q "$FISH_PATH" /etc/shells; then
    echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null || \
        warn "Could not add fish to /etc/shells"
fi

chsh -s "$FISH_PATH" || warn "Could not set default shell"
log "Fish set as default shell"

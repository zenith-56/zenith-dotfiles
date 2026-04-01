#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Shell Setup
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

get_fish() {
    which fish 2>/dev/null
}

FISH_PATH=$(get_fish)

if [ -n "$FISH_PATH" ]; then
    if ! grep -q "$FISH_PATH" /etc/shells; then
        echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi
    chsh -s "$FISH_PATH" || warn "Could not set default shell"
    log "Fish set as default shell"
else
    err "Fish not found"
fi

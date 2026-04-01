#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Fonts
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

info "Updating font cache..."
fc-cache -fv >/dev/null 2>&1 || true
log "Font cache updated"

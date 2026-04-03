#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Fonts
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

info "Updating font cache..."
if has_cmd fc-cache; then
    fc-cache -fv >/dev/null 2>&1 || true
    log "Font cache updated"
else
    warn "fc-cache not found, skipping font cache update"
fi

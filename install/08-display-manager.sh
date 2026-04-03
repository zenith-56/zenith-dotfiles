#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Display Manager
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

if ! has_cmd gum; then
    err "gum not found"
fi

if ! has_cmd systemctl; then
    err "systemctl not found"
fi

if gum confirm "Enable SDDM?"; then
    sudo systemctl enable sddm.service || warn "Failed to enable SDDM"
    log "SDDM enabled for next boot"
else
    info "Skipping SDDM"
fi

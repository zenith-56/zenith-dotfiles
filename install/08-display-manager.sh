#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Display Manager
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

if gum confirm "Enable SDDM?"; then
    sudo systemctl enable sddm.service || warn "Failed to enable SDDM"
    log "SDDM enabled for next boot"
else
    info "Skipping SDDM"
fi

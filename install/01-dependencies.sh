#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Dependencies
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

cleanup_yay() {
    rm -rf /tmp/yay 2>/dev/null || true
}

trap cleanup_yay EXIT INT TERM

# Install yay first (AUR helper)
if ! has_cmd yay; then
    info "Installing yay (AUR helper)..."

    if ! has_cmd git; then
        err "git not found. Install base-devel first."
    fi

    if ! has_cmd make; then
        err "make not found. Install base-devel first."
    fi

    cd /tmp
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git || err "Failed to clone yay"
    cd yay && makepkg -si --noconfirm || err "Failed to build yay"
    cd -
fi

info "Installing pacman packages..."
if ! sudo pacman -S --noconfirm --needed "${PACMAN_PACKAGES[@]}" &>/dev/null; then
    warn "Some pacman packages failed to install"
else
    log "All pacman packages installed"
fi

info "Installing AUR packages..."
if ! yay -S --noconfirm --needed "${AUR_PACKAGES[@]}" &>/dev/null; then
    warn "Some AUR packages failed to install"
else
    log "All AUR packages installed"
fi

log "Dependencies installed"

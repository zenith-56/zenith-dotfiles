#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Dependencies
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Install yay first (AUR helper)
if ! has_cmd yay; then
    info "Installing yay (AUR helper)..."
    cd /tmp
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm || err "Failed to build yay"
    cd -
fi

info "Installing pacman packages..."
sudo pacman -Syu --noconfirm --needed "${PACMAN_PACKAGES[@]}" || \
    err "Pacman failed"

info "Installing AUR packages..."
yay -S --noconfirm --needed "${AUR_PACKAGES[@]}" || \
    warn "Some AUR packages failed"

log "Dependencies installed"

#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Dependencies
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Install paru first (AUR helper)
if ! has_cmd paru; then
    info "Installing paru (AUR helper)..."
    cd /tmp
    rm -rf paru
    git clone https://aur.archlinux.org/paru.git
    cd paru && makepkg -si --noconfirm || err "Failed to build paru"
    cd -
fi

info "Installing pacman packages..."
sudo pacman -Syu --noconfirm --needed "${PACMAN_PACKAGES[@]}" || \
    err "Pacman failed"

info "Installing AUR packages..."
paru -S --noconfirm --needed "${AUR_PACKAGES[@]}" || \
    warn "Some AUR packages failed"

log "Dependencies installed"

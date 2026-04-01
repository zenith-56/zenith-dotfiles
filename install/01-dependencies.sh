#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Dependencies
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Install yay first (AUR helper)
if ! has_cmd yay; then
    info "Installing yay (AUR helper)..."
    cd /tmp
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git || err "Failed to clone yay"
    cd yay && makepkg -si --noconfirm || err "Failed to build yay"
    cd -
fi

info "Installing pacman packages..."
FAILED=0
for pkg in "${PACMAN_PACKAGES[@]}"; do
    if ! sudo pacman -S --noconfirm --needed "$pkg" &>/dev/null; then
        warn "Failed to install: $pkg"
        FAILED=$((FAILED + 1))
    fi
done
if [ "$FAILED" -gt 0 ]; then
    warn "$FAILED pacman package(s) failed to install"
else
    log "All pacman packages installed"
fi

info "Installing AUR packages..."
FAILED=0
for pkg in "${AUR_PACKAGES[@]}"; do
    if ! yay -S --noconfirm --needed "$pkg" &>/dev/null; then
        warn "Failed to install: $pkg"
        FAILED=$((FAILED + 1))
    fi
done
if [ "$FAILED" -gt 0 ]; then
    warn "$FAILED AUR package(s) failed to install"
else
    log "All AUR packages installed"
fi

log "Dependencies installed"

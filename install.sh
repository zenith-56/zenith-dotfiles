#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Dotfiles Installer
# =============================================================================
# Description : Main entry point. Clones repo and runs install locally.
# Author      : Maximocruz (@zenith-56)
# License     : MIT
# =============================================================================

set -e

REPO_URL="https://github.com/zenith-56/zenith-dotfiles.git"
DOTFILES_DIR="$HOME/zenith-dotfiles"

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/install/common.sh"

# Install base dependencies
install_deps() {
    info "Installing base dependencies..."

    if command -v sudo &>/dev/null; then
        sudo pacman -Sy --noconfirm git base-devel gum curl || {
            warn "Some packages failed to install"
        }
    else
        warn "sudo not found, please install manually: git, base-devel, gum"
    fi
}

# Install gum from AUR if not in repos
install_gum() {
    if ! command -v gum &>/dev/null; then
        info "Installing gum from AUR..."
        if ! command -v make &>/dev/null; then
            warn "make not found, installing base-devel..."
            sudo pacman -Sy --noconfirm base-devel || err "Failed to install base-devel"
        fi
        cd /tmp
        rm -rf gum
        git clone https://aur.archlinux.org/gum.git 2>/dev/null || {
            warn "Failed to clone gum AUR"
            return 1
        }
        cd gum && makepkg -si --noconfirm || warn "Failed to build gum"
        cd -
    fi
}

# Check and install deps
command -v git &>/dev/null || install_deps
command -v gum &>/dev/null || install_gum

# Clone or update repo
if [ -d "$DOTFILES_DIR/.git" ]; then
    info "Updating existing repo..."
    cd "$DOTFILES_DIR"
    git pull --ff-only 2>/dev/null || warn "Could not pull, using existing files"
else
    if [ -d "$DOTFILES_DIR" ]; then
        warn "Removing old directory..."
        rm -rf "$DOTFILES_DIR"
    fi
    info "Cloning Zenith-Dotfiles..."
    git clone "$REPO_URL" "$DOTFILES_DIR" || err "Failed to clone repo"
    cd "$DOTFILES_DIR"
fi

# Verify scripts are executable (repo should have them, but double-check)
verify_executable() {
    local missing=()
    for file in install/*.sh .local/bin/* .config/rofi/scripts/*.sh .config/waybar/scripts/*.sh; do
        [ -f "$file" ] && [ ! -x "$file" ] && missing+=("$file")
    done
    if [ ${#missing[@]} -gt 0 ]; then
        info "Setting executable permissions..."
        chmod +x install/*.sh .local/bin/* .config/rofi/scripts/*.sh .config/waybar/scripts/*.sh
    fi
}

verify_executable

# Run installer
log "Starting installation..."
exec ./install/run.sh "$@"

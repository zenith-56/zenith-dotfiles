#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Dotfiles Installer
# =============================================================================
# Description : Main entry point. Clones repo and runs install locally.
# Author      : Maximocruz (@zenith-56)
# License     : MIT
# =============================================================================

set -euo pipefail

REPO_URL="https://github.com/zenith-56/zenith-dotfiles.git"
DOTFILES_DIR="$HOME/zenith-dotfiles"

# ── Colors ────────────────────────────────────────────────────────────────────
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export RED='\033[0;31m'
export CYAN='\033[0;36m'
export RESET='\033[0m'

# ── Flags ─────────────────────────────────────────────────────────────────────
VERBOSE=false
FORCE=false

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
  -v, --verbose    Enable verbose output
  -f, --force      Skip confirmations and proceed automatically
  -h, --help       Show this help message
EOF
    exit 0
}

for arg in "$@"; do
    case "$arg" in
        -v|--verbose) VERBOSE=true ;;
        -f|--force) FORCE=true ;;
        -h|--help) usage ;;
    esac
done

# ── Logging Functions ─────────────────────────────────────────────────────────
log()  { echo -e "${GREEN}[✓]${RESET} $1"; }
warn() { echo -e "${YELLOW}[!]${RESET} $1"; }
err()  { echo -e "${RED}[✗]${RESET} $1"; exit 1; }
info() { echo -e "${CYAN}[i]${RESET} $1"; }
debug() { [ "$VERBOSE" = true ] && echo -e "${YELLOW}[DEBUG]${RESET} $1" || true; }

# ── Install base dependencies ─────────────────────────────────────────────────
install_deps() {
    info "Installing base dependencies..."
    debug "Running: sudo pacman -Sy --noconfirm git base-devel gum curl"
    if command -v sudo &>/dev/null; then
        sudo pacman -Sy --noconfirm git base-devel gum curl || {
            warn "Some packages failed to install"
        }
    else
        warn "sudo not found, please install manually: git, base-devel, gum"
    fi
}

install_gum() {
    if ! command -v gum &>/dev/null; then
        info "Installing gum from AUR..."
        debug "Building gum from AUR..."
        if ! command -v make &>/dev/null; then
            warn "make not found, installing base-devel..."
            debug "Running: sudo pacman -Sy --noconfirm base-devel"
            sudo pacman -Sy --noconfirm base-devel || err "Failed to install base-devel"
        fi
        pushd /tmp >/dev/null
        rm -rf gum
        debug "Cloning gum from AUR..."
        git clone https://aur.archlinux.org/gum.git 2>/dev/null || {
            warn "Failed to clone gum AUR"
            popd >/dev/null || true
            return 1
        }
        cd gum && makepkg -si --noconfirm || warn "Failed to build gum"
        popd >/dev/null || true
    fi
}

# ── Check and install deps ────────────────────────────────────────────────────
command -v git &>/dev/null || install_deps
command -v gum &>/dev/null || install_gum

# ── Clone or update repo ──────────────────────────────────────────────────────
if [ -d "$DOTFILES_DIR/.git" ]; then
    info "Updating existing repo..."
    debug "Changing to: $DOTFILES_DIR"
    cd "$DOTFILES_DIR"
    debug "Running: git pull --ff-only"
    git pull --ff-only 2>/dev/null || warn "Could not pull, using existing files"
else
    if [ -d "$DOTFILES_DIR" ]; then
        warn "Removing old directory..."
        debug "Running: rm -rf $DOTFILES_DIR"
        rm -rf "$DOTFILES_DIR"
    fi
    info "Cloning Zenith-Dotfiles..."
    debug "Running: git clone $REPO_URL $DOTFILES_DIR"
    git clone "$REPO_URL" "$DOTFILES_DIR" || err "Failed to clone repo"
    cd "$DOTFILES_DIR"
fi

# ── Source common functions (now that repo exists on disk) ────────────────────
source "$DOTFILES_DIR/install/common.sh"

# ── Verify scripts are executable ─────────────────────────────────────────────
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

# ── Run installer ─────────────────────────────────────────────────────────────
log "Starting installation..."
exec ./install/run.sh "$@"

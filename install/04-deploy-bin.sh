#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Deploy Bin Scripts
# =============================================================================

set -e

log() { echo -e "\033[0;32m[✓]\033[0m $1"; }
info() { echo -e "\033[0;36m[i]\033[0m $1"; }

DOTFILES_DIR="$HOME/zenith-dotfiles"
mkdir -p "$HOME/.local/bin"

cp -f "$DOTFILES_DIR"/.local/bin/* "$HOME/.local/bin/"

log "Bin scripts deployed to ~/.local/bin"

# Make scripts executable
chmod +x "$HOME/.local/bin/"* 2>/dev/null || true
log "Bin scripts permissions set"

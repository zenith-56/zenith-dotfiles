#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Deploy Bin Scripts
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

DOTFILES_DIR="$(get_dotfiles_dir)"
mkdir -p "$HOME/.local/bin"

cp -f "$DOTFILES_DIR"/.local/bin/* "$HOME/.local/bin/"

log "Bin scripts deployed to ~/.local/bin"

# Make scripts executable
chmod +x "$HOME/.local/bin/"* 2>/dev/null || true
log "Bin scripts permissions set"

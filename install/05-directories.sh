#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Directories
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

DIRS=(
    "$HOME/Pictures/Wallpapers"
    "$HOME/Pictures/Screenshots"
    "$HOME/Downloads"
    "$HOME/Videos"
    "$HOME/Documents"
)

for dir in "${DIRS[@]}"; do
    mkdir -p "$dir"
done

log "Directories created"

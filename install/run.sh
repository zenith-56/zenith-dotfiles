#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Main Runner
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$SCRIPT_DIR"

# Source common functions
source "$INSTALL_DIR/common.sh"

if ! has_cmd gum; then
    err "gum not installed. Run: sudo pacman -S gum"
fi

source_include() {
    local script="$INSTALL_DIR/$1.sh"
    if [ -f "$script" ]; then
        source "$script"
    else
        err "Missing script: $script"
    fi
}

run_step() {
    local name="$1"
    echo ""
    gum style --foreground 212 --bold "  ⟩ $name"
    echo ""
    source_include "$name"
}

[ "$(id -u)" -eq 0 ] && err "Do not run as root"

# Offer backup before installation
backup_configs() {
    BACKUP_DIR="$HOME/.config.bak-$(date +%Y%m%d-%H%M%S)"
    if gum confirm "Backup existing configs before installing?"; then
        mkdir -p "$BACKUP_DIR/.config"
        mkdir -p "$BACKUP_DIR/.local/share"
        
        BACKED=0
        for cfg in "${CONFIGS[@]}"; do
            if [ -d "$HOME/.config/$cfg" ]; then
                cp -r "$HOME/.config/$cfg" "$BACKUP_DIR/.config/"
                BACKED=$((BACKED + 1))
            fi
        done
        
        [ -d "$HOME/.local/share/dark-mode.d" ] && \
            cp -r "$HOME/.local/share/dark-mode.d" "$BACKUP_DIR/.local/share/" && \
            BACKED=$((BACKED + 1))
        [ -d "$HOME/.local/share/light-mode.d" ] && \
            cp -r "$HOME/.local/share/light-mode.d" "$BACKUP_DIR/.local/share/" && \
            BACKED=$((BACKED + 1))
        
        log "Backup: ${BACKED} dirs saved to ${BACKUP_DIR}"
    else
        warn "Skipping backup..."
    fi
}

backup_configs

if ! gum confirm "Start Zenith-Dotfiles installation?"; then
    exit 0
fi

run_step 00-banner
run_step 01-dependencies
run_step 02-services
run_step 03-deploy-configs
run_step 04-deploy-bin
run_step 05-directories
run_step 06-fonts
run_step 07-shell
run_step 08-display-manager

echo ""
gum style --foreground 212 --border-foreground 212 --border rounded \
    --align center --width 50 --padding "1 2" \
    "Installation complete!"
echo ""

gum confirm "Reboot now?" && sudo reboot

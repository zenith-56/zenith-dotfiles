#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Uninstaller
# =============================================================================
# Description : Safely removes Zenith-Dotfiles configurations and optionally
#               restores backup or resets to defaults.
# Author      : Maximocruz (@zenith-56)
# License     : MIT
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/install/common.sh"

BACKUP_DIR="$HOME/.config.bak-$(date +%Y%m%d-%H%M%S)"
DOTFILES_DIR="$HOME/zenith-dotfiles"

# ── Banner ────────────────────────────────────────────────────────────────────
echo ""
gum style --foreground 212 --border-foreground 212 --border rounded \
    --align center --width 50 --margin "1 2" --padding "1 2" \
    "Zenith-Dotfiles Uninstaller" \
    "" \
    "Remove configurations safely"
echo ""

# ── Confirmation ──────────────────────────────────────────────────────────────
if ! gum confirm "This will remove Zenith-Dotfiles configurations. Continue?"; then
    info "Aborted"
    exit 0
fi

# ── Backup Option ─────────────────────────────────────────────────────────────
echo ""
BACKUP_RESULT=$(do_backup_configs)

# ── Selective Removal ─────────────────────────────────────────────────────────
echo ""
gum style --foreground 212 --bold "  Select configs to remove"
echo ""

SELECTED=$(gum choose --no-limit --cursor.foreground 212 --selected.foreground 212 \
    "All configs" "Only dotfiles configs" "Bin scripts" "Darkman scripts" "Cancel")

case "$SELECTED" in
    "All configs")
        info "Removing all Zenith-Dotfiles configurations..."

        # Remove configs
        for cfg in "${CONFIGS[@]}"; do
            if [ -d "$HOME/.config/$cfg" ]; then
                rm -rf "$HOME/.config/$cfg"
                log "Removed: .config/$cfg"
            fi
        done

        # Remove bin scripts
        if [ -d "$HOME/.local/bin" ]; then
            rm -f "$HOME/.local/bin/zenith-"*
            log "Removed: zenith-* bin scripts"
        fi

        # Remove darkman scripts
        rm -rf "$HOME/.local/share/dark-mode.d"
        rm -rf "$HOME/.local/share/light-mode.d"
        log "Removed: darkman scripts"

        # Remove dotfiles repo
        if gum confirm "Remove zenith-dotfiles repo from ~/?"; then
            rm -rf "$DOTFILES_DIR"
            log "Removed: $DOTFILES_DIR"
        fi
        ;;

    "Only dotfiles configs")
        info "Removing only config directories..."
        for cfg in "${CONFIGS[@]}"; do
            if [ -d "$HOME/.config/$cfg" ]; then
                rm -rf "$HOME/.config/$cfg"
                log "Removed: .config/$cfg"
            fi
        done
        ;;

    "Bin scripts")
        info "Removing bin scripts..."
        if [ -d "$HOME/.local/bin" ]; then
            rm -f "$HOME/.local/bin/zenith-"*
            log "Removed: zenith-* bin scripts"
        fi
        ;;

    "Darkman scripts")
        info "Removing darkman scripts..."
        rm -rf "$HOME/.local/share/dark-mode.d"
        rm -rf "$HOME/.local/share/light-mode.d"
        log "Removed: darkman scripts"
        ;;

    "Cancel"|"")
        info "Aborted"
        exit 0
        ;;
esac

# ── Reset Fish Shell ──────────────────────────────────────────────────────────
echo ""
if gum confirm "Reset fish shell to bash?"; then
    if grep -q "$(which fish)" /etc/shells 2>/dev/null; then
        chsh -s "$(which bash)" 2>/dev/null || warn "Could not change shell"
        log "Default shell reset to bash"
    fi
fi

# ── Disable Services ──────────────────────────────────────────────────────────
echo ""
if gum confirm "Disable systemd services enabled by Zenith?"; then
    for svc in "${SYSTEM_SERVICES[@]}"; do
        if systemctl is-enabled "${svc}.service" &>/dev/null; then
            sudo systemctl disable --now "${svc}.service" 2>/dev/null || true
            log "Disabled: $svc"
        fi
    done

    if systemctl --user is-enabled darkman.service &>/dev/null; then
        systemctl --user disable --now darkman.service 2>/dev/null || true
        log "Disabled: darkman (user service)"
    fi
fi

# ── Remove SDDM ───────────────────────────────────────────────────────────────
echo ""
if gum confirm "Disable SDDM display manager?"; then
    sudo systemctl disable sddm.service 2>/dev/null || true
    log "SDDM disabled"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
gum style --foreground 212 --border-foreground 212 --border rounded \
    --align center --width 50 --margin "1 2" --padding "1 2" \
    "Uninstall complete!" \
    "" \
    "You may need to reboot for changes to take effect"
echo ""

if [ -d "$BACKUP_DIR" ]; then
    info "Backup location: ${BACKUP_DIR}"
fi

info "To reinstall: bash <(curl -sSL https://raw.githubusercontent.com/zenith-56/zenith-dotfiles/main/install.sh)"
echo ""

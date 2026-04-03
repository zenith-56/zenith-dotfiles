#!/usr/bin/env bash
# =============================================================================
# Rofi Main Launcher Menu
# =============================================================================
# Description : Main menu launcher for Rofi.
#               Provides quick access to Applications, Network, Theming,
#               Package Management, and Power Menu.
# =============================================================================

set -euo pipefail

source "$(dirname "$0")/common.sh"

main_menu() {
    printf ' 󰀻  Applications\n 󰢩  Network\n 󰏗  Theming\n 󰏗  Package Management\n 󰐥  Power Menu\n'
}

while true; do
    chosen=$(main_menu | rofi_run "theme.rasi" -placeholder "Search...") || exit 0

    case "$chosen" in
        *Applications) bash "$ROFI_SCRIPTS_DIR/app-launcher.sh" || true ;;
        *Network) bash "$ROFI_SCRIPTS_DIR/network-menu.sh" || true ;;
        *Theming) bash "$ROFI_SCRIPTS_DIR/theming-menu.sh" || true ;;
        *Package\ Management) bash "$ROFI_SCRIPTS_DIR/package-manager.sh" || true ;;
        *Power\ Menu) bash "$ROFI_SCRIPTS_DIR/power-menu.sh" || true ;;
        "") exit 0 ;;
    esac
done

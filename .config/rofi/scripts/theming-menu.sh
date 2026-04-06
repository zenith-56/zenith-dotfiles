#!/usr/bin/env bash
# =============================================================================
# Rofi Theming Menu
# =============================================================================
# Description : Main aesthetic controller for the Zenith suite, managing
#               wallpaper selection and global color scheme transitions.
# =============================================================================

set -euo pipefail

source "$(dirname "$0")/common.sh"

__menu_state="main"

while true; do
    case "$__menu_state" in
        main)
            selection=$(rofi_menu "theme.rasi" " 󰸉  Wallpapers\n 󰏘  Change Dark/Light\n 󰜺  Back" "Theming...") || exit 0
            case "$selection" in
                *Wallpapers) __menu_state="wallpapers" ;;
                *Change\ Dark/Light) __menu_state="theme" ;;
                *) exit 0 ;;
            esac
            ;;
        wallpapers)
            bash "$ROFI_SCRIPTS_DIR/wall-selector.sh" || { __menu_state="main"; continue; }
            exit 0
            ;;
        theme)
            bash "$ROFI_SCRIPTS_DIR/theme-menu.sh" || { __menu_state="main"; continue; }
            exit 0
            ;;
    esac
done

#!/usr/bin/env bash
# =============================================================================
# Rofi Theming Menu
# =============================================================================
# Description : Main aesthetic controller for the Zenith suite, managing
#               wallpaper selection and global color scheme transitions.
# =============================================================================

set -euo pipefail

source "$(dirname "$0")/common.sh"

while true; do
    selection=$(rofi_menu "theme.rasi" " 󰸉  Wallpapers\n 󰏘  Change Dark/Light\n 󰜺  Back" "Theming...") || exit 0

    case "$selection" in
        *Wallpapers)
            bash "$ROFI_SCRIPTS_DIR/wall-selector.sh" || true
            ;;
        *Change\ Dark/Light)
            bash "$ROFI_SCRIPTS_DIR/theme-menu.sh" || true
            ;;
        *) exit 0 ;;
    esac
done

#!/usr/bin/env bash
# =============================================================================
# Rofi Theming Menu
# =============================================================================
# Description : Main aesthetic controller for the Zenith suite, managing
#               wallpaper selection and global color scheme transitions.
# =============================================================================

source "$(dirname "$0")/common.sh"

selection=$(rofi_menu "theme.rasi" " 󰸉  Wallpapers\n 󰏘  Change Dark/Light\n 󰜺  Back" "Theming...") || \
    exec bash "$ROFI_SCRIPTS_DIR/launcher.sh"

case "$selection" in
    *Wallpapers)
        bash "$ROFI_SCRIPTS_DIR/wall-selector.sh"
        ;;
    *Change\ Dark/Light)
        bash "$ROFI_SCRIPTS_DIR/theme-menu.sh"
        ;;
    *Back)
        bash "$ROFI_SCRIPTS_DIR/launcher.sh"
        ;;
esac

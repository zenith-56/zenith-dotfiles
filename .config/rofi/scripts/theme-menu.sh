#!/usr/bin/env bash
# =============================================================================
# Rofi Theme Menu
# =============================================================================
# Description : Global theme switcher with active state detection and
#               automated hot-reloading for the Zenith environment.
# =============================================================================

source "$(dirname "$0")/common.sh"

current=$("$ZENITH_BIN/zenith-theme-get")

if [[ "$current" == "dark" ]]; then
    menu_text=' 󰔎  Light Mode\n 󰔎  Dark Mode  [active]'
else
    menu_text=' 󰔎  Light Mode  [active]\n 󰔎  Dark Mode'
fi

selection=$(rofi_menu "tokyo-night.rasi" "$menu_text" "Theme...") || \
    exec bash "$ROFI_SCRIPTS_DIR/theming-menu.sh"

case "$selection" in
    *Light\ Mode*)
        "$ZENITH_BIN/zenith-theme-set" light
        sleep 0.5
        "$ZENITH_BIN/zenith-restart-all"
        ;;
    *Dark\ Mode*)
        "$ZENITH_BIN/zenith-theme-set" dark
        sleep 0.5
        "$ZENITH_BIN/zenith-restart-all"
        ;;
esac

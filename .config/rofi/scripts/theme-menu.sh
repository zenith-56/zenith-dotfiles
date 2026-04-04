#!/usr/bin/env bash
# =============================================================================
# Rofi Theme Menu
# =============================================================================
# Description : Theme mode selector (dark/light) with Matugen integration.
# =============================================================================

set -euo pipefail

source "$(dirname "$0")/common.sh"

while true; do
    current=$("$ZENITH_BIN/zenith-theme" get)

    if [[ "$current" == "dark" ]]; then
        menu_text=' 󰔎  Light Mode\n 󰔎  Dark Mode  [active]'
    else
        menu_text=' 󰔎  Light Mode  [active]\n 󰔎  Dark Mode'
    fi

    selection=$(rofi_menu "theme.rasi" "$menu_text" "Theme...") || exit 0

    case "$selection" in
        *Light\ Mode*)
            mode="light"
            ;;
        *Dark\ Mode*)
            mode="dark"
            ;;
        *) continue ;;
    esac

    "$ZENITH_BIN/zenith-theme" set "$mode"

    if [[ "$mode" == "dark" ]]; then
        rofi_notify "Theme Changed" "Switched to Dark Mode" "preferences-desktop-theme"
    else
        rofi_notify "Theme Changed" "Switched to Light Mode" "preferences-desktop-theme"
    fi
done

#!/usr/bin/env bash
# =============================================================================
# Rofi Theme Menu
# =============================================================================
# Description : Theme mode selector (dark/light) with Matugen integration.
# =============================================================================

set -euo pipefail

source "$(dirname "$0")/common.sh"

run_matugen() {
    local wallpaper="$1"
    local mode="$2"

    matugen image "$wallpaper" --prefer value -m "$mode" && return 0
    matugen image "$wallpaper" --prefer most -m "$mode" && return 0
    matugen image "$wallpaper" --prefer vibrant -m "$mode" && return 0
    return 1
}

restart_services() {
    "$ZENITH_BIN/zenith-restart" all
}

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

    wallpaper_path="$HOME/.config/rofi/images/current_wallpaper.png"
    [ -L "$wallpaper_path" ] && wallpaper_path=$(readlink -f "$wallpaper_path")
    if [ -f "$wallpaper_path" ]; then
        run_matugen "$wallpaper_path" "$mode"
    fi

    "$ZENITH_BIN/zenith-theme" sync
    restart_services

    if [[ "$mode" == "dark" ]]; then
        notify-send "Theme Changed" "Switched to Dark Mode" --icon="preferences-desktop-theme"
    else
        notify-send "Theme Changed" "Switched to Light Mode" --icon="preferences-desktop-theme"
    fi
done

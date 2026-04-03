#!/usr/bin/env bash
# =============================================================================
# Rofi Theme Menu
# =============================================================================

source "$(dirname "$0")/common.sh"

run_matugen() {
    local wallpaper="$1"
    local mode="$2"
    
    matugen image "$wallpaper" --prefer value -m "$mode" && return 0
    matugen image "$wallpaper" --prefer most -m "$mode" && return 0
    matugen image "$wallpaper" --prefer vibrant -m "$mode" && return 0
    return 1
}

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
        
        wallpaper_path="$HOME/.config/rofi/images/current_wallpaper.png"
        [ -L "$wallpaper_path" ] && wallpaper_path=$(readlink -f "$wallpaper_path")
        [ -f "$wallpaper_path" ] && run_matugen "$wallpaper_path" light
        
        "$ZENITH_BIN/zenith-theme-sync"
        "$ZENITH_BIN/zenith-restart-all"
        ;;
    *Dark\ Mode*)
        "$ZENITH_BIN/zenith-theme-set" dark
        
        wallpaper_path="$HOME/.config/rofi/images/current_wallpaper.png"
        [ -L "$wallpaper_path" ] && wallpaper_path=$(readlink -f "$wallpaper_path")
        [ -f "$wallpaper_path" ] && run_matugen "$wallpaper_path" dark
        
        "$ZENITH_BIN/zenith-theme-sync"
        "$ZENITH_BIN/zenith-restart-all"
        ;;
esac
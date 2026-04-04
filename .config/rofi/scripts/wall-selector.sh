#!/usr/bin/env bash
# =============================================================================
# Rofi Wallpaper Selector — Gallery Mode
# =============================================================================
# Description : Advanced wallpaper gallery and dynamic theming engine using
#               Matugen for automated color palette synchronization.
# =============================================================================

set -uo pipefail

source "$(dirname "$0")/common.sh"

WALL_DIR="$HOME/Pictures/Wallpapers"
CURRENT_LINK="$HOME/.config/rofi/images/current_wallpaper.png"
WAYBAR_DIR="$HOME/.config/waybar"

mkdir -p "$(dirname "$CURRENT_LINK")"

run_matugen() {
    local wallpaper="$1"
    local mode="$2"
    local output

    output=$(matugen image "$wallpaper" --source-color-index 0 -m "$mode" 2>&1) && return 0

    echo "Matugen errors: $output"
    return 1
}

mapfile -d '' pics < <(find "$WALL_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -print0 2>/dev/null | sort -z)

if (( ${#pics[@]} == 0 )); then
    rofi_notify "Wallpapers" "No wallpapers found in $WALL_DIR" "error"
    exit 1
fi

menu_items=""
for pic in "${pics[@]}"; do
    filename=$(basename "$pic")
    menu_items+="${filename}\x00icon\x1f${pic}\n"
done

tmpfile=$(mktemp)
printf '%b' "$menu_items" | rofi -dmenu -i -p "Wallpapers" -theme "$ROFI_THEME_DIR/wallpaper-gallery.rasi" > "$tmpfile"
rc=$?
selection=$(cat "$tmpfile")
rm -f "$tmpfile"

if (( rc == 1 )); then
    exec bash "$ROFI_SCRIPTS_DIR/theming-menu.sh"
fi

if [[ -n "$selection" ]]; then
    FULL_PATH="$WALL_DIR/$selection"
    [[ -f "$FULL_PATH" ]] || exit 1

    awww img "$FULL_PATH" --transition-type random --transition-step 120 --transition-fps 120
    ln -sf "$FULL_PATH" "$CURRENT_LINK"

    sleep 2

    current_mode=$("$ZENITH_BIN/zenith-theme" get)
    run_matugen "$FULL_PATH" "$current_mode"

    if [ -f "$WAYBAR_DIR/colors.css" ]; then
        for preset_dir in "$WAYBAR_DIR"/presets/*/; do
            [ -d "$preset_dir" ] || continue
            cp -f "$WAYBAR_DIR/colors.css" "${preset_dir}colors.css" 2>/dev/null || true
        done
    fi

    "$ZENITH_BIN/zenith-restart" all

    rofi_notify "Wallpaper" "Wallpaper & Colors applied." "$FULL_PATH"
fi

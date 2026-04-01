#!/usr/bin/env bash
# =============================================================================
# Rofi Wallpaper Selector — Gallery Mode
# =============================================================================
# Description : Advanced wallpaper gallery and dynamic theming engine using
#               Matugen for automated color palette synchronization.
# =============================================================================

source "$(dirname "$0")/common.sh"

WALL_DIR="$HOME/Pictures/Wallpapers"
CURRENT_LINK="$HOME/.config/rofi/images/current_wallpaper.png"

mkdir -p "$(dirname "$CURRENT_LINK")"

mapfile -d '' pics < <(find "$WALL_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -print0 2>/dev/null | sort -z)

if (( ${#pics[@]} == 0 )); then
    notify-send "Wallpapers" "No wallpapers found in $WALL_DIR" -i error
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

    sleep 0.5

    current_mode=$("$ZENITH_BIN/zenith-theme-get")
    matugen image "$FULL_PATH" --prefer value -m "$current_mode"

    "$ZENITH_BIN/zenith-restart-all"

    notify-send "Wallpaper" "Colors updated" -i "$FULL_PATH"
fi

#!/usr/bin/env bash
# =============================================================================
# Rofi Theming Menu
# =============================================================================
# Description : Main aesthetic controller for the Zenith suite, managing
#               wallpaper selection and global color scheme transitions.
# =============================================================================

THEME="$HOME/.config/rofi/themes/tokyo-night.rasi"
SCRIPTS="$HOME/.config/rofi/scripts"

rofi_cmd() {
    rofi -dmenu -i -p "" -theme "$THEME" "$@"
}

tmpfile=$(mktemp)
printf ' 󰸉  Wallpapers\n 󰏘  Change Dark/Light\n 󰜺  Back\n' | rofi_cmd -placeholder "Theming..." > "$tmpfile"
rc=$?
chosen=$(cat "$tmpfile")
rm -f "$tmpfile"

if (( rc == 1 )); then
    exec bash "$SCRIPTS/launcher.sh"
fi

case "$chosen" in
    *Wallpapers)
        bash "$SCRIPTS/wall-selector.sh"
        exit 0
        ;;
    *Change\ Dark/Light)
        bash "$SCRIPTS/theme-menu.sh"
        exit 0
        ;;
    *Back)
        bash "$SCRIPTS/launcher.sh"
        exit 0
        ;;
    *)
        exit 0
        ;;
esac

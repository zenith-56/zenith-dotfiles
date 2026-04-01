#!/usr/bin/env bash
# =============================================================================
# Rofi Theme Menu
# =============================================================================
# Description : Global theme switcher with active state detection and
#               automated hot-reloading for the Zenith environment.
# =============================================================================

THEME="$HOME/.config/rofi/themes/tokyo-night.rasi"
SCRIPTS="$HOME/.config/rofi/scripts"
BIN="$HOME/.local/bin"

rofi_cmd() {
    rofi -dmenu -i -p "" -theme "$THEME" "$@"
}

current=$("$BIN/zenith-theme-get")

if [[ "$current" == "dark" ]]; then
    menu_text=' 󰔎  Light Mode\n 󰔎  Dark Mode  [active]\n'
else
    menu_text=' 󰔎  Light Mode  [active]\n 󰔎  Dark Mode\n'
fi

tmpfile=$(mktemp)
printf "$menu_text" | rofi_cmd -placeholder "Theme..." > "$tmpfile"
rc=$?
chosen=$(cat "$tmpfile")
rm -f "$tmpfile"

if (( rc == 1 )); then
    exec bash "$SCRIPTS/theming-menu.sh"
fi

case "$chosen" in
    *Light\ Mode*)
        "$BIN/zenith-theme-set" light
        sleep 0.5
        "$BIN/zenith-restart-all"
        ;;
    *Dark\ Mode*)
        "$BIN/zenith-theme-set" dark
        sleep 0.5
        "$BIN/zenith-restart-all"
        ;;
    *) exit 0 ;;
esac

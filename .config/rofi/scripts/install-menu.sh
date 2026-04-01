#!/usr/bin/env bash
# =============================================================================
# Rofi Install Menu
# =============================================================================
# Description : Interactive Rofi frontend for web app installations and
#               system maintenance scripts using Kitty and Fish shell.
# =============================================================================

THEME="$HOME/.config/rofi/themes/tokyo-night.rasi"
SCRIPTS="$HOME/.config/rofi/scripts"

rofi_cmd() {
    rofi -dmenu -i -p "" -theme "$THEME" "$@"
}

tmpfile=$(mktemp)
printf ' 󰏖  Packages\n 󰀱  Web App\n 󰜺  Back\n' | rofi_cmd -placeholder "Install..." > "$tmpfile"
rc=$?
chosen=$(cat "$tmpfile")
rm -f "$tmpfile"

if (( rc == 1 )); then
    exec bash "$SCRIPTS/launcher.sh"
fi

case "$chosen" in
    *Packages)
        kitty --class "zenith-installer" -e fish -c "zenith-pkg-add; echo -e '\nPress Enter to close...'; read" &
        exit 0
        ;;
    *Web\ App)
        kitty --class "zenith-installer" -e fish -c "zenith-webapp-install; echo -e '\nPress Enter to close...'; read" &
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

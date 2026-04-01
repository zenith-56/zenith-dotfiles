#!/usr/bin/env bash
# =============================================================================
# Rofi Uninstall Menu
# =============================================================================
# Description : Interactive application removal interface using Rofi and
#               Kitty terminal for safe and organized uninstallation.
# =============================================================================

THEME="$HOME/.config/rofi/themes/tokyo-night.rasi"
SCRIPTS="$HOME/.config/rofi/scripts"

rofi_cmd() {
    rofi -dmenu -i -p "" -theme "$THEME" "$@"
}

tmpfile=$(mktemp)
printf ' 󰏖  Packages\n 󰀱  Web App\n 󰜺  Back\n' | rofi_cmd -placeholder "Uninstall..." > "$tmpfile"
rc=$?
chosen=$(cat "$tmpfile")
rm -f "$tmpfile"

if (( rc == 1 )); then
    exec bash "$SCRIPTS/launcher.sh"
fi

case "$chosen" in
    *Packages)
        kitty --class "zenith-uninstaller" -e fish -c "zenith-pkg-remove; echo -e '\nPress Enter to close...'; read" &
        exit 0
        ;;
    *Web\ App)
        kitty --class "zenith-uninstaller" -e fish -c "zenith-webapp-uninstall; echo -e '\nPress Enter to close...'; read" &
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

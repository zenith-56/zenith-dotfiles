#!/usr/bin/env bash
# =============================================================================
# Rofi Power Menu
# =============================================================================
# Description : System power management interface with confirmation dialogs.
# =============================================================================
#
THEME="$HOME/.config/rofi/themes/tokyo-night.rasi"
SCRIPTS="$HOME/.config/rofi/scripts"
BIN="$HOME/.local/bin"

rofi_cmd() {
    rofi -dmenu -i -p "" -theme "$THEME" "$@"
}

tmpfile=$(mktemp)
printf ' ⏻  Shutdown\n 󰩎  Restart\n 󰌾  Lock\n 󰗽  Logout\n 󰜺  Back\n' | rofi_cmd -placeholder "Power..." > "$tmpfile"
rc=$?
chosen=$(cat "$tmpfile")
rm -f "$tmpfile"

if (( rc == 1 )); then
    exec bash "$SCRIPTS/launcher.sh"
fi

case "$chosen" in
    *Shutdown)
        confirm=$(printf 'Yes\nNo' | rofi_cmd -p "Shutdown?")
        [[ "$confirm" == "Yes" ]] && exec "$BIN/zenith-power-off"
        ;;
    *Restart)
        confirm=$(printf 'Yes\nNo' | rofi_cmd -p "Restart?")
        [[ "$confirm" == "Yes" ]] && exec "$BIN/zenith-reboot"
        ;;
    *Lock) exec "$BIN/zenith-lock" ;;
    *Logout) exec "$BIN/zenith-logout" ;;
    *Back)
        bash "$SCRIPTS/launcher.sh"
        exit 0
        ;;
esac

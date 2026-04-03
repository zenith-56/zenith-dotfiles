#!/usr/bin/env bash
# =============================================================================
# Rofi Main Launcher Menu
# =============================================================================
# Description : Main menu launcher for Rofi.
#               Provides quick access to Applications, Theming,
#               Install, Uninstall, and Power Menu.
# =============================================================================

THEME="$HOME/.config/rofi/themes/tokyo-night.rasi"
SCRIPTS="$HOME/.config/rofi/scripts"

rofi_cmd() {
    rofi -dmenu -i -p "" -theme "$THEME" "$@"
}

main_menu() {
    printf ' 󰀻  Applications\n 󰢩  Network\n 󰏗  Theming\n 󰇚  Install\n 󰁮  Uninstall\n 󰎙  Emoji Picker\n 󰐥  Power Menu\n'
}

while true; do
    chosen=$(main_menu | rofi_cmd -placeholder "Search...")

    case "$chosen" in
        *Applications) bash "$SCRIPTS/app-launcher.sh"; exit 0 ;;
        *Network) bash "$SCRIPTS/network-menu.sh"; exit 0 ;;
        *Theming) bash "$SCRIPTS/theming-menu.sh"; exit 0 ;;
        *Install) bash "$SCRIPTS/install-menu.sh"; exit 0 ;;
        *Uninstall) bash "$SCRIPTS/uninstall-menu.sh"; exit 0 ;;
        *Emoji\ Picker) bash "$SCRIPTS/emoji-picker.sh"; exit 0 ;;
        *Power\ Menu) bash "$SCRIPTS/power-menu.sh"; exit 0 ;;
        "") exit 0 ;;
    esac
done

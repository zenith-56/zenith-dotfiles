#!/usr/bin/env bash
# =============================================================================
# Rofi Power Menu
# =============================================================================
# Description : System power management interface with confirmation dialogs.
# =============================================================================

source "$(dirname "$0")/common.sh"

selection=$(rofi_menu "theme.rasi" " ⏻  Shutdown\n 󰩎  Restart\n 󰌾  Lock\n 󰗽  Logout\n 󰜺  Back" "Power...") || \
    exec bash "$ROFI_SCRIPTS_DIR/launcher.sh"

case "$selection" in
    *Shutdown)
        confirm=$(rofi_menu "theme.rasi" "Yes\nNo" "Shutdown?") || exit 0
        [[ "$confirm" == "Yes" ]] && exec "$ZENITH_BIN/zenith-power-off"
        ;;
    *Restart)
        confirm=$(rofi_menu "theme.rasi" "Yes\nNo" "Restart?") || exit 0
        [[ "$confirm" == "Yes" ]] && exec "$ZENITH_BIN/zenith-reboot"
        ;;
    *Lock) exec "$ZENITH_BIN/zenith-lock" ;;
    *Logout) exec "$ZENITH_BIN/zenith-logout" ;;
    *Back)
        bash "$ROFI_SCRIPTS_DIR/launcher.sh"
        ;;
esac

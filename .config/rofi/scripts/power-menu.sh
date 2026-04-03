#!/usr/bin/env bash
# =============================================================================
# Rofi Power Menu
# =============================================================================
# Description : System power management interface with confirmation dialogs.
# =============================================================================

set -euo pipefail

source "$(dirname "$0")/common.sh"

selection=$(rofi_menu "theme.rasi" " ⏻  Shutdown\n 󰩎  Restart\n 󰌾  Lock\n 󰗽  Logout\n 󰜺  Back" "Power...") || exit 0

case "$selection" in
    *Shutdown)
        confirm=$(rofi_menu "theme.rasi" "Yes\nNo" "Shutdown?") || exit 0
        [[ "$confirm" == "Yes" ]] && exec "$ZENITH_BIN/zenith-power" off
        ;;
    *Restart)
        confirm=$(rofi_menu "theme.rasi" "Yes\nNo" "Restart?") || exit 0
        [[ "$confirm" == "Yes" ]] && exec "$ZENITH_BIN/zenith-power" reboot
        ;;
    *Lock) exec "$ZENITH_BIN/zenith-power" lock ;;
    *Logout) exec "$ZENITH_BIN/zenith-power" logout ;;
esac

#!/usr/bin/env bash
# =============================================================================
# Rofi Power Menu
# =============================================================================
# Description : System power management interface with confirmation dialogs.
# =============================================================================

set -euo pipefail

source "$(dirname "$0")/common.sh"

while true; do
    selection=$(rofi_menu "theme.rasi" " ⏻  Shutdown\n 󰩎  Restart\n 󰌾  Lock\n 󰗽  Logout\n 󰜺  Back" "Power...") || exit 1

    case "$selection" in
        *Shutdown)
            confirm=$(rofi_menu "theme.rasi" "Yes\nNo" "Shutdown?") || continue
            [[ "$confirm" == "Yes" ]] && exec "$ZENITH_BIN/zenith-power" off
            ;;
        *Restart)
            confirm=$(rofi_menu "theme.rasi" "Yes\nNo" "Restart?") || continue
            [[ "$confirm" == "Yes" ]] && exec "$ZENITH_BIN/zenith-power" reboot
            ;;
        *Lock) exec "$ZENITH_BIN/zenith-power" lock ;;
        *Logout) exec "$ZENITH_BIN/zenith-power" logout ;;
        *) exit 1 ;;
    esac
done

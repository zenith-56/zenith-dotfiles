#!/usr/bin/env bash
# =============================================================================
# Rofi Network Configuration Menu
# =============================================================================
# Description : Network management interface - Firewall and DNS configuration.
# =============================================================================

set -euo pipefail

source "$(dirname "$0")/common.sh"

__menu_state="main"

while true; do
    case "$__menu_state" in
        main)
            selection=$(rofi_menu "theme.rasi" " 󰒄  Firewall\n 󰇖  DNS\n 󰜺  Back" "Network...") || exit 1
            case "$selection" in
                *Firewall) __menu_state="firewall" ;;
                *DNS) __menu_state="dns" ;;
                *) exit 1 ;;
            esac
            ;;
        firewall)
            status=$("$ZENITH_BIN/zenith-firewall" status 2>/dev/null) || status="unknown"
            if [ "$status" = "active" ]; then
                status_icon="󰦗 Active"
            else
                status_icon="󰦘 Inactive"
            fi
            fw_selection=$(rofi_menu "theme.rasi" " 󰒄  Toggle Firewall ($status_icon)\n 󱓻  Custom Rules\n 󰜺  Back" "Firewall...") || { __menu_state="main"; continue; }
            case "$fw_selection" in
                *Toggle*)
                    confirm=$(rofi_menu "theme.rasi" "Yes\nNo" "Toggle firewall?") || { __menu_state="firewall"; continue; }
                    if [[ "$confirm" == "Yes" ]]; then
                        kitty --class "zenith-network" -e fish -c "$ZENITH_BIN/zenith-firewall toggle; echo; read -P 'Press Enter to continue...'"
                    fi
                    exit 0
                    ;;
                *Custom*)
                    kitty --class "zenith-network" -e fish -c "
                        set rule (read -P \"Rule (e.g. allow 22/tcp): \")
                        if test -n \"\$rule\"
                            echo \"\"
                            sudo ufw \$rule
                            echo \"\"
                            read -P \"Press Enter to continue...\"
                        end
                    "
                    exit 0
                    ;;
                *) __menu_state="main" ;;
            esac
            ;;
        dns)
            dns_selection=$(rofi_menu "theme.rasi" " 󰇖  Set DNS\n 󰇖  Quick DNS (Cloudflare)\n 󰇖  Quick DNS (Google)\n 󰇖  Reset DNS\n 󰇖  DNS Status\n 󰜺  Back" "DNS...") || { __menu_state="main"; continue; }
            case "$dns_selection" in
                *Set\ DNS*)
                    kitty --class "zenith-network" -e fish -c "$ZENITH_BIN/zenith-dns set (read -P 'DNS (e.g. 1.1.1.1): '); echo; read -P 'Press Enter to continue...'"
                    exit 0
                    ;;
                *Cloudflare*)
                    kitty --class "zenith-network" -e fish -c "$ZENITH_BIN/zenith-dns set 1.1.1.1; echo; read -P 'Press Enter to continue...'"
                    exit 0
                    ;;
                *Google*)
                    kitty --class "zenith-network" -e fish -c "$ZENITH_BIN/zenith-dns set 8.8.8.8; echo; read -P 'Press Enter to continue...'"
                    exit 0
                    ;;
                *Reset*)
                    confirm=$(rofi_menu "theme.rasi" "Yes\nNo" "Reset DNS to default?") || { __menu_state="dns"; continue; }
                    if [[ "$confirm" == "Yes" ]]; then
                        kitty --class "zenith-network" -e fish -c "$ZENITH_BIN/zenith-dns reset; echo; read -P 'Press Enter to continue...'"
                    fi
                    exit 0
                    ;;
                *Status*)
                    kitty --class "zenith-network" -e fish -c "$ZENITH_BIN/zenith-dns status; echo; read -P 'Press Enter to continue...'"
                    exit 0
                    ;;
                *) __menu_state="main" ;;
            esac
            ;;
    esac
done

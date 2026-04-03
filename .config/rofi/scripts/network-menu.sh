#!/usr/bin/env bash
# =============================================================================
# Rofi Network Configuration Menu
# =============================================================================
# Description : Network management interface - Firewall and DNS configuration.
# =============================================================================

set -euo pipefail

source "$(dirname "$0")/common.sh"

# ── Firewall Menu ─────────────────────────────────────────────────────────────
firewall_menu() {
    local status
    status=$(zenith-firewall status 2>/dev/null) || status="unknown"

    local status_icon
    if [ "$status" = "active" ]; then
        status_icon="󰦗 Active"
    else
        status_icon="󰦘 Inactive"
    fi

    local selection
    selection=$(rofi_menu "theme.rasi" " 󰒄  Toggle Firewall ($status_icon)\n 󱓻  Custom Rules\n 󰜺  Back" "Firewall...") || return 1

    case "$selection" in
        *Toggle*)
            local confirm
            if [ "$status" = "active" ]; then
                confirm=$(rofi_menu "theme.rasi" "Yes\nNo" "Disable firewall?") || return 1
            else
                confirm=$(rofi_menu "theme.rasi" "Yes\nNo" "Enable firewall?") || return 1
            fi
            if [[ "$confirm" == "Yes" ]]; then
                kitty --class "zenith-network" -e fish -c "zenith-firewall toggle; echo; read -P 'Press Enter to continue...'"
            fi
            ;;
        *Custom*)
            kitty --class "zenith-network" -e fish -c '
                set rule (read -P "Rule (e.g. allow 22/tcp): ")
                if test -n "$rule"
                    echo ""
                    sudo ufw $rule
                    echo ""
                    read -P "Press Enter to continue..."
                end
            '
            ;;
        *) return 1 ;;
    esac
}

# ── DNS Menu ──────────────────────────────────────────────────────────────────
dns_menu() {
    local selection
    selection=$(rofi_menu "theme.rasi" " 󰇖  Set DNS\n 󰇖  Quick DNS (Cloudflare)\n 󰇖  Quick DNS (Google)\n 󰇖  Reset DNS\n 󰇖  DNS Status\n 󰜺  Back" "DNS...") || return 1

    case "$selection" in
        *Set\ DNS*)
            kitty --class "zenith-network" -e fish -c '
                set dns (read -P "DNS (e.g. 1.1.1.1): ")
                if test -n "$dns"
                    echo ""
                    zenith-dns set $dns
                    echo ""
                    read -P "Press Enter to continue..."
                end
            '
            ;;
        *Cloudflare*)
            kitty --class "zenith-network" -e fish -c "zenith-dns set 1.1.1.1; echo; read -P 'Press Enter to continue...'"
            ;;
        *Google*)
            kitty --class "zenith-network" -e fish -c "zenith-dns set 8.8.8.8; echo; read -P 'Press Enter to continue...'"
            ;;
        *Reset*)
            local confirm
            confirm=$(rofi_menu "theme.rasi" "Yes\nNo" "Reset DNS to default?") || return 1
            if [[ "$confirm" == "Yes" ]]; then
                kitty --class "zenith-network" -e fish -c "zenith-dns reset; echo; read -P 'Press Enter to continue...'"
            fi
            ;;
        *Status*)
            kitty --class "zenith-network" -e fish -c "zenith-dns status; echo; read -P 'Press Enter to continue...'"
            ;;
        *) return 1 ;;
    esac
}

# ── Main Menu ─────────────────────────────────────────────────────────────────
__menu_state="main"

while true; do
    case "$__menu_state" in
        main)
            selection=$(rofi_menu "theme.rasi" " 󰒄  Firewall\n 󰇖  DNS\n 󰜺  Back" "Network...") || exit 0
            case "$selection" in
                *Firewall)
                    firewall_menu || __menu_state="main"
                    ;;
                *DNS)
                    dns_menu || __menu_state="main"
                    ;;
                *) exit 0 ;;
            esac
            ;;
    esac
done

#!/usr/bin/env bash
# =============================================================================
# Rofi Network Configuration Menu
# =============================================================================
# Description : Network management interface - Firewall and DNS configuration.
# =============================================================================

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
    selection=$(rofi_menu "theme.rasi" " 󰒄  Toggle Firewall ($status_icon)\n 󱓻  Custom Rules\n 󰜺  Back" "Firewall...") || \
        exec bash "$ROFI_SCRIPTS_DIR/network-menu.sh"

    case "$selection" in
        *Toggle*)
            local confirm
            if [ "$status" = "active" ]; then
                confirm=$(rofi_menu "theme.rasi" "Yes\nNo" "Disable firewall?") || exec bash "$ROFI_SCRIPTS_DIR/network-menu.sh"
            else
                confirm=$(rofi_menu "theme.rasi" "Yes\nNo" "Enable firewall?") || exec bash "$ROFI_SCRIPTS_DIR/network-menu.sh"
            fi
            if [[ "$confirm" == "Yes" ]]; then
                kitty --class "zenith-network" -e fish -c "zenith-firewall toggle; echo; read -P 'Press Enter to continue...'"
            fi
            exec bash "$ROFI_SCRIPTS_DIR/network-menu.sh"
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
            exec bash "$ROFI_SCRIPTS_DIR/network-menu.sh"
            ;;
        *Back*)
            exec bash "$ROFI_SCRIPTS_DIR/network-menu.sh"
            ;;
    esac
}

# ── DNS Menu ──────────────────────────────────────────────────────────────────
dns_menu() {
    local selection
    selection=$(rofi_menu "theme.rasi" " 󰇖  Set DNS\n 󰇖  Quick DNS (Cloudflare)\n 󰇖  Quick DNS (Google)\n 󰇖  Reset DNS\n 󰇖  DNS Status\n 󰜺  Back" "DNS...") || \
        exec bash "$ROFI_SCRIPTS_DIR/network-menu.sh"

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
            exec bash "$ROFI_SCRIPTS_DIR/network-menu.sh"
            ;;
        *Cloudflare*)
            kitty --class "zenith-network" -e fish -c "zenith-dns set 1.1.1.1; echo; read -P 'Press Enter to continue...'"
            exec bash "$ROFI_SCRIPTS_DIR/network-menu.sh"
            ;;
        *Google*)
            kitty --class "zenith-network" -e fish -c "zenith-dns set 8.8.8.8; echo; read -P 'Press Enter to continue...'"
            exec bash "$ROFI_SCRIPTS_DIR/network-menu.sh"
            ;;
        *Reset*)
            local confirm
            confirm=$(rofi_menu "theme.rasi" "Yes\nNo" "Reset DNS to default?") || \
                exec bash "$ROFI_SCRIPTS_DIR/network-menu.sh"
            if [[ "$confirm" == "Yes" ]]; then
                kitty --class "zenith-network" -e fish -c "zenith-dns reset; echo; read -P 'Press Enter to continue...'"
            fi
            exec bash "$ROFI_SCRIPTS_DIR/network-menu.sh"
            ;;
        *Status*)
            kitty --class "zenith-network" -e fish -c "zenith-dns status; echo; read -P 'Press Enter to continue...'"
            exec bash "$ROFI_SCRIPTS_DIR/network-menu.sh"
            ;;
        *Back*)
            exec bash "$ROFI_SCRIPTS_DIR/network-menu.sh"
            ;;
    esac
}

# ── Main Menu ─────────────────────────────────────────────────────────────────
selection=$(rofi_menu "theme.rasi" " 󰒄  Firewall\n 󰇖  DNS\n 󰜺  Back" "Network...") || \
    exec bash "$ROFI_SCRIPTS_DIR/launcher.sh"

case "$selection" in
    *Firewall) firewall_menu ;;
    *DNS) dns_menu ;;
    *Back) exec bash "$ROFI_SCRIPTS_DIR/launcher.sh" ;;
esac

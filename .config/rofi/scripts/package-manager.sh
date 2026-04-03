#!/usr/bin/env bash
# =============================================================================
# Rofi Package Manager Menu
# =============================================================================
# Description : Unified package management interface.
#               Provides Install, Uninstall, and AUR/Flatpak/Web App management.
# =============================================================================

set -euo pipefail

source "$(dirname "$0")/common.sh"

main_menu() {
    printf ' 󰏖  Install\n 󰁮  Uninstall\n 󰜺  Back\n'
}

install_menu() {
    printf ' 󰏖  Packages\n 󰏖  AUR Packages\n 󰏖  Flatpak Packages\n 󰀱  Web App\n 󰜺  Back\n'
}

uninstall_menu() {
    printf ' 󰏖  Packages\n 󰏖  Flatpak Packages\n 󰀱  Web App\n 󰜺  Back\n'
}

__menu_state="main"

while true; do
    case "$__menu_state" in
        main)
            selection=$(main_menu | rofi_run "theme.rasi" -placeholder "Package Management...") || exit 0
            case "$selection" in
                *Install) __menu_state="install" ;;
                *Uninstall) __menu_state="uninstall" ;;
                *) exit 0 ;;
            esac
            ;;
        install)
            choice=$(install_menu | rofi_run "theme.rasi" -placeholder "Install...") || { __menu_state="main"; continue; }
            case "$choice" in
                *AUR*)
                    kitty --class "zenith-installer" -e fish -c "zenith pkg install --aur;"
                    ;;
                *Flatpak*)
                    kitty --class "zenith-installer" -e fish -c "zenith pkg install --flatpak;"
                    ;;
                *Web\ App)
                    kitty --class "zenith-installer" -e fish -c "zenith webapp install;"
                    ;;
                *Packages)
                    kitty --class "zenith-installer" -e fish -c "zenith pkg install;"
                    ;;
                *) __menu_state="main" ;;
            esac
            ;;
        uninstall)
            choice=$(uninstall_menu | rofi_run "theme.rasi" -placeholder "Uninstall...") || { __menu_state="main"; continue; }
            case "$choice" in
                *Flatpak*)
                    kitty --class "zenith-uninstaller" -e fish -c "zenith pkg remove --flatpak" &
                    ;;
                *Web\ App)
                    kitty --class "zenith-uninstaller" -e fish -c "zenith webapp uninstall" &
                    ;;
                *Packages)
                    kitty --class "zenith-uninstaller" -e fish -c "zenith pkg remove" &
                    ;;
                *) __menu_state="main" ;;
            esac
            ;;
    esac
done

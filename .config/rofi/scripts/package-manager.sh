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
            selection=$(main_menu | rofi_run "theme.rasi" -placeholder "Package Management...") || exit 1
            case "$selection" in
                *Install) __menu_state="install" ;;
                *Uninstall) __menu_state="uninstall" ;;
                *) exit 1 ;;
            esac
            ;;
        install)
            choice=$(install_menu | rofi_run "theme.rasi" -placeholder "Install...") || { __menu_state="main"; continue; }
            case "$choice" in
                *AUR*)
                    kitty --class "zenith-installer" -e fish -c "$ZENITH_BIN/zenith-pkg install --aur;"
                    exit 0
                    ;;
                *Flatpak*)
                    kitty --class "zenith-installer" -e fish -c "$ZENITH_BIN/zenith-pkg install --flatpak;"
                    exit 0
                    ;;
                *Web\ App)
                    kitty --class "zenith-installer" -e fish -c "$ZENITH_BIN/zenith-webapp install;"
                    exit 0
                    ;;
                *Packages)
                    kitty --class "zenith-installer" -e fish -c "$ZENITH_BIN/zenith-pkg install;"
                    exit 0
                    ;;
                *) __menu_state="main" ;;
            esac
            ;;
        uninstall)
            choice=$(uninstall_menu | rofi_run "theme.rasi" -placeholder "Uninstall...") || { __menu_state="main"; continue; }
            case "$choice" in
                *Flatpak*)
                    kitty --class "zenith-uninstaller" -e fish -c "$ZENITH_BIN/zenith-pkg remove --flatpak" &
                    exit 0
                    ;;
                *Web\ App)
                    kitty --class "zenith-uninstaller" -e fish -c "$ZENITH_BIN/zenith-webapp uninstall" &
                    exit 0
                    ;;
                *Packages)
                    kitty --class "zenith-uninstaller" -e fish -c "$ZENITH_BIN/zenith-pkg remove" &
                    exit 0
                    ;;
                *) __menu_state="main" ;;
            esac
            ;;
    esac
done

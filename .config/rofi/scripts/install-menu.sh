#!/usr/bin/env bash
# =============================================================================
# Rofi Install Menu
# =============================================================================
# Description : Interactive Rofi frontend for web app installations and
#               system maintenance scripts using Kitty and Fish shell.
# =============================================================================

source "$(dirname "$0")/common.sh"

selection=$(rofi_menu "theme.rasi" " 󰏖  Packages\n 󰏖  AUR Packages\n 󰏖  Flatpak Packages\n 󰀱  Web App\n 󰜺  Back" "Install...") || \
    exec bash "$ROFI_SCRIPTS_DIR/launcher.sh"

case "$selection" in
    " 󰏖  Packages")
        kitty --class "zenith-installer" -e fish -c "zenith-pkg-install;"
        ;;
    " 󰏖  AUR Packages")
        kitty --class "zenith-installer" -e fish -c "zenith-pkg-aur-install;"
        ;;
    " 󰏖  Flatpak Packages")
        kitty --class "zenith-installer" -e fish -c "zenith-pkg-flatpak-install;"
        ;;
    " 󰀱  Web App")
        kitty --class "zenith-installer" -e fish -c "zenith-webapp-install;"
        ;;
    " 󰜺  Back")
        bash "$ROFI_SCRIPTS_DIR/launcher.sh"
        ;;
esac

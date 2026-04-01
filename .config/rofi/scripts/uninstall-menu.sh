#!/usr/bin/env bash
# =============================================================================
# Rofi Uninstall Menu
# =============================================================================
# Description : Interactive application removal interface using Rofi and
#               Kitty terminal for safe and organized uninstallation.
# =============================================================================

source "$(dirname "$0")/common.sh"

selection=$(rofi_menu "tokyo-night.rasi" " 󰏖  Packages\n 󰀱  Web App\n 󰜺  Back" "Uninstall...") || \
    exec bash "$ROFI_SCRIPTS_DIR/launcher.sh"

case "$selection" in
    *Packages)
        kitty --class "zenith-uninstaller" -e fish -c "zenith-pkg-remove; echo -e '\nPress Enter to close...'; read" &
        ;;
    *Web\ App)
        kitty --class "zenith-uninstaller" -e fish -c "zenith-webapp-uninstall; echo -e '\nPress Enter to close...'; read" &
        ;;
    *Back)
        bash "$ROFI_SCRIPTS_DIR/launcher.sh"
        ;;
esac

#!/usr/bin/env bash
# =============================================================================
# Rofi Uninstall Menu
# =============================================================================
# Description : Interactive application removal interface using Rofi and
#               Kitty terminal for safe and organized uninstallation.
# =============================================================================

source "$(dirname "$0")/common.sh"

selection=$(rofi_menu "theme.rasi" " 󰏖  Packages\n 󰏖  Flatpak Packages\n 󰀱  Web App\n 󰜺  Back" "Uninstall...") || \
    exec bash "$ROFI_SCRIPTS_DIR/launcher.sh"

case "$selection" in
    *Packages*)
        if [[ "$selection" == *"Flatpak"* ]]; then
            kitty --class "zenith-uninstaller" -e fish -c "zenith-pkg-flatpak-remove" &
        else
            kitty --class "zenith-uninstaller" -e fish -c "zenith-pkg-remove" &
        fi
        ;;
    *Web\ App)
        kitty --class "zenith-uninstaller" -e fish -c "zenith-webapp-uninstall" &
        ;;
    *Back)
        bash "$ROFI_SCRIPTS_DIR/launcher.sh"
        ;;
esac

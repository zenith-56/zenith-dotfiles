#!/usr/bin/env bash
# =============================================================================
# Rofi Application Launcher
# =============================================================================
# Description : Launches the Rofi application launcher in drun mode.
#               Displays installed applications with icons and search.
# =============================================================================

THEME="$HOME/.config/rofi/themes/tokyo-night.rasi"

rofi -show drun -theme "$THEME" -show-icons \
    -drun-display-format "{name}" \
    -sorting-method normal \
    -disable-history \
    -drun-reload-desktop-cache

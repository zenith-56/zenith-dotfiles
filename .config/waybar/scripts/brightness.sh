#!/usr/bin/env bash
# =============================================================================
# Waybar Brightness Module - Zenith-Dotfiles
# =============================================================================
# Description : Custom backlight monitor for Waybar, providing dynamic
#               iconography and JSON formatted output for the status bar.
# =============================================================================

BIN="$HOME/.local/bin"

brightness=$("$BIN/zenith-brightness-get" 2>/dev/null || echo "0")

if [ "$brightness" -gt 80 ]; then
    icon="󰃟"
elif [ "$brightness" -gt 60 ]; then
    icon="󰃞"
elif [ "$brightness" -gt 40 ]; then
    icon="󰃝"
elif [ "$brightness" -gt 20 ]; then
    icon="󰃜"
else
    icon="󰃚"
fi

echo "{\"text\": \"$icon $brightness%\", \"tooltip\": \"Brightness: $brightness%\"}"
exit 0

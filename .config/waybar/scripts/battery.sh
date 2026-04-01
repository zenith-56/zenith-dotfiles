#!/usr/bin/env bash
# =============================================================================
# Waybar Battery Module - Zenith-Dotfiles
# =============================================================================
# Description : Custom battery monitor providing JSON output for Waybar,
#               with dynamic iconography based on power levels and state.
# =============================================================================

BIN="$HOME/.local/bin"

capacity=$("$BIN/zenith-battery-capacity" 2>/dev/null || echo "0")
status=$("$BIN/zenith-battery-status" 2>/dev/null || echo "Unknown")

case "$status" in
    Charging|Full)
        icon="󰚥"
        ;;
    *)
        if [ "$capacity" -gt 80 ]; then
            icon="󰁿"
        elif [ "$capacity" -gt 60 ]; then
            icon="󰁽"
        elif [ "$capacity" -gt 40 ]; then
            icon="󰁼"
        elif [ "$capacity" -gt 20 ]; then
            icon="󰁻"
        else
            icon="󰁺"
        fi
        ;;
esac

echo "{\"text\": \"$icon $capacity%\", \"tooltip\": \"$status: $capacity%\"}"
exit 0

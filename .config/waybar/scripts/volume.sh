#!/usr/bin/env bash
# =============================================================================
# Waybar Volume Module - Zenith-Dotfiles
# =============================================================================
# Description : Dynamic audio status indicator for Waybar, managing mute
#               states and volume levels with JSON formatted output.
# =============================================================================

BIN="$HOME/.local/bin"

volume=$("$BIN/zenith-volume-get" 2>/dev/null || echo "0")
muted=$(pamixer --get-mute 2>/dev/null || echo "false")

if [ "$muted" = "true" ]; then
    icon="󰝟"
    text="muted"
else
    if [ "$volume" -gt 100 ]; then
        icon="󰕾"
    elif [ "$volume" -gt 66 ]; then
        icon="󰕾"
    elif [ "$volume" -gt 33 ]; then
        icon="󰖀"
    else
        icon="󰕿"
    fi
    text="$volume%"
fi

echo "{\"text\": \"$icon $text\", \"tooltip\": \"Volume: $volume%\"}"
exit 0

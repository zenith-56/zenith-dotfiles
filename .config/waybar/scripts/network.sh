#!/usr/bin/env bash
# =============================================================================
# Waybar Network Module - Zenith-Dotfiles
# =============================================================================
# Description : Minimalist network status indicator for Waybar, providing
#               dynamic icons and SSID tooltips via JSON output.
# =============================================================================

BIN="$HOME/.local/bin"

status=$("$BIN/zenith-network-status" 2>/dev/null || echo "disconnected")
ssid=$("$BIN/zenith-network-ssid" 2>/dev/null || echo "")

case "$status" in
    connected)
        icon="󰤨"
        tooltip="$ssid"
        ;;
    *)
        icon="󰤩"
        tooltip="Disconnected"
        ;;
esac

echo "{\"text\": \"$icon\", \"tooltip\": \"$tooltip\"}"
exit 0

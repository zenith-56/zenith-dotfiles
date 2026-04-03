#!/usr/bin/env bash
# =============================================================================
# Rofi Emoji Picker - rofi-emoji plugin
# =============================================================================
# Description : Native rofi-emoji plugin wrapper.
#               Trigger: Mod+.  (🤓)
# =============================================================================

set -euo pipefail

if ! command -v rofi &>/dev/null; then
    notify-send "Emoji Picker" "rofi not installed"
    exit 1
fi

EMOJI=$(rofi -modi emoji -show emoji \
    -emoji-mode stdout \
    -theme "$HOME/.config/rofi/themes/tokyo-night.rasi")

if [ -n "$EMOJI" ]; then
    if command -v wl-copy &>/dev/null; then
        echo -n "$EMOJI" | wl-copy
    elif command -v xclip &>/dev/null; then
        echo -n "$EMOJI" | xclip -selection clipboard
    fi
    notify-send "Emoji Selected" "$EMOJI"
fi

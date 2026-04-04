#!/usr/bin/env bash
# =============================================================================
# Rofi Emoji Picker - rofi-emoji plugin
# =============================================================================
# Description : Native rofi-emoji plugin wrapper.
#               Trigger: Mod+.  (🤓)
# =============================================================================

set -euo pipefail

source "$(dirname "$0")/common.sh"

if ! command -v rofi &>/dev/null; then
    rofi_notify "Emoji Picker" "rofi not installed" "error"
    exit 1
fi

EMOJI=$(rofi -modi emoji -show emoji \
    -emoji-mode stdout \
    -theme "$HOME/.config/rofi/themes/theme.rasi")

if [ -n "$EMOJI" ]; then
    if command -v wl-copy &>/dev/null; then
        echo -n "$EMOJI" | wl-copy
    elif command -v xclip &>/dev/null; then
        echo -n "$EMOJI" | xclip -selection clipboard
    fi
    rofi_notify "Emoji Selected" "$EMOJI"
fi

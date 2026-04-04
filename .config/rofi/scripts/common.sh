# =============================================================================
# Rofi Scripts - Common Functions
# =============================================================================
# Shared utilities for all Rofi menu scripts
# =============================================================================

ROFI_THEME_DIR="$HOME/.config/rofi/themes"
ROFI_SCRIPTS_DIR="$HOME/.config/rofi/scripts"
ZENITH_BIN="$HOME/.local/bin"

# ── Notification ──────────────────────────────────────────────────────────────
rofi_notify() {
    local summary="$1"
    local body="${2:-}"
    local icon="${3:-software-update-available}"
    notify-send --urgency=normal --icon="$icon" "$summary" "$body" 2>/dev/null || true
}

# Run rofi with the given theme and arguments
rofi_run() {
    local theme="${1:-theme.rasi}"
    shift
    rofi -dmenu -i -p "" -theme "$ROFI_THEME_DIR/$theme" "$@"
}

# Show a rofi menu and return the selection via stdout
# Usage: selection=$(rofi_menu "theme.rasi" "Option1\nOption2" "Placeholder")
rofi_menu() {
    local theme="${1:-theme.rasi}"
    local items="$2"
    local placeholder="${3:-""}"

    local tmpfile
    tmpfile=$(mktemp)

    if [ -n "$placeholder" ]; then
        printf '%b\n' "$items" | rofi_run "$theme" -placeholder "$placeholder" > "$tmpfile"
    else
        printf '%b\n' "$items" | rofi_run "$theme" > "$tmpfile"
    fi

    local rc=$?
    local result
    result=$(cat "$tmpfile")
    rm -f "$tmpfile"

    # If user pressed Escape, go back to parent menu
    if (( rc == 1 )); then
        return 1
    fi

    echo "$result"
    return 0
}

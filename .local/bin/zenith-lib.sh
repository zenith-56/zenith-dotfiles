#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles - Shared Library
# =============================================================================
# Common functions used across zenith bin scripts.
# Source this file: source "$(dirname "${BASH_SOURCE[0]}")/zenith-lib.sh"
# =============================================================================

# ── Colors ────────────────────────────────────────────────────────────────────
export ZEN_GREEN='\033[0;32m'
export ZEN_YELLOW='\033[1;33m'
export ZEN_RED='\033[0;31m'
export ZEN_CYAN='\033[0;36m'
export ZEN_RESET='\033[0m'
export ZEN_FZF_COLOR_PINK="pointer:#f5c2e7,marker:#f5c2e7,hl:#f5c2e7,hl+:#f5c2e7"

# ── Notification ──────────────────────────────────────────────────────────────
zen_notify() {
    local summary="$1"
    local body="${2:-}"
    local icon="${3:-software-update-available}"
    notify-send --urgency=normal --icon="$icon" "$summary" "$body" 2>/dev/null || true
}

# ── Done Prompt ───────────────────────────────────────────────────────────────
zen_done() {
    echo ""
    echo -e "${ZEN_GREEN}✓${ZEN_RESET} Done."
    echo ""
    read -rp "Press ENTER to close..."
}

# ── Dependency Check ──────────────────────────────────────────────────────────
zen_check_deps() {
    local missing=()
    for cmd in "$@"; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${ZEN_RED}Error: Missing dependencies: ${missing[*]}${ZEN_RESET}" >&2
        exit 1
    fi
}

# ── FZF Common Args ───────────────────────────────────────────────────────────
zen_fzf_args_install() {
    local preview_cmd="${1:-pacman -Sii {1}}"
    local preview_label="${2:-Package Info}"
    local extra_binds="${3:-}"
    local color="${4:-pointer:green,marker:green}"

    local args=(
        --style minimal
        --multi
        --preview "$preview_cmd"
        --preview-label "$preview_label"
        --preview-label-pos='bottom'
        --preview-window 'right:75%:wrap'
        --bind 'alt-p:toggle-preview'
        --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
        --bind 'alt-k:preview-up,alt-j:preview-down'
        --color "$color"
    )

    if [[ -n "$extra_binds" ]]; then
        args+=(--bind "$extra_binds")
    fi

    printf '%s\n' "${args[@]}"
}

zen_fzf_args_remove() {
    local preview_cmd="${1:-yay -Qi {1}}"
    local preview_label="${2:-Package Info}"
    local color="${3:-pointer:red,marker:red}"

    printf '%s\n' \
        --style minimal \
        --multi \
        --preview "$preview_cmd" \
        --preview-label "$preview_label" \
        --preview-label-pos='bottom' \
        --preview-window 'right:65%:wrap' \
        --bind 'alt-p:toggle-preview' \
        --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up' \
        --bind 'alt-k:preview-up,alt-j:preview-down' \
        --color "$color"
}

# ── No Root Check ─────────────────────────────────────────────────────────────
zen_no_root() {
    if [[ $EUID -eq 0 ]]; then
        echo -e "${ZEN_RED}Error: Do not run as root${ZEN_RESET}" >&2
        exit 1
    fi
}

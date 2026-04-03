#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Main Runner
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$SCRIPT_DIR"

# ── Colors ────────────────────────────────────────────────────────────────────
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export RED='\033[0;31m'
export CYAN='\033[0;36m'
export RESET='\033[0m'

# ── Flags ─────────────────────────────────────────────────────────────────────
VERBOSE=false

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
  -v, --verbose    Enable verbose output
  -h, --help       Show this help message
EOF
    exit 0
}

for arg in "$@"; do
    case "$arg" in
        -v|--verbose) VERBOSE=true ;;
        -h|--help) usage ;;
    esac
done

# ── Logging Functions ─────────────────────────────────────────────────────────
log()  { echo -e "${GREEN}[✓]${RESET} $1"; }
warn() { echo -e "${YELLOW}[!]${RESET} $1"; }
err()  { echo -e "${RED}[✗]${RESET} $1"; exit 1; }
info() { echo -e "${CYAN}[i]${RESET} $1"; }
debug() { [ "$VERBOSE" = true ] && echo -e "${YELLOW}[DEBUG]${RESET} $1" || true; }

source "$INSTALL_DIR/common.sh"

if ! has_cmd gum; then
    err "gum not installed. Run: sudo pacman -S gum"
fi

source_include() {
    local script="$INSTALL_DIR/$1.sh"
    if [ -f "$script" ]; then
        source "$script"
    else
        err "Missing script: $script"
    fi
}

run_step() {
    local name="$1"
    echo ""
    gum style --foreground 212 --bold "  ⟩ $name"
    echo ""
    source_include "$name"
}

[ "$(id -u)" -eq 0 ] && err "Do not run as root"

BACKUP_RESULT=$(do_backup_configs)

if ! gum confirm "Start Zenith-Dotfiles installation?"; then
    exit 0
fi

run_step 00-banner
run_step 01-dependencies
run_step 02-services
run_step 03-deploy-configs
run_step 04-deploy-bin
run_step 05-directories
run_step 06-fonts
run_step 07-shell
run_step 08-display-manager

echo ""
gum style --foreground 212 --border-foreground 212 --border rounded \
    --align center --width 50 --padding "1 2" \
    "Installation complete!"
echo ""

if gum confirm "Reboot now?"; then
    sudo reboot
fi

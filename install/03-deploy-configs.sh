# =============================================================================
# Zenith-Dotfiles Installer - Deploy Configs
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

DOTFILES_DIR="$(get_dotfiles_dir)"
CONFIG_SRC="$(get_config_src)"
LOCAL_SRC="$(get_local_src)"

info "Copying configs to ~/.config/..."
for cfg in "${CONFIGS[@]}"; do
    if [ -d "$CONFIG_SRC/$cfg" ]; then
        rm -rf "$HOME/.config/$cfg"
        cp -r "$CONFIG_SRC/$cfg" "$HOME/.config/"
        log "Installed: $cfg"
    fi
done

if [ -d "$LOCAL_SRC/share/dark-mode.d" ]; then
    mkdir -p "$HOME/.local/share/dark-mode.d" "$HOME/.local/share/light-mode.d"
    cp -r "$LOCAL_SRC/share/dark-mode.d/"* "$HOME/.local/share/dark-mode.d/" 2>/dev/null || true
    cp -r "$LOCAL_SRC/share/light-mode.d/"* "$HOME/.local/share/light-mode.d/" 2>/dev/null || true
fi

# Fix hardcoded paths in fish_variables for current user
FISH_VARS="$HOME/.config/fish/fish_variables"
if [ -f "$FISH_VARS" ]; then
    sed -i "s|/home/[^/]*/|$HOME/|g" "$FISH_VARS" 2>/dev/null || true
fi

log "Configs deployed"

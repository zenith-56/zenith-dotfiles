#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Dotfiles Updater
# =============================================================================
# Description : Pulls latest configs from repo and updates the local
#               installation. Offers backup before overwriting.
# AUR Helper  : paru (default)
# Author      : Maximocruz (@zenith-56)
# License     : MIT
# =============================================================================

set -e

# ── Colors ────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
RESET='\033[0m'

REPO_URL="https://github.com/zenith-56/zenith-dotfiles.git"
DOTFILES_DIR="$HOME/zenith-dotfiles"
BACKUP_DIR="$HOME/.config.bak-$(date +%Y%m%d-%H%M%S)"

log()  { echo -e "${GREEN}[✓]${RESET} $1"; }
warn() { echo -e "${YELLOW}[!]${RESET} $1"; }
err()  { echo -e "${RED}[✗]${RESET} $1"; exit 1; }
info() { echo -e "${CYAN}[i]${RESET} $1"; }

# ── Ensure gum ────────────────────────────────────────────────────────────────
if ! command -v gum &>/dev/null; then
    info "gum not found. Installing..."
    sudo pacman -S --noconfirm gum || err "Failed to install gum"
fi

# ── Banner ────────────────────────────────────────────────────────────────────
echo ""
gum style --foreground 212 --border-foreground 212 --border rounded \
    --align center --width 50 --margin "1 2" --padding "1 2" \
    "Zenith-Dotfiles Updater" \
    "" \
    "Configuration updater"
echo ""

# ── Step 1: Clone or pull repo ───────────────────────────────────────────────
if [ -d "$DOTFILES_DIR/.git" ]; then
    info "Repository found at ${DOTFILES_DIR}"
    if gum confirm "Run git pull to get latest changes?"; then
        git -C "$DOTFILES_DIR" pull --ff-only
        log "Repository updated"
    else
        info "Using local repository without updating"
    fi
else
    if [ -d "$DOTFILES_DIR" ]; then
        warn "${DOTFILES_DIR} exists but is not a git repository."
        if gum confirm "Delete it and clone again?"; then
            rm -rf "$DOTFILES_DIR"
        else
            err "Cannot continue. Delete ${DOTFILES_DIR} manually."
        fi
    fi
    gum spin --spinner dot --title "Cloning repository..." -- \
        git clone "$REPO_URL" "$DOTFILES_DIR"
    log "Repository cloned"
fi

# ── Step 2: Backup (optional) ────────────────────────────────────────────────
echo ""
if gum confirm "Back up current configs before updating?"; then
    mkdir -p "$BACKUP_DIR/.config"
    mkdir -p "$BACKUP_DIR/.local/share"

    CONFIGS=(
        "kitty" "btop" "dunst" "fish" "hypr"
        "matugen" "niri" "rofi" "waybar" "zed"
        "swayosd" "yazi" "fastfetch"
    )

    BACKED=0
    for cfg in "${CONFIGS[@]}"; do
        if [ -d "$HOME/.config/$cfg" ]; then
            cp -r "$HOME/.config/$cfg" "$BACKUP_DIR/.config/"
            BACKED=$((BACKED + 1))
        fi
    done

    [ -d "$HOME/.local/share/dark-mode.d" ] && \
        cp -r "$HOME/.local/share/dark-mode.d" "$BACKUP_DIR/.local/share/" && \
        BACKED=$((BACKED + 1))
    [ -d "$HOME/.local/share/light-mode.d" ] && \
        cp -r "$HOME/.local/share/light-mode.d" "$BACKUP_DIR/.local/share/" && \
        BACKED=$((BACKED + 1))

    log "Backup: ${BACKED} dirs saved to ${BACKUP_DIR}"
else
    warn "Skipping backup..."
fi

# ── Step 3: Selective update ─────────────────────────────────────────────────
echo ""
gum style --foreground 212 --bold "  Select configs to update"
echo ""

CONFIG_SRC="$DOTFILES_DIR/.config"
LOCAL_SRC="$DOTFILES_DIR/.local"

CONFIGS_AVAILABLE=()
for cfg in "$CONFIG_SRC"/*/; do
    name=$(basename "$cfg")
    CONFIGS_AVAILABLE+=("$name")
done

SELECTED=$(gum choose --no-limit --cursor.foreground 212 --selected.foreground 212 \
    "${CONFIGS_AVAILABLE[@]}")

if [ -z "$SELECTED" ]; then
    warn "Nothing selected. Exiting."
    exit 0
fi

# ── Step 4: Deploy selected configs ──────────────────────────────────────────
echo ""
gum spin --spinner dot --title "Updating configurations..." -- sleep 1

UPDATED=0
for cfg in $SELECTED; do
    if [ -d "$CONFIG_SRC/$cfg" ]; then
        info "Updating .config/$cfg..."
        rm -rf "$HOME/.config/$cfg"
        cp -r "$CONFIG_SRC/$cfg" "$HOME/.config/"
        UPDATED=$((UPDATED + 1))
    fi
done

# Update darkman scripts if fish or hypr were selected
if echo "$SELECTED" | grep -qE "hypr|fish"; then
    mkdir -p "$HOME/.local/share/dark-mode.d"
    mkdir -p "$HOME/.local/share/light-mode.d"
    cp -r "$LOCAL_SRC/share/dark-mode.d/"* "$HOME/.local/share/dark-mode.d/" 2>/dev/null || true
    cp -r "$LOCAL_SRC/share/light-mode.d/"* "$HOME/.local/share/light-mode.d/" 2>/dev/null || true
    log "Darkman scripts updated"
fi

# Fix fish variables for current user
FISH_VARS="$HOME/.config/fish/fish_variables"
if [ -f "$FISH_VARS" ]; then
    # Get the actual home directory from the file and replace with current user's
    OLD_HOME=$(grep -oP 'set -gx HOME \K\S+' "$FISH_VARS" 2>/dev/null | head -1)
    if [ -n "$OLD_HOME" ]; then
        sed -i "s|$OLD_HOME|$HOME|g" "$FISH_VARS" 2>/dev/null || true
    fi
fi

# Deploy bin scripts
info "Updating bin scripts..."
mkdir -p "$HOME/.local/bin"
cp -f "$DOTFILES_DIR"/.local/bin/* "$HOME/.local/bin/"
log "Bin scripts updated"

log "${UPDATED} configurations updated"

# ── Step 5: Fix permissions ──────────────────────────────────────────────────
info "Fixing permissions..."
chmod +x "$HOME/.config/rofi/scripts/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/waybar/scripts/"*.sh 2>/dev/null || true
chmod +x "$HOME/.local/bin/zenith-"* 2>/dev/null || true
chmod +x "$HOME/.local/share/dark-mode.d/"*.sh 2>/dev/null || true
chmod +x "$HOME/.local/share/light-mode.d/"*.sh 2>/dev/null || true
log "Permissions fixed"

# ── Step 6: Update font cache ────────────────────────────────────────────────
info "Updating font cache..."
fc-cache -fv >/dev/null 2>&1 || true
log "Font cache updated"

# ── Step 7: Check for new packages ────────────────────────────────────────────
echo ""
if gum confirm "Check and install new packages from repo?"; then
    PACMAN_PACKAGES=(
        "fish" "niri" "xwayland-satellite" "xorg-xhost" "kitty"
        "waybar" "rofi" "dunst" "hyprlock" "hypridle" "btop" "htop"
        "brightnessctl" "playerctl" "acpi" "fzf" "unzip" "wget"
        "fastfetch" "snapper" "ncpamixer" "bluetui" "impala"
        "wireless_tools" "sddm" "ttf-jetbrains-mono-nerd" "noto-fonts"
        "noto-fonts-cjk" "noto-fonts-emoji" "woff2-font-awesome"
        "xf86-video-amdgpu" "neovim" "zed" "vim" "nano" "git"
        "github-cli" "stow" "cmake" "power-profiles-daemon"
        "zram-generator" "sof-firmware" "intel-ucode" "flatpak"
        "base-devel" "darkman"
    )

    AUR_PACKAGES=(
        "matugen-bin" "awww" "ttf-material-design-icons-desktop-git"
    )

    info "Installing missing packages (pacman)..."
    sudo pacman -S --noconfirm --needed "${PACMAN_PACKAGES[@]}" 2>/dev/null || \
        warn "Some packages not available in official repos"

    info "Installing missing packages (AUR via paru)..."
    paru -S --noconfirm --needed "${AUR_PACKAGES[@]}" 2>/dev/null || \
        warn "Some AUR packages failed"

    log "Packages verified"
fi

# ── Step 8: Reload running services ──────────────────────────────────────────
echo ""
if gum confirm "Reload running services? (waybar, dunst, kitty, niri)"; then
    # Validate configs first
    info "Validating configs..."
    ERRORS=0

    # Validate waybar config
    if [ -f "$HOME/.config/waybar/config" ]; then
        if ! jq empty "$HOME/.config/waybar/config" 2>/dev/null; then
            warn "Invalid Waybar config JSON - skipping waybar reload"
            ERRORS=$((ERRORS + 1))
        fi
    fi

    # Validate niri configs
    for kdl_file in "$HOME/.config/niri/"*.kdl; do
        if [ -f "$kdl_file" ]; then
            open_braces=$(grep -o '{' "$kdl_file" 2>/dev/null | wc -l)
            close_braces=$(grep -o '}' "$kdl_file" 2>/dev/null | wc -l)
            if [ "$open_braces" -ne "$close_braces" ]; then
                warn "Unbalanced braces in $kdl_file - niri config may be invalid"
                ERRORS=$((ERRORS + 1))
            fi
        fi
    done

    if [ "$ERRORS" -gt 0 ]; then
        warn "Found $ERRORS config issues. Services may not reload correctly."
        if ! gum confirm "Continue anyway?"; then
            info "Skipping service reload"
            ERRORS=0
        fi
    fi

    if [ "$ERRORS" -eq 0 ] || gum confirm "Continue anyway?"; then
        info "Reloading waybar..."
        pkill -SIGUSR2 waybar 2>/dev/null || true

        info "Restarting dunst..."
        pkill dunst && dunst &

        info "Reloading kitty..."
        zenith-reload-kitty 2>/dev/null || true

        info "Reloading niri..."
        niri msg action reload-config 2>/dev/null || true

        log "Services reloaded"
    fi
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
gum style --foreground 212 --border-foreground 212 --border rounded \
    --align center --width 50 --margin "1 2" --padding "1 2" \
    "Update complete!" \
    "" \
    "${UPDATED} configs updated"
echo ""

if [ -d "$BACKUP_DIR" ]; then
    info "Backup: ${BACKUP_DIR}"
fi
info "Repository: ${DOTFILES_DIR}"
echo ""

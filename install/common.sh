#!/usr/bin/env bash

# =============================================================================
# Zenith-Dotfiles Installer - Common Functions & Variables
# =============================================================================
# Shared utilities for all installation scripts
# =============================================================================

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export RED='\033[0;31m'
export CYAN='\033[0;36m'
export RESET='\033[0m'

# ── Logging Functions ─────────────────────────────────────────────────────────
log()  { echo -e "${GREEN}[✓]${RESET} $1"; }
warn() { echo -e "${YELLOW}[!]${RESET} $1"; }
err()  { echo -e "${RED}[✗]${RESET} $1"; exit 1; }
info() { echo -e "${CYAN}[i]${RESET} $1"; }

# ── Command Check ─────────────────────────────────────────────────────────────
# Check if a command exists
has_cmd() {
    command -v "$1" &>/dev/null
}

# Check multiple commands, return missing ones
check_commands() {
    local missing=()
    for cmd in "$@"; do
        if ! has_cmd "$cmd"; then
            missing+=("$cmd")
        fi
    done
    if [ ${#missing[@]} -gt 0 ]; then
        echo "${missing[@]}"
        return 1
    fi
    return 0
}

# ── Package Lists ─────────────────────────────────────────────────────────────
# Central package definitions to avoid duplication

PACMAN_PACKAGES=(
    7zip
    awww
    amdgpu
    base
    base-devel
    bluez
    bluez-utils
    bluetui
    brightnessctl
    btop
    cmake
    darkman
    dnsmasq
    docker
    docker-compose
    dunst
    edk2-ovmf
    efibootmgr
    fastfetch
    fd
    ffmpeg
    ffmpegthumbnailer
    fish
    freerdp
    flatpak
    fzf
    github-cli
    gnome-keyring
    gnu-free-fonts
    gst-plugin-pipewire
    hypridle
    hyprlock
    imagemagick
    iproute2
    iwd
    jq
    kitty
    lazydocker
    libsecret
    libnotify
    mediainfo
    mpv
    nano
    neovim
    niri
    nvidia-dkms
    nvidia-utils
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    openbsd-netcat
    pamixer
    pipewire
    pipewire-alsa
    pipewire-jack
    pipewire-pulse
    playerctl
    polkit
    poppler
    power-profiles-daemon
    qemu-full
    reflector
    resvg
    ripgrep
    rofi
    rofi-emoji
    sddm
    slurp
    snapper
    sof-firmware
    swayosd
    ttf-jetbrains-mono-nerd
    ttf-liberation
    ttf-nerd-fonts-symbols
    ttf-nerd-fonts-symbols-common
    ufw
    unzip
    uwsm
    waybar
    wf-recorder
    wget
    wireless_tools
    wireplumber
    woff2-font-awesome
    xdg-desktop-portal
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xorg-server
    xorg-xauth
    xorg-xhost
    xorg-xinit
    xorg-xwayland
    xwayland-satellite
    yazi
    zed
    zoxide
    zram-generator
)

AUR_PACKAGES=(
    brave-bin
    impala
    matugen-bin
    ncpamixer
    ttf-material-design-icons-desktop-git
)

# Essential packages for minimal install (used by installer)
ESSENTIAL_PACKAGES=(
    git base-devel gum curl
)

# ── Config Lists ──────────────────────────────────────────────────────────────
CONFIGS=(
    btop dunst fastfetch fish hypr kitty matugen mpv niri rofi swayosd waybar yazi
)

# ── Dark/Light Mode Scripts ───────────────────────────────────────────────
MODE_SCRIPTS=(
    dark-mode.d
    light-mode.d
)

# ── Service Lists ─────────────────────────────────────────────────────────────
SYSTEM_SERVICES=(
    "docker"
    "power-profiles-daemon"
    "bluetooth"
    "iwd"
    "systemd-networkd"
    "systemd-resolved"
)

# ── Directory Structure ───────────────────────────────────────────────────────
get_dotfiles_dir() {
    echo "$HOME/zenith-dotfiles"
}

get_config_src() {
    echo "$(get_dotfiles_dir)/.config"
}

get_local_src() {
    echo "$(get_dotfiles_dir)/.local"
}

# ── Validation Functions ──────────────────────────────────────────────────────
# Validate that a config file exists and is readable
validate_config() {
    local config_name="$1"
    local config_path="$HOME/.config/$config_name"

    if [ -d "$config_path" ]; then
        return 0
    elif [ -f "$config_path" ]; then
        return 0
    else
        warn "Config not found: $config_name"
        return 1
    fi
}

# Validate KDL config syntax (for niri, hyprlock, etc.)
validate_kdl() {
    local file="$1"
    if [ -f "$file" ]; then
        # Basic syntax check - ensure balanced braces
        local open_braces=$(grep -o '{' "$file" 2>/dev/null | wc -l)
        local close_braces=$(grep -o '}' "$file" 2>/dev/null | wc -l)
        if [ "$open_braces" -ne "$close_braces" ]; then
            warn "KDL syntax error in $file: unbalanced braces"
            return 1
        fi
    fi
    return 0
}

# ── Service Management ────────────────────────────────────────────────────────
# Safely restart a service if it's running
restart_service() {
    local service="$1"
    local signal="${2:-TERM}"

    if pgrep -x "$service" &>/dev/null; then
        pkill -"$signal" "$service" 2>/dev/null && \
            log "Restarted: $service" || \
            warn "Failed to restart: $service"
    fi
}

# ── Backup Functions ──────────────────────────────────────────────────────────
create_backup() {
    local source="$1"
    local backup_dir="$2"

    if [ -e "$source" ]; then
        mkdir -p "$(dirname "$backup_dir")"
        cp -r "$source" "$backup_dir" && \
            log "Backed up: $source" || \
            warn "Failed to backup: $source"
    fi
}

# Interactive backup of all Zenith configs (uses gum)
do_backup_configs() {
    local backup_dir="$HOME/.config.bak-$(date +%Y%m%d-%H%M%S)"

    if gum confirm "Backup existing configs before installing?"; then
        mkdir -p "$backup_dir/.config"
        mkdir -p "$backup_dir/.local/share"

        local backed=0
        for cfg in "${CONFIGS[@]}"; do
            if [ -d "$HOME/.config/$cfg" ]; then
                cp -r "$HOME/.config/$cfg" "$backup_dir/.config/"
                backed=$((backed + 1))
            fi
        done

        if [ -d "$HOME/.local/share/dark-mode.d" ]; then
            cp -r "$HOME/.local/share/dark-mode.d" "$backup_dir/.local/share/"
            backed=$((backed + 1))
        fi
        if [ -d "$HOME/.local/share/light-mode.d" ]; then
            cp -r "$HOME/.local/share/light-mode.d" "$backup_dir/.local/share/"
            backed=$((backed + 1))
        fi

        log "Backup: ${backed} dirs saved to ${backup_dir}"
        echo "$backup_dir"
    else
        warn "Skipping backup..."
        echo ""
    fi
}

# ── Config Validation ─────────────────────────────────────────────────────────
# Validate configs before restarting services
validate_configs() {
    local errors=0

    # Validate waybar config
    if [ -f "$HOME/.config/waybar/config" ]; then
        if ! jq empty "$HOME/.config/waybar/config" 2>/dev/null; then
            warn "Invalid Waybar config JSON"
            errors=$((errors + 1))
        fi
    fi

    # Validate kitty config
    if [ -f "$HOME/.config/kitty/kitty.conf" ]; then
        if ! grep -qE "^[a-z_]+" "$HOME/.config/kitty/kitty.conf" 2>/dev/null; then
            warn "Kitty config may be empty or invalid"
            errors=$((errors + 1))
        fi
    fi

    # Validate niri configs (KDL format - basic check)
    for kdl_file in "$HOME/.config/niri/"*.kdl; do
        if [ -f "$kdl_file" ]; then
            if ! validate_kdl "$kdl_file"; then
                errors=$((errors + 1))
            fi
        fi
    done

    return $errors
}

# Safe service restart with validation
safe_restart_service() {
    local service="$1"
    local config_name="$2"

    # Validate config first
    if [ -n "$config_name" ] && ! validate_config "$config_name"; then
        warn "Skipping $service restart due to config validation failure"
        return 1
    fi

    restart_service "$service"
}

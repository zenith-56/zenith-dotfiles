#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Dependencies
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

cleanup_yay() {
    rm -rf /tmp/yay 2>/dev/null || true
}

trap cleanup_yay EXIT INT TERM

# ── Hardware Detection ───────────────────────────────────────────────────────
detect_hardware() {
    info "Detecting hardware..."

    local has_virt=false
    local gpu_amd=false
    local gpu_intel=false
    local gpu_nvidia=false

    if command -v lspci &>/dev/null; then
        if lspci | grep -qi 'virtual'; then
            has_virt=true
        fi
        if lspci | grep -qi 'amd.*gpu\|radeon\|rx '; then
            gpu_amd=true
        fi
        if lspci | grep -qi 'intel.*gpu\|intel hd\|iris\|intel arc'; then
            gpu_intel=true
        fi
        if lspci | grep -qi 'nvidia'; then
            gpu_nvidia=true
        fi
    fi

    echo "has_virt=$has_virt"
    echo "gpu_amd=$gpu_amd"
    echo "gpu_intel=$gpu_intel"
    echo "gpu_nvidia=$gpu_nvidia"
}

install_yay() {
    if ! has_cmd yay; then
        info "Installing yay (AUR helper)..."

        if ! has_cmd git; then
            err "git not found. Install base-devel first."
        fi

        if ! has_cmd make; then
            err "make not found. Install base-devel first."
        fi

        pushd /tmp >/dev/null
        rm -rf yay
        git clone https://aur.archlinux.org/yay.git || err "Failed to clone yay"
        cd yay && makepkg -si --noconfirm || err "Failed to build yay"
        popd >/dev/null || true
    fi
}

filter_packages() {
    local hw_info="$1"
    local pkgs=("${PACMAN_PACKAGES[@]}")
    local filtered=()

    local has_virt=$(echo "$hw_info" | grep 'has_virt=true' &>/dev/null && echo true || echo false)
    local gpu_amd=$(echo "$hw_info" | grep 'gpu_amd=true' &>/dev/null && echo true || echo false)
    local gpu_intel=$(echo "$hw_info" | grep 'gpu_intel=true' &>/dev/null && echo true || echo false)
    local gpu_nvidia=$(echo "$hw_info" | grep 'gpu_nvidia=true' &>/dev/null && echo true || echo false)

    if [ "$gpu_intel" = true ]; then
        info "Intel GPU detected - using included drivers (no extra packages needed)"
    fi

    for pkg in "${pkgs[@]}"; do
        case "$pkg" in
            qemu-full)
                if [ "$has_virt" = true ]; then
                    filtered+=("$pkg")
                else
                    info "Skipping qemu-full (no virtualization detected)"
                fi
                ;;
            amdgpu)
                if [ "$gpu_amd" = true ]; then
                    filtered+=("$pkg")
                else
                    info "Skipping amdgpu (no AMD GPU detected)"
                fi
                ;;
            gpu-intel)
                if [ "$gpu_intel" = true ]; then
                    info "Intel GPU detected - using included drivers"
                fi
                ;;
            nvidia|nvidia-dkms|nvidia-utils)
                if [ "$gpu_nvidia" = true ]; then
                    filtered+=("$pkg")
                else
                    info "Skipping nvidia packages (no NVIDIA GPU detected)"
                fi
                ;;
            *)
                filtered+=("$pkg")
                ;;
        esac
    done

    printf '%s\n' "${filtered[@]}"
}

install_yay

info "Detecting hardware..."
HW_INFO=$(detect_hardware)

info "Installing pacman packages..."
if [ ${#PACMAN_PACKAGES[@]} -gt 0 ]; then
    local filtered_pkgs
    filtered_pkgs=($(filter_packages "$HW_INFO"))

    if [ ${#filtered_pkgs[@]} -gt 0 ]; then
        local failed=()
        for pkg in "${filtered_pkgs[@]}"; do
            if ! sudo pacman -S --noconfirm --needed --overwrite '*' "$pkg" 2>&1 | tee /tmp/pacman.log; then
                failed+=("$pkg")
                warn "Failed to install: $pkg"
            fi
        done
        if [ ${#failed[@]} -gt 0 ]; then
            err "Failed packages: ${failed[*]}. Check /tmp/pacman.log for details."
        fi
    fi
    log "All pacman packages installed"
fi

info "Installing AUR packages..."
if [ ${#AUR_PACKAGES[@]} -gt 0 ]; then
    local failed_aur=()
    for pkg in "${AUR_PACKAGES[@]}"; do
        if ! yay -S --noconfirm --needed "$pkg" 2>&1 | tee /tmp/yay.log; then
            failed_aur+=("$pkg")
            warn "Failed to install AUR: $pkg"
        fi
    done
    if [ ${#failed_aur[@]} -gt 0 ]; then
        err "Failed AUR packages: ${failed_aur[*]}. Check /tmp/yay.log for details."
    fi
    log "All AUR packages installed"
fi

log "Dependencies installed"

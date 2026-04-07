#!/usr/bin/env bash
# =============================================================================
# Zenith-Dotfiles Installer - Services
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

if ! has_cmd systemctl; then
    err "systemctl not found"
fi

if ! has_cmd gum; then
    err "gum not found"
fi

for svc in "${SYSTEM_SERVICES[@]}"; do
    if systemctl list-unit-files "${svc}.service" &>/dev/null || \
       systemctl list-unit-files "${svc}" &>/dev/null; then
        if gum confirm "Enable ${svc}?"; then
            sudo systemctl enable --now "$svc" || warn "Failed to enable ${svc}"
            log "Enabled: $svc"
        fi
    fi
done

if gum confirm "Enable darkman (user service)?"; then
    systemctl --user enable --now darkman.service || warn "Failed to enable darkman"
    log "Enabled: darkman"
fi

# ── Docker Group Setup ────────────────────────────────────────────────────────
if has_cmd docker; then
    if ! groups "$USER" | grep -q docker; then
        if gum confirm "Add $USER to docker group? (avoids sudo for docker)"; then
            sudo usermod -aG docker "$USER"
            warn "Added $USER to docker group — log out and back in for it to take effect"
        fi
    else
        log "User already in docker group"
    fi
fi

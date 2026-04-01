#!/usr/bin/env bash
# =============================================================================
# Light Mode GTK Theme Script
# =============================================================================

BIN="$HOME/.local/bin"

gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' 2>/dev/null || true
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita' 2>/dev/null || true

WALL=$(readlink -f "$HOME/.config/rofi/images/current_wallpaper.png" 2>/dev/null)
if [[ -n "$WALL" && -f "$WALL" ]]; then
    matugen image "$WALL" --prefer value -m light
fi

"$BIN/zenith-restart-all"
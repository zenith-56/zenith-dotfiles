#!/usr/bin/env bash
# =============================================================================
# Dark Mode GTK Theme Script
# =============================================================================

BIN="$HOME/.local/bin"

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true

WALL=$(readlink -f "$HOME/.config/rofi/images/current_wallpaper.png" 2>/dev/null)
if [[ -n "$WALL" && -f "$WALL" ]]; then
    matugen image "$WALL" --prefer value -m dark
fi

"$BIN/zenith-theme-sync"
"$BIN/zenith-restart-all"
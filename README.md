# Zenith-Dotfiles

Arch Linux desktop with **Niri** (scrollable-tiling compositor), **Material You** theming, and modular installation.

> **AUR Helper:** [yay](https://github.com/Jguer/yay) installed automatically.

## Features

| Category | Component |
|----------|-----------|
| **Compositor** | Niri (scrollable-tiling Wayland) |
| **Theming** | Material You via Matugen |
| **Theme Switching** | Darkman (auto dark/light) |
| **Bar** | Waybar with CPU animation |
| **OSD** | SwayOSD |
| **Lock/Idle** | Hyprlock + Hypridle |
| **Launcher** | Rofi (wallpaper selector, power menu, web apps) |
| **Shell** | Fish |
| **Terminal** | Kitty (GPU-accelerated) |
| **Notifications** | Dunst |
| **Editor** | Zed |
| **File Manager** | Yazi (Kitty image preview) |
| **System Monitor** | Btop |
| **Display** | Fastfetch |

## Screenshots

| 1-Niri | 2-Rofi | 3-Awww |
|--------|--------|--------|
| ![Niri](images/1-niriwm.png) | ![Rofi](images/2-rofi.png) | ![Awww](images/3-awww.png) |

| 4-WebApps | 5-Launcher | 6-Themes |
|-----------|------------|----------|
| ![Web Apps](images/4-webapp.png) | ![Launcher](images/5-applauncher.png) | ![Themes](images/6-dltheme.png) |

## Quick Install

```bash
bash <(curl -sSL https://raw.githubusercontent.com/zenith-56/zenith-dotfiles/master/install.sh)
```

The installer walks you through (via Gum):
1. Install packages (pacman + AUR via yay)
2. Deploy configs to `~/.config/`
3. Install bin scripts to `~/.local/bin/`
4. Create directories
5. Setup fonts
6. Configure shell (Fish)
7. Optionally enable SDDM

## Update

```bash
# Via curl
bash <(curl -sSL https://raw.githubusercontent.com/zenith-56/zenith-dotfiles/master/update.sh)

# Or locally
cd ~/zenith-dotfiles && ./update.sh
```

## Zenith Bin Scripts

| Script | Description |
|--------|-------------|
| `zenith-theme-{get,set,toggle}` | Theme control |
| `zenith-swayosd-{volume,brightness}` | OSD controls |
| `zenith-mic` | Toggle mic mute |
| `zenith-kb-layout` | Keyboard layout (us/es) |
| `zenith-lock` | Lock screen |
| `zenith-power-off` / `zenith-reboot` / `zenith-logout` | Power actions |
| `zenith-screenshot` / `zenith-screenshot-region` | Screenshot |
| `zenith-screen-recorder` | Screen recording |
| `zenith-music-show` | Current track (hyprlock) |
| `zenith-battery-{capacity,status}` | Battery info |
| `zenith-brightness-{get,set}` | Brightness control |
| `zenith-volume-{get,set}` | Volume control |
| `zenith-network-{status,ssid}` | Network info |
| `zenith-pkg-install` | FZF pacman install |
| `zenith-pkg-aur-install` | FZF AUR install |
| `zenith-pkg-flatpak-install` | Flatpak install |
| `zenith-pkg-flatpak-remove` | Flatpak remove |
| `zenith-pkg-list` | List packages |
| `zenith-pkg-remove` | FZF remove package |
| `zenith-pkg-colors` | Package info colors |
| `zenith-webapp-{install,uninstall}` | Web app installer |
| `zenith-restart-{all,waybar,dunst,swayosd}` | Restart services |
| `zenith-reload-kitty` | Reload kitty colors |
| `zenith-done` | Exit prompt with message |

## Keybindings (Niri)

| Keys | Action |
|------|--------|
| `Mod+T` | Terminal (Kitty) |
| `Mod+Space` | App launcher |
| `Mod+Shift+Space` | Main launcher |
| `Mod+Shift+W` | Wallpaper selector |
| `Mod+Shift+T` | Theme menu |
| `Mod+Shift+Delete` | Power menu |
| `Mod+Q` | Close window |
| `Mod+F` | Fullscreen |
| `Mod+V` | Toggle float/tiled |
| `Mod+1-9` | Workspace |
| `Super+L` | Lock |
| `Vol/Brightness keys` | OSD |
| `Mod+Shift+K` | Keyboard layout |

## Matugen Integration

Templates in `.config/matugen/templates/` generate colors for:
- Waybar, Rofi, Dunst, Hyprlock, Kitty, Zed, Btop, SwayOSD

Wallpaper changes (`Mod+Shift+W`) auto-regenerate all themes.

## Project Structure

```
zenith-dotfiles/
├── install.sh / update.sh    # Install scripts
├── install/                   # Modular installers
├── .local/bin/               # zenith-* scripts
├── .local/share/             # dark/light mode scripts
├── .config/                  # App configs (niri, waybar, kitty, etc.)
├── .github/workflows/        # CI/CD
└── images/                   # Screenshots
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Waybar not showing | `waybar &` or validate JSON: `jq . ~/.config/waybar/config` |
| Themes not applying | Run: `matugen image ~/Pictures/Wallpapers/wallpaper.png` |
| Dark mode broken | Enable: `systemctl --user enable --now darkman` |
| Rofi crashes | Check theme: `ls ~/.config/rofi/themes/` |
| Kitty colors wrong | Run: `zenith-reload-kitty` |

## Uninstall

```bash
cd ~/zenith-dotfiles && ./uninstall.sh
```

## License

MIT — see [LICENSE](LICENSE)

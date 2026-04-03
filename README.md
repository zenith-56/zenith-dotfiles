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
| **Launcher** | Rofi (wallpaper selector, power menu, web apps, emoji picker) |
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
| `zenith-theme-sync` | Sync theme colors with matugen |
| `zenith-done` | Exit prompt with message |

## Keybindings (Niri)

| Keys | Action |
|------|--------|
| `Mod+T` | Terminal (Kitty) |
| `Mod+Space` | App launcher |
| `Mod+Shift+Space` | Main launcher |
| `Mod+Shift+W` | Wallpaper selector |
| `Mod+Shift+T` | Theme menu |
| `Mod+.` | Emoji picker |
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

### Installation Issues

| Issue | Solution |
|-------|----------|
| Installer hangs on "Installing gum" | Install manually: `sudo pacman -S gum` |
| yay fails to build | Install `base-devel` first: `sudo pacman -S base-devel` |
| Permission denied errors | Ensure you're not running as root (installer checks this) |

### Display & Compositor

| Issue | Solution |
|-------|----------|
| Niri fails to start | Check logs: `journalctl -xe -b --no-pager | grep niri` |
| Black screen after login | Check if SDDM started: `systemctl status sddm` |
| Waybar not showing | Run `waybar &` or validate JSON: `jq . ~/.config/waybar/config` |
| Waybar crashes on reload | Check JSON syntax in config files |
| Multiple monitors not detected | Edit `~/.config/niri/output.kdl` to add outputs |

### Theming

| Issue | Solution |
|-------|----------|
| Themes not applying | Run: `matugen image ~/Pictures/Wallpapers/wallpaper.png` |
| Colors wrong after wallpaper change | Run `zenith-theme-sync` to regenerate |
| Dark mode broken | Enable: `systemctl --user enable --now darkman` |
| Dark mode not switching automatically | Check `darkman` status: `systemctl --user status darkman` |

### Rofi & Launcher

| Issue | Solution |
|-------|----------|
| Rofi crashes | Check theme: `ls ~/.config/rofi/themes/` |
| Emoji picker not working | Install `wtype`: `yay -S wtype` |
| Launcher slow to open | Reduce number of apps or check `app-launcher.sh` |

### Audio & Input

| Issue | Solution |
|-------|----------|
| No sound | Check `pavucontrol` or run `wireplumber` |
| Volume keys not working | Check SwayOSD: `systemctl --user status swayosd` |
| Microphone not working | Run `zenith-mic` to toggle mute |
| Keyboard layout wrong | Run `zenith-kb-layout` or check Niri binds |

### Terminal & Kitty

| Issue | Solution |
|-------|----------|
| Kitty colors wrong | Run: `zenith-reload-kitty` |
| Font rendering issues | Install fonts: `./install.sh` (fonts step) |
| Kitty not starting | Check `kitty` in PATH: `which kitty` |

### Packages

| Issue | Solution |
|-------|----------|
| yay not found | Install with: `sudo pacman -S yay` |
| AUR packages failing | Update mirrorlist: `sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist` |
| Flatpak apps not showing | Run: `flatpak repair` |

### Services

| Issue | Solution |
|-------|----------|
| Services not starting | Check logs: `journalctl -xe --no-pager | grep <service>` |
| Dunst notifications not working | Restart: `pkill dunst && dunst &` |
| Hyprlock not locking | Check config: `~/.config/hypr/hyprlock.conf` |

### Network & Power

| Issue | Solution |
|-------|----------|
| No internet | Check `systemctl status iwd` or `systemd-networkd` |
| VPN not connecting | Check WireGuard config in `~/.config/` |
| Battery draining fast | Use `power-profiles-daemon` or TLP |
| Screen not turning off | Check `hypridle` config |

### Backup & Recovery

| Issue | Solution |
|-------|----------|
| Need to restore configs | Check backup dir: `ls ~/.config.bak-*` |
| Lost theme colors | Run `matugen` again with wallpaper |
| Shell broken | Reset to bash: `chsh -s /bin/bash` |

## Uninstall

```bash
cd ~/zenith-dotfiles && ./uninstall.sh
```

## License

MIT — see [LICENSE](LICENSE)

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

All scripts under `~/.local/bin/` use subcommands for a unified interface.

| Script | Description |
|--------|-------------|
| `zenith theme {get,set,toggle,sync}` | Theme management |
| `zenith pkg install [--aur] [--flatpak]` | Interactive package installation |
| `zenith pkg remove [--flatpak]` | Interactive package removal |
| `zenith pkg list [--explicit] [--orphans] [--search] [--flatpak]` | List packages |
| `zenith pkg missing <pkg1> <pkg2>` | Check if packages are installed |
| `zenith webapp install [name] [url] [icon]` | Web app installer |
| `zenith webapp uninstall` | Web app remover |
| `zenith webapp list` | List installed web apps |
| `zenith restart {waybar,dunst,swayosd,kitty,all}` | Restart services |
| `zenith power {off,reboot,lock,logout}` | Power actions |
| `zenith power profile {list,get,balanced,etc}` | Power profile management |
| `zenith screenshot {full,region}` | Screenshot |
| `zenith screen-recorder` | Screen recording |
| `zenith brightness {get,set}` | Brightness control |
| `zenith volume {get,set}` | Volume control |
| `zenith battery {capacity,status,info}` | Battery info |
| `zenith network {status,ssid}` | Network info |
| `zenith osd volume {up,down,toggle}` | Volume OSD |
| `zenith osd brightness {up,down}` | Brightness OSD |
| `zenith mic` | Toggle mic mute |
| `zenith kb-layout` | Keyboard layout (us/es) |
| `zenith music-show` | Current track (hyprlock) |
| `zenith firewall` | UFW firewall manager |
| `zenith dns` | DNS switcher |
| `zenith check` | System health check |

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
| Colors wrong after wallpaper change | Run `zenith theme sync` to regenerate |
| Dark mode broken | Enable: `systemctl --user enable --now darkman` |
| Dark mode not switching automatically | Check `darkman` status: `systemctl --user status darkman` |

### Rofi Launcher

The Rofi launcher uses a **state-machine navigation pattern** — Esc always returns to the parent menu without closing Rofi.

| Script | Description |
|--------|-------------|
| `launcher.sh` | Main menu (Apps, Network, Theming, Packages, Power) |
| `app-launcher.sh` | Application launcher (drun mode) |
| `network-menu.sh` | Firewall & DNS management |
| `theming-menu.sh` | Wallpaper & theme mode selector |
| `package-manager.sh` | Install/Uninstall packages (pacman, AUR, Flatpak, Web Apps) |
| `power-menu.sh` | Shutdown, Restart, Lock, Logout |
| `wall-selector.sh` | Wallpaper gallery with Matugen integration |
| `theme-menu.sh` | Dark/Light mode toggle |
| `emoji-picker.sh` | Emoji picker (rofi-emoji plugin) |

#### Navigation

```
launcher.sh
├── app-launcher.sh (rofi drun)
├── network-menu.sh
│   ├── firewall_menu() → Esc → back to network
│   └── dns_menu() → Esc → back to network
├── theming-menu.sh
│   ├── wall-selector.sh (gallery)
│   └── theme-menu.sh (dark/light) → Esc → back to theming
├── package-manager.sh
│   ├── install → Esc → back to package-manager
│   └── uninstall → Esc → back to package-manager
└── power-menu.sh (direct actions)
```

**Rules:**
- `Esc` → return to parent menu (no Rofi flicker)
- `Back` option → return to parent menu
- Empty selection → close Rofi
- Power actions → execute immediately (with confirmation for shutdown/restart)

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
| Kitty colors wrong | Run: `zenith restart kitty` |
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

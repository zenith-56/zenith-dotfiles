# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### 0.4.0 - Bin Scripts Unification

#### Added
- `zenith-lib.sh` — Shared library with colors, notifications, dependency checks, fzf args, and done prompt
- `zenith pkg` — Unified package manager with `install`, `remove`, `list`, `missing` subcommands and `--aur`, `--flatpak` flags
- `zenith theme` — Unified theme manager with `get`, `set`, `toggle`, `sync` subcommands
- `zenith restart` — Unified service restarter with `waybar`, `dunst`, `swayosd`, `kitty`, `all` subcommands
- `zenith power` — Unified power manager with `off`, `reboot`, `lock`, `logout`, `profile` subcommands
- `zenith screenshot` — Unified screenshot tool with `full`, `region` subcommands
- `zenith brightness` — Unified brightness control with `get`, `set` subcommands
- `zenith volume` — Unified volume control with `get`, `set` subcommands
- `zenith battery` — Unified battery info with `capacity`, `status`, `info` subcommands
- `zenith network` — Unified network info with `status`, `ssid` subcommands
- `zenith osd` — Unified OSD control with `volume` and `brightness` subcommands
- `zenith webapp` — Unified web app manager with `install`, `uninstall`, `list` subcommands

#### Changed
- Consolidated 45 individual bin scripts into 12 unified scripts with subcommands
- All unified scripts use `set -euo pipefail` and proper error handling
- Eliminated copy-paste duplication of fzf args, notification patterns, and dependency checks
- Updated all rofi scripts, darkman scripts, and update.sh to use new unified interfaces
- Updated README.md and AGENTS.md documentation

#### Deprecated
- `zenith-pkg-install`, `zenith-pkg-remove`, `zenith-pkg-list`, `zenith-pkg-missing`, `zenith-pkg-colors`
- `zenith-pkg-aur-install`, `zenith-pkg-flatpak-install`, `zenith-pkg-flatpak-list`, `zenith-pkg-flatpak-remove`
- `zenith-theme-get`, `zenith-theme-set`, `zenith-theme-toggle`, `zenith-theme-sync`
- `zenith-restart-all`, `zenith-restart-waybar`, `zenith-restart-dunst`, `zenith-restart-swayosd`
- `zenith-reload-kitty`
- `zenith-power-off`, `zenith-reboot`, `zenith-lock`, `zenith-logout`
- `zenith-screenshot`, `zenith-screenshot-region`
- `zenith-brightness-get`, `zenith-brightness-set`
- `zenith-volume-get`, `zenith-volume-set`
- `zenith-battery-capacity`, `zenith-battery-status`
- `zenith-network-status`, `zenith-network-ssid`
- `zenith-swayosd-volume`, `zenith-swayosd-brightness`
- `zenith-webapp-install`, `zenith-webapp-uninstall`
- `zenith-done` (use `zen_done` from `zenith-lib.sh`)

### 0.3.5 - Rofi Navigation Overhaul & Cleanup

#### Added
- Emoji picker (Mod+.) via rofi-emoji plugin
- Verbose mode (`-v, --verbose`) to install.sh, update.sh, uninstall.sh, run.sh
- `--force` flag to install.sh for skipping confirmations
- `rofi-emoji` to pacman packages

#### Changed
- Unified logging functions in all main scripts (log, warn, err, info, debug)
- Added debug logging to verbose mode across all scripts
- Improved error handling with `set -euo pipefail` in all scripts
- Expanded troubleshooting section in README.md with categorized issues
- Merged `install-menu.sh` and `uninstall-menu.sh` into single `package-manager.sh` with submenus
- Refactored all Rofi menu scripts with state-machine navigation pattern (`__menu_state`)
- Removed `exec` and `exit 0` between menus — Esc now returns to parent menu without closing Rofi
- Eliminated nested `while` loops in `package-manager.sh` — flat state machine instead
- Unified `rofi_menu` usage across all scripts — consistent Esc behavior

#### Fixed
- install.sh now uses proper `set -euo pipefail`
- Sourced common.sh correctly in update.sh (was using wrong path)
- run.sh has proper flag parsing and verbose support
- Typo in wall-selector.sh notification ("aplied" → "applied")
- Removed redundant `exec bash launcher.sh` calls that caused Rofi flicker on navigation

#### Code Review - Potential Cleanup (verify before removing)
- All items from this list have been addressed in 0.4.0

### 0.3.4 - Utilities Varias

#### Added
- (pendiente - definir con el usuario)

### 0.3.2 - Network Modules

#### Added
- Rofi network menu (`network-menu.sh`) with Firewall and DNS management
- `zenith-firewall` - ufw firewall toggle and custom rule management
- `zenith-dns` - DNS switcher with support for custom, Cloudflare, Google, and reset
- `zenith-vpn-toggle` - WireGuard VPN toggle script
- Waybar module: VPN status (`vpn-status.sh`)
- Waybar module: WiFi signal strength (`wifi-signal.sh`)
- Network Configuration entry in main rofi launcher

### 0.3.1 - Scripts de Sistema

#### Added
- `zenith-check` - System health check script (configs, services, packages, disk, memory)
- `--force` flag to `update.sh` - skip all confirmations
- `--dry-run` flag to `update.sh` - preview changes without applying

#### Changed
- All critical scripts now use `set -euo pipefail`
- Added `command -v` checks before using external commands in all bin scripts
- Added `trap` cleanup to `zenith-screen-recorder` and `install/01-dependencies.sh`
- Improved error messages and exit codes across all scripts

### 0.3.0 - Waybar Modules Core

#### Added
- Waybar module: GPU usage
- Waybar module: Disk usage
- Waybar module: Temperature

### 0.2.0 - Initial Release

#### Added
- Niri window manager configuration
- Waybar with custom modules
- Dunst notification daemon
- Kitty terminal configuration
- Rofi launcher with themed menus
- Hyprlock + hypridle
- Fish shell configuration
- Matugen theme generation
- Darkman integration
- Btop, Yazi, Zed, SwayOSD configurations
- Zenith bin scripts (theme, power, music, audio, display, network, battery, screenshot, packages, etc.)
- Modular installer with dependency management
- Config updater (`update.sh`)
- Uninstaller (`uninstall.sh`)

[Unreleased]: https://github.com/zenith-56/zenith-dotfiles/compare/v0.3.1...HEAD

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### 0.3.5 - Cleanup & Improvements

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

#### Fixed
- install.sh now uses proper `set -euo pipefail`
- Sourced common.sh correctly in update.sh (was using wrong path)
- run.sh has proper flag parsing and verbose support

#### Code Review - Potential Cleanup (verify before removing)
- `zenith-vpn-toggle` - referenced in changelog 0.3.2 but script not found in repo
- `zenith-theme-sync` - script exists but seems redundant with matugen workflow
- Consider consolidating `zenith-theme-get/set/toggle` into single script with subcommands

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

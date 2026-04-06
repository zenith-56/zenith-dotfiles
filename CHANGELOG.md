# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### 0.4.2 - Code Hardening & Quality Improvements

#### Fixed
- `wall-selector.sh` now uses `set -euo pipefail` (was missing `-e` flag)
- `app-launcher.sh` now uses `set -euo pipefail` for consistency
- `zenith-dns` now properly handles comma-separated DNS servers by converting to space-delimited format
- `zenith-restart` now quotes command execution and checks command existence before restarting in `all` case
- `install/01-dependencies.sh` now uses `pushd`/`popd` instead of `cd -` to avoid `OLDPWD` failures
- `install.sh` now uses `pushd`/`popd` in `install_gum()` for safe directory navigation
- `update.sh` now checks for `yay` existence before attempting AUR package installation
- `zenith-webapp` now uses `$ZEN_*` color constants from `zenith-lib.sh` instead of raw ANSI escape codes
- `install/00-banner.sh` removed duplicate banner display (was printing twice)
- `install/02-services.sh` removed redundant `2>&1` after `&>/dev/null`
- `zenith-kb-layout` now reads all configured layouts from niri config and cycles through them instead of hardcoding `us`/`es` toggle
- `zenith-screen-recorder` replaced ineffective `wait` with `sleep` + `kill -0` check for cross-process PID handling
- `zenith-pkg` now uses shared `zen_fzf_args_install` and `zen_fzf_args_remove` from `zenith-lib.sh` instead of duplicating FZF arguments

#### Changed
- `zenith-restart` `all` case now iterates over an array and checks each command before pkill/restart
- `zenith-webapp` `build_exec` now properly quotes URL in desktop file Exec lines
- `zenith-kb-layout` toggle now dynamically reads all layouts from `input.kdl` and cycles through them in order

### 0.4.1 - Bug Fixes & Hardening

#### Fixed
- `zenith-check` now validates unified bin scripts instead of deprecated ones
- `zenith pkg missing` now returns correct exit codes (0 = all found, 1 = missing)
- `zenith-kb-layout` now uses `niri msg action reload-config` instead of `hyprctl`
- `zenith-screen-recorder` toggle now works correctly with PID file instead of blocking `wait`
- `zenith-power logout` now uses `niri msg action quit` instead of `hyprctl dispatch exit`
- Removed trailing commas from `waybar/config.jsonc` (now valid JSON for `jq`)
- Fixed `$UPDATED` variable being empty in `update.sh` dry-run mode
- Removed hardcoded `intel_backlight` from waybar modules (auto-detects device)
- `zenith-battery` now auto-detects battery device (`BAT*`) instead of hardcoding `BAT0`
- `zenith-network` now falls back to `nmcli`, `iwgetid`, and `iwdctl` when `impalactl` is unavailable
- `zenith-pkg remove` now uses `pacman -Rns` instead of `yay -Rns` for pacman packages
- Unified Spanish strings to English (`zenith-theme sync`, waybar battery tooltip)

#### Changed
- Pacman and AUR packages now install in a single batch call instead of one-by-one
- `zenith-power-profile` is now a thin wrapper that delegates to `zenith power profile`
- Waybar `power-profile.sh` and modules.json now use `zenith power profile` instead of standalone script
- All bin scripts now source `zenith-lib.sh` for shared functions (`zen_notify`, `zen_done`, `zen_check_deps`)
- `zenith-firewall` now uses `zen_notify` instead of raw `notify-send -i`
- `install/03-deploy-configs.sh` and `install/04-deploy-bin.sh` now use `set -euo pipefail`
- Removed shebangs from sourced files (`common.sh`, `03-deploy-configs.sh`, `04-deploy-bin.sh`)
- Cleaned hardcoded user paths from `fish_variables`
- Added `.gitignore` for generated configs and editor files
- Removed `zed` from CONFIGS array (no config directory exists)
- Added `mpv` to CONFIGS array

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

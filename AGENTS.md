# AGENTS.md - Zenith-Dotfiles Development Guide

## Overview

This document provides instructions for AI agents working with the Zenith-Dotfiles dotfiles repository.

## Repository Structure

```
zenith-dotfiles/
├── install.sh              # Main installer (delegates to install/)
├── install/                # Modular installation scripts
│   ├── run.sh
│   ├── 00-banner.sh
│   ├── 01-dependencies.sh
│   ├── 02-services.sh
│   ├── 03-deploy-configs.sh
│   ├── 04-deploy-bin.sh
│   ├── 05-directories.sh
│   ├── 06-fonts.sh
│   ├── 07-shell.sh
│   └── 08-display-manager.sh
├── update.sh              # Config updater
├── uninstall.sh           # Removal script
├── version                # Version file (e.g., 0.2.0)
├── .local/
│   └── bin/               # Zenith bin scripts
│   └── share/
│       ├── dark-mode.d/   # Dark mode scripts (darkman)
│       └── light-mode.d/  # Light mode scripts (darkman)
├── .config/
│   ├── btop/
│   ├── dunst/             # + Matugen template
│   ├── fastfetch/         # System info display
│   ├── fish/
│   ├── hypr/              # hyprlock + hypridle
│   ├── kitty/
│   ├── matugen/           # Config + templates
│   │   └── templates/     # Matugen templates
│   ├── niri/
│   ├── rofi/              # + scripts (launcher, wall-selector, etc.)
│   ├── swayosd/           # OSD config + template
│   ├── waybar/            # + scripts (braille-snake, etc.)
│   ├── yazi/
│   └── zed/
├── .github/
│   └── workflows/         # GitHub Actions (test-install, lint, validate, etc.)
└── images/                # Screenshots
```

## Zenith Bin Scripts

All scripts in `.local/bin/` use `#!/usr/bin/env bash` and follow this pattern:

| Category | Scripts |
|----------|---------|
| **Theme** | `zenith theme {get,set,toggle,sync}` |
| **OSD** | `zenith osd volume {up,down,toggle}`, `zenith osd brightness {up,down}` |
| **Music** | `zenith-music-show` |
| **Audio** | `zenith-mic`, `zenith volume {get,set}` |
| **Display** | `zenith brightness {get,set}` |
| **Network** | `zenith network {status,ssid}`, `zenith-firewall`, `zenith-dns` |
| **Battery** | `zenith battery {capacity,status,info}` |
| **Power** | `zenith power {off,reboot,lock,logout}`, `zenith power profile` |
| **Restart** | `zenith restart {waybar,dunst,swayosd,kitty,all}` |
| **Screenshot** | `zenith screenshot {full,region}` |
| **Screen Record** | `zenith-screen-recorder` |
| **Keyboard** | `zenith-kb-layout` |
| **Kitty** | `zenith restart kitty` |
| **Web Apps** | `zenith webapp {install,uninstall,list}` |
| **Packages** | `zenith pkg {install,remove,list,missing}` with `--aur`, `--flatpak` flags |
| **Utils** | `zenith-done` (deprecated, use `zen_done` from `zenith-lib.sh`) |

## Rofi Scripts

Scripts in `.config/rofi/scripts/`:

| Script | Description |
|--------|-------------|
| `launcher.sh` | Main launcher |
| `app-launcher.sh` | App launcher |
| `wall-selector.sh` | Wallpaper selector (uses awww) |
| `theme-menu.sh` | Theme selector (dark/light) |
| `theming-menu.sh` | Theming submenu |
| `power-menu.sh` | Power menu (lock, logout, reboot, poweroff) |
| `package-manager.sh` | Unified package management (install/uninstall) |
| `network-menu.sh` | Network config (Firewall + DNS) |

## Waybar Scripts

Scripts in `.config/waybar/scripts/`:

- `braille-snake.sh` - CPU animation with tooltip

## Matugen Templates

Located in `.config/matugen/templates/`:

| Template | Output |
|----------|--------|
| `colors.css` | Waybar |
| `colors.rasi` | Rofi |
| `dunstrc` | Dunst |
| `hyprlock.conf` | Hyprlock |
| `kitty.conf` | Kitty |
| `zed-theme.json` | Zed |
| `btop.theme` | Btop |
| `swayosd.css` | SwayOSD |

## GitHub Actions Workflows

| Workflow | Purpose |
|----------|---------|
| `test-install.yml` | Structure, syntax, permissions, bin count |
| `shellcheck.yml` | ShellCheck linting |
| `enforce-standards.yml` | Shebangs, hardcoded paths, TODO/FIXME |
| `validate-configs.yml` | JSON, TOML, KDL, CSS, Rasi validation |
| `release.yml` | Release automation |

## Pre-Release Checklist

Before creating a release, verify:

1. **Config deployments work**:
   ```bash
   ./install.sh --help 2>/dev/null || true
   ```

2. **Script permissions**:
   ```bash
   chmod +x install.sh update.sh install/*.sh
   chmod +x .config/rofi/scripts/*.sh
   chmod +x .config/waybar/scripts/*.sh
   chmod +x .local/bin/zenith-*
   chmod +x .local/share/dark-mode.d/*.sh
   chmod +x .local/share/light-mode.d/*.sh
   ```

3. **Shell scripts use portable shebang**:
   ```bash
   # Use #!/usr/bin/env bash instead of #!/bin/bash
   head -1 .local/bin/zenith-*
   ```

4. **Version bump**:
   ```bash
   echo "0.2.0" > version
   ```

5. **Git status clean**:
   ```bash
   git status
   git diff --stat
   ```

6. **Run GitHub Actions**:
   - Workflow: `.github/workflows/test-install.yml`
   - Should pass on push to main/dev

## Release Process

1. Create a new branch: `git checkout -b release/vX.Y.Z`
2. Update version in `version` file
3. Test installation: `./install.sh` (in VM or test environment)
4. Commit changes: `git add . && git commit -m "Release vX.Y.Z"`
5. Create tag: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
6. Push: `git push origin master --tags`

## Common Tasks

### Add new config
Add directory to `CONFIGS` array in `install/common.sh`:
```bash
CONFIGS=(... newconfig ...)
```

### Add new package
Add to `PACMAN_PACKAGES` or `AUR_PACKAGES` in `install/common.sh`:
```bash
PACMAN_PACKAGES=(... newpackage ...)
# or
AUR_PACKAGES=(... newpackage ...)
```

### Add darkman script
Place in `.local/share/dark-mode.d/` or `light-mode.d/`

### Add zenith-bin
Create script in `.local/bin/` with:
- `#!/usr/bin/env bash`
- `set -euo pipefail`
- Error handling (check if commands exist)
- Exit codes for failures
- Source `zenith-lib.sh` for shared functions

### Add waybar module
Create script in `.config/waybar/scripts/`:
- Output valid JSON format
- Use zenith-bins for data fetching

### Add rofi script
Create script in `.config/rofi/scripts/`:
- Use `common.sh` for shared functions
- Follow existing patterns

## Config Validation

Before restarting services, validate configs:

```bash
# Waybar JSON
jq empty ~/.config/waybar/config

# Niri KDL (check braces)
for f in ~/.config/niri/*.kdl; do
  open=$(grep -o '{' "$f" | wc -l)
  close=$(grep -o '}' "$f" | wc -l)
  echo "$f: $open open, $close close"
done

# Matugen templates
ls ~/.config/matugen/templates/
```

## Changelog

See `CHANGELOG.md` for the full version history. When making changes, always update the changelog under the `[Unreleased]` section.

## Notes

- This is a dotfiles repo, not a traditional software project
- All scripts must use `#!/usr/bin/env bash`
- All scripts must use `set -euo pipefail`
- Use `trap` for cleanup when scripts create temporary resources
- Use error handling (check if commands exist, check if files exist)
- Waybar modules should output JSON format
- Rofi scripts should use `common.sh` for shared functions and rofi for interactive UI
- Package scripts should use FZF for fuzzy selection
- All configs in `common.sh` must match actual files/dirs
- When adding new features, add an entry to CHANGELOG.md under `[Unreleased]`

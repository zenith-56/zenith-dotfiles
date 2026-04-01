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
├── version                # Version file (e.g., 0.1.5)
├── .local/
│   └── bin/               # Zenith bin scripts
│   └── share/
│       ├── dark-mode.d/   # Dark mode scripts (darkman)
│       └── light-mode.d/   # Light mode scripts (darkman)
├── .config/
│   ├── kitty/
│   ├── btop/
│   ├── dunst/             # + Matugen template
│   ├── fastfetch/         # System info display
│   ├── fish/
│   ├── hypr/
│   ├── matugen/           # Config + templates
│   │   └── templates/     # Matugen templates
│   ├── niri/
│   ├── rofi/
│   ├── swayosd/          # OSD config + template
│   ├── waybar/           # + scripts (battery, network, volume, brightness)
│   ├── yazi/             # Terminal file manager
│   └── zed/
├── .github/
│   └── workflows/         # GitHub Actions
└── images/
```

## Zenith Bin Scripts

All scripts in `.local/bin/` use `#!/usr/bin/env bash` and follow this pattern:

| Category | Scripts |
|----------|---------|
| **Theme** | `zenith-theme-get`, `zenith-theme-set`, `zenith-theme-toggle` |
| **OSD** | `zenith-swayosd-volume`, `zenith-swayosd-brightness` |
| **Music** | `zenith-music-show` |
| **Audio** | `zenith-mic`, `zenith-volume-*` |
| **Display** | `zenith-brightness-*` |
| **Network** | `zenith-network-status`, `zenith-network-ssid` |
| **Battery** | `zenith-battery-capacity`, `zenith-battery-status` |
| **Power** | `zenith-lock`, `zenith-power-off`, `zenith-reboot`, `zenith-logout` |
| **Restart** | `zenith-restart-all`, `zenith-restart-waybar`, `zenith-restart-dunst`, `zenith-restart-swayosd` |
| **Screenshot** | `zenith-screenshot`, `zenith-screenshot-region` |
| **Screen Record** | `zenith-screen-recorder` |
| **Keyboard** | `zenith-kb-layout` |
| **Kitty** | `zenith-reload-kitty` |
| **Web Apps** | `zenith-webapp-install`, `zenith-webapp-uninstall` |
| **Packages** | `zenith-pkg-install`, `zenith-pkg-aur-install`, `zenith-pkg-missing`, `zenith-pkg-remove` |
| **Utils** | `zenith-done` |

## Waybar Scripts

Scripts in `.config/waybar/scripts/`:

- `braille-snake.sh` - CPU animation (enhanced with tooltip)

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
   echo "0.1.5" > version
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
6. Push: `git push origin main --tags`

## Common Tasks

- **Add new config**: Add directory to `CONFIGS` array in `install/03-deploy-configs.sh`
- **Add new package**: Add to `PACMAN_PACKAGES` or `AUR_PACKAGES` in `install/01-dependencies.sh`
- **Add darkman script**: Place in `.local/share/dark-mode.d/` or `light-mode.d/`
- **Add zenith-bin**: Create script in `.local/bin/` with proper error handling
- **Add waybar module**: Create script in `.config/waybar/scripts/` using zenith-bins

## Notes

- This is a dotfiles repo, not a traditional software project
- No lint/typecheck commands configured (bash scripts are simple)
- All scripts must use `#!/usr/bin/env bash`
- Use error handling (check if commands exist, check if files exist)
- Waybar modules should output JSON format

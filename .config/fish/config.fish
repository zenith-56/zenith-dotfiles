# =============================================================================
# Fish Configuration
# =============================================================================
# Description : Interactive shell configuration with custom PATHs, aliases,
#               and Neovim/Kitty environment variables.
# =============================================================================

if status is-interactive

    # ── PATH ──────────────────────────────────────────────────────────
    # In bash:  export PATH="/ruta:$PATH"
    # In fish:  fish_add_path /ruta
    # fish_add_path persists PATH in universal variables
    # (fish_variables). Only adds if not already present.

    fish_add_path ~/.local/bin
    fish_add_path ~/.cargo/bin
    fish_add_path ~/.config/rofi/scripts

    # ── ALIAS ─────────────────────────────────────────────────────────
    # In bash: alias ls='ls --color=auto'
    # In fish: alias ls 'ls --color=auto'

    alias ls 'ls --color=auto'
    alias grep 'grep --color=auto'
    alias la 'ls -la'
    alias ll 'ls -l'
    alias .. 'cd ..'
    alias ... 'cd ../..'

    # ── VARIABLES ─────────────────────────────────────────────────────
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx TERMINAL kitty

    # ── GREETING ──────────────────────────────────────────────────────
    set fish_greeting

    # ── CURSOR ────────────────────────────────────────────────────────
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore

end

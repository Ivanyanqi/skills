---
name: bootstrap-mac-terminal
description: Install and configure this Mac terminal suite on a fresh machine: iTerm2, JetBrains Mono Nerd Font, oh-my-zsh, powerlevel10k, eza aliases, and the lightweight Tokyo Night Neovim stack. Use when setting up a new Mac or reapplying this exact terminal environment with automation-first behavior.
---

# Bootstrap Mac Terminal

Use this skill when the user wants to recreate this terminal setup on a new Mac or refresh the same setup on an existing Mac.

## What this skill installs

- Homebrew if missing
- iTerm2
- JetBrains Mono Nerd Font
- oh-my-zsh
- powerlevel10k
- zsh-autosuggestions
- zsh-syntax-highlighting
- eza
- neovim
- tree-sitter-cli
- ripgrep
- fd

## What this skill configures

- `~/.zshrc` for `powerlevel10k`, plugin loading, aliases, and `EZA_COLORS`
- `~/.p10k.zsh`
- `~/.config/nvim`
- the default iTerm2 profile with Tokyo Night colors, JetBrains Mono Nerd Font, transparency `0.1`, blur enabled, and minimum contrast `0.12`

## Workflow

1. Run `scripts/install_homebrew_and_packages.sh`.
2. Run `scripts/setup_oh_my_zsh_and_p10k.sh`.
3. Run `scripts/setup_iterm2_profile.sh`.
4. Run `scripts/setup_nvim.sh`.
5. Run `scripts/install_or_sync_skill.sh` to install or refresh the global copy in `~/.codex/skills`.

## Safety rules

- Back up existing `~/.zshrc`, `~/.p10k.zsh`, and `~/.config/nvim` before replacement.
- Confirm before overwriting existing shell or Neovim config.
- Do not import personal runtime blocks such as `conda`, `nvm`, or `bun`.
- Do not assume the target machine has the same wallpaper file.

## References

- Read `references/install-notes.md` before first install if the machine is brand new.
- Read `references/recovery.md` if a user wants to revert or troubleshoot this setup.

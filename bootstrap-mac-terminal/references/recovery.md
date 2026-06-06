# Recovery

- Shell backups are created as `~/.zshrc.codex-bak.<timestamp>` and `~/.p10k.zsh.codex-bak.<timestamp>`.
- Neovim backups are created as `~/.config/nvim.codex-bak.<timestamp>`.
- If the shell prompt looks wrong, restore the latest `~/.zshrc` and `~/.p10k.zsh` backup, then open a new terminal window.
- If `Neovim` fails to start, restore the latest `~/.config/nvim` backup and rerun the setup script after checking plugin network access.
- If `iTerm2` changes do not appear, quit `iTerm2`, relaunch it, and rerun the profile setup script after confirming the preference file exists.

---
name: bootstrap-mac-terminal
description: 在全新 Mac 上安装并配置这套终端环境：iTerm2、JetBrains Mono Nerd Font、oh-my-zsh、powerlevel10k、eza 别名，以及轻量版 Tokyo Night Neovim。适合新机器初始化，或在现有机器上自动化重装这套终端配置时使用。
---

# 安装 Mac 终端套装

当用户想在一台新 Mac 上复刻这套终端环境，或者在现有机器上重新应用同一套配置时，使用这个 skill。

## 这个 Skill 会安装什么

- 缺失时自动安装 Homebrew
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

## 这个 Skill 会配置什么

- `~/.zshrc`，包含 `powerlevel10k`、插件加载、别名和 `EZA_COLORS`
- `~/.p10k.zsh`
- `~/.config/nvim`
- 默认 iTerm2 profile，应用 Tokyo Night 配色、JetBrains Mono Nerd Font、透明度 `0.1`、模糊开启、最小对比度 `0.12`

## 使用流程

1. 运行 `scripts/install_homebrew_and_packages.sh`
2. 运行 `scripts/setup_oh_my_zsh_and_p10k.sh`
3. 运行 `scripts/setup_iterm2_profile.sh`
4. 运行 `scripts/setup_nvim.sh`
5. 运行 `scripts/install_or_sync_skill.sh`，把这份 skill 安装或同步到 `~/.codex/skills`

## 安全规则

- 替换前先备份现有的 `~/.zshrc`、`~/.p10k.zsh` 和 `~/.config/nvim`
- 覆盖现有 shell 或 Neovim 配置前先确认
- 不导入 `conda`、`nvm`、`bun` 这类个人运行时初始化内容
- 不假设目标机器拥有同一张壁纸文件

## 参考说明

- 如果是全新机器，首次安装前先看 `references/install-notes.md`
- 如果用户想回退或排查问题，查看 `references/recovery.md`

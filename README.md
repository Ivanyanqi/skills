# Skills

这是一个独立管理的 Codex skills 仓库，方便在不同机器之间复用，也方便分享给其他客户端使用。

## 当前包含的 Skill

### `bootstrap-mac-terminal`

用于复刻这套 Mac 终端环境：

- `iTerm2`
- `JetBrains Mono Nerd Font`
- `oh-my-zsh`
- `powerlevel10k`
- `eza` 别名
- 轻量版 Tokyo Night 风格 `Neovim`

说明文件：

- [bootstrap-mac-terminal/SKILL.md](/Users/ivanqi/Documents/aiworkspace/projects/skills/bootstrap-mac-terminal/SKILL.md)

### `terminal-setup`

一键安装 yanqi 当前这套终端配置（Ghostty + zinit + powerlevel10k + eza），替代旧版 `bootstrap-mac-terminal`：

- `Ghostty`（TokyoNight 主题，JetBrainsMono Nerd Font）
- `JetBrainsMono Nerd Font`
- `zinit` 插件管理器（替代 oh-my-zsh）
- `powerlevel10k` 提示符（内置配置，无需走向导）
- `eza` 别名（ls/la/ll）

说明文件：[terminal-setup/SKILL.md](./terminal-setup/SKILL.md)

## 安装 Skill 到 Codex

先把这个仓库 clone 到本地，然后运行仓库级安装脚本。

示例：

```bash
chmod +x install-skill.sh
./install-skill.sh
```

如果只想安装某一个 skill：

```bash
./install-skill.sh bootstrap-mac-terminal
```

## 更新流程

1. 在这个仓库里新增或修改 skill。
2. 提交并推送到 GitHub。
3. 在目标机器运行 `./install-skill.sh`，同步到 `~/.codex/skills`。

## 说明

- 这个仓库里的 skills 面向兼容 Codex 的客户端。
- 每个 skill 都应当自包含，包含自己的 `SKILL.md`、脚本、资源文件和参考说明。

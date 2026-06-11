# Skills

这是一个独立管理的 Codex skills 仓库，方便在不同机器之间复用，也方便分享给其他客户端使用。

## 当前包含的 Skill

### `mac-dev-setup` ⭐ 推荐

Mac 终端开发环境完整部署，当前主力 Skill。在新 Mac 或已有配置的 Mac 上一键安装并配置完整的终端开发环境，支持冲突检测与迁移。

包含内容：

- **终端**：Ghostty（TokyoNight 主题、背景透明、Quick Terminal）
- **提示符**：powerlevel10k
- **插件管理**：zinit（异步懒加载，启动极快）
- **zsh 插件**：zsh-autosuggestions、zsh-history-substring-search、fast-syntax-highlighting、zsh-autopair、you-should-use、forgit
- **版本管理**：mise（统一替代 nvm / pyenv / jenv）
- **Python 工具链**：uv
- **编辑器**：Neovim + LazyVim
- **现代 CLI**：bat、eza、fzf、zoxide、lazygit、ripgrep、fd、btop、git-delta、gh、yq、tlrc、httpie
- **字体**：JetBrainsMono Nerd Font、MesloLGS NF、Hack Nerd Font

配置文件模板：`ghostty.config`、`zshrc`、`zshenv`、`zprofile`、`gitconfig`、`mise-config`

说明文件：[mac-dev-setup/SKILL.md](./mac-dev-setup/SKILL.md)
快速上手：[mac-dev-setup/references/quickstart.md](./mac-dev-setup/references/quickstart.md)

---

### `terminal-setup`

yanqi 当前终端配置的轻量版（Ghostty + zinit + powerlevel10k + eza），适合只需要配置 shell 环境、不需要完整工具链的场景。

- `Ghostty`（TokyoNight 主题，JetBrainsMono Nerd Font）
- `zinit` 插件管理器（替代 oh-my-zsh）
- `powerlevel10k` 提示符（内置配置，无需走向导）
- `eza` 别名（ls / la / ll）

说明文件：[terminal-setup/SKILL.md](./terminal-setup/SKILL.md)

---

### `bootstrap-mac-terminal` （旧版，已归档）

早期版本，基于 iTerm2 + oh-my-zsh，已被 `mac-dev-setup` 取代，保留供参考。

- iTerm2、JetBrains Mono Nerd Font、oh-my-zsh、powerlevel10k、轻量版 Neovim

说明文件：[bootstrap-mac-terminal/SKILL.md](./bootstrap-mac-terminal/SKILL.md)

---

## 安装 Skill 到 Codex

先把这个仓库 clone 到本地，然后运行安装脚本：

```bash
chmod +x install-skill.sh

# 安装所有 skill
./install-skill.sh

# 只安装某一个 skill
./install-skill.sh mac-dev-setup
./install-skill.sh terminal-setup
```

脚本会将 skill 目录同步到 `~/.codex/skills/`，现有目录会自动备份为 `.codex-sync-old` 后缀。

## 更新流程

1. 在这个仓库里新增或修改 skill
2. 提交并推送到 GitHub
3. 在目标机器运行 `./install-skill.sh`，同步到 `~/.codex/skills`

## 说明

- 每个 skill 都应当自包含，包含自己的 `SKILL.md`、脚本、资源文件和参考说明
- `mac-dev-setup` 是当前主力，新机器优先使用这个

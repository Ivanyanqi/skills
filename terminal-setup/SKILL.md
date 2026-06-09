---
name: terminal-setup
description: "一键安装 yanqi 的终端配置套件（Ghostty + zsh + zinit + powerlevel10k + eza）。在全新 Mac 或已有配置的 Mac 上自动完成所有安装和配置，幂等执行（已安装的跳过，冲突文件询问用户）。当用户提到「安装终端配置」、「配置终端」、「一键装终端」、「terminal setup」、「新 Mac 配置」、「迁移终端配置」时使用。"
---

# Terminal Setup Skill

一键安装 yanqi 的终端配置套件，支持全新 Mac 和已有配置的 Mac。

## 安装内容

| 组件 | 说明 |
|------|------|
| Homebrew | 包管理器，其他组件的前置依赖 |
| Ghostty | 终端应用（TokyoNight 主题，JetBrainsMono Nerd Font） |
| JetBrainsMono Nerd Font | 字体，p10k 图标必需 |
| eza | 现代 ls 替代品，带颜色和图标 |
| zinit | zsh 插件管理器 |
| powerlevel10k | zsh 提示符主题 |
| ~/.zshrc | zsh 配置（zinit + p10k + eza 别名） |
| ~/.p10k.zsh | p10k 提示符配置（内置，无需走向导） |
| ~/.config/ghostty/config | Ghostty 配置文件 |

## 执行方式

读取 `scripts/install.sh` 并执行：

```bash
bash /Users/yanqi/.catpaw/skills/terminal-setup/scripts/install.sh
```

或者让用户直接运行：

```bash
bash ~/.catpaw/skills/terminal-setup/scripts/install.sh
```

## 冲突处理策略

遇到已存在的配置文件时，询问用户：
- **b** — 备份原文件（加 `.backup-YYYYMMDD` 后缀）再覆盖
- **s** — 跳过，保留原文件
- **d** — 查看差异（diff）后再决定

## Asset 文件说明

- `assets/zshrc` — ~/.zshrc 模板
- `assets/p10k.zsh` — ~/.p10k.zsh 完整配置
- `assets/ghostty-config` — ~/.config/ghostty/config 配置

## 安装后操作

安装完成后提示用户：

```
✅ 安装完成！执行以下命令激活配置：

  exec zsh

首次启动会自动下载 zinit 插件（约需 30 秒），之后每次启动都会很快。
```

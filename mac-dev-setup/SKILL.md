---
name: mac-dev-setup
description: "Mac 终端开发环境一键部署 Skill。在新 Mac 或已有配置的 Mac 上安装并配置完整的终端开发环境。涵盖：Homebrew、Ghostty 终端、powerlevel10k 提示符、zinit 插件体系（autosuggestions/fast-syntax-highlighting/history-substring-search/autopair/you-should-use/forgit）、mise 版本管理（替换 nvm/pyenv/jenv）、uv Python 工具链、现代 CLI 工具（bat/eza/fzf/zoxide/lazygit/ripgrep/fd/btop/git-delta/gh/yq/tlrc）、neovim + LazyVim 编辑器，以及完整的 zshrc/zshenv/zprofile/gitconfig 配置文件。已安装的组件询问跳过/更新/覆盖；冲突工具（nvm/pyenv/starship/oh-my-zsh）强制迁移。当用户提到以下任意场景时必须使用此 Skill：新 Mac 初始化、配置终端环境、搭建开发环境、装终端工具、setup terminal、mac setup、dev environment、一键配置、终端迁移、把 nvm 换成 mise、迁移 pyenv、配置 zshrc、装 lazyvim、装 neovim、配置 powerlevel10k、装 zinit、配置 zsh 插件、装 ghostty、配置 git-delta、现代化终端工具链。"
---

# Mac 终端开发环境一键部署

这套 Skill 会在 Mac 上部署一套完整、现代、高性能的终端开发环境。支持全新 Mac 和已有配置的 Mac，对冲突工具会询问用户处理策略。

## 执行前准备

在开始之前，先向用户确认以下信息：

1. **目标机器**：是全新 Mac 还是已有部分配置的 Mac？
2. **Java 需求**：是否需要安装 Java？如果需要，默认安装 Temurin 21（LTS）。
3. **git 信息**：姓名和邮箱（用于配置 `~/.gitconfig`）。

如果用户说"直接开始"或"全部默认"，则：Java 按需安装（跳过），git 信息从现有 `~/.gitconfig` 读取，读不到则安装完成后提示用户手动填写。

## 执行流程

### Step 1：运行检测脚本

```bash
bash <skill_dir>/scripts/install.sh --detect-only
```

读取输出，解析各组件的安装状态。输出格式为：
```
DETECT:homebrew:installed
DETECT:ghostty:missing
DETECT:conflict:nvm
DETECT:conflict:pyenv
...
```

### Step 2：向用户展示检测结果并确认策略

将检测结果整理成清单展示给用户，格式如下：

```
✅ 已安装，将跳过：Homebrew、bat、eza ...
⚠️  已安装，询问处理方式：neovim（现有配置将被 LazyVim 覆盖）
🔄 检测到冲突，将强制迁移：nvm → mise、pyenv → mise
❌ 未安装，将新装：Ghostty、zinit、powerlevel10k ...
```

对于 `⚠️` 类组件，逐一询问用户：
- **跳过**：保持现有安装和配置不变
- **仅更新**：更新到最新版本，不覆盖配置文件
- **覆盖配置**：更新版本 + 用本套配置文件覆盖

对于 `🔄` 冲突类，告知用户将强制迁移，询问是否继续。

### Step 3：执行安装

根据用户确认的策略，调用安装脚本：

```bash
# 完整安装（新机器）
bash <skill_dir>/scripts/install.sh --all

# 跳过某些组件
bash <skill_dir>/scripts/install.sh --all --skip neovim --skip gh

# 仅覆盖配置文件，不重装工具
bash <skill_dir>/scripts/install.sh --config-only
```

安装过程中实时展示进度。如果某步失败，记录错误并继续后续步骤，最后汇总失败项。

### Step 4：配置文件写入

安装脚本完成后，将配置文件模板写入用户 home 目录。

**写入前必须备份现有文件**：
```bash
for f in ~/.zshrc ~/.zshenv ~/.zprofile ~/.gitconfig; do
  [ -f "$f" ] && cp "$f" "${f}.backup-$(date +%Y%m%d%H%M%S)"
done
```

然后从 `references/` 目录复制模板：
- `references/ghostty.config.template` → `~/.config/ghostty/config`（写入前确保目录存在：`mkdir -p ~/.config/ghostty`）
- `references/zshrc.template` → `~/.zshrc`
- `references/zshenv.template` → `~/.zshenv`
- `references/zprofile.template` → `~/.zprofile`
- `references/gitconfig.template` → `~/.gitconfig`（如果用户已有 git 信息，保留 `[user]` 部分）

**gitconfig 特殊处理**：如果用户已有 `~/.gitconfig` 且包含 `[user]` 配置，提取 name/email 后合并到新配置中，不丢失用户信息。

### Step 5：mise 版本初始化

安装 mise 后，询问用户需要哪些语言版本：

```
mise 已安装。请选择要初始化的运行时（可多选，也可跳过后手动安装）：
- Node.js（推荐 LTS 22）
- Python（推荐 3.12）
- Java Temurin 21（LTS）
- Maven 3.9
```

根据用户选择执行：
```bash
mise install node@22
mise use --global node@22
# ... 其他选择的版本
```

### Step 6：LazyVim 初始化

如果安装了 neovim，执行首次插件同步：
```bash
PATH="$HOME/.local/share/mise/shims:/opt/homebrew/bin:$PATH" \
  nvim --headless "+Lazy! sync" +qa 2>&1 | grep -E "Finished|Error|Failed" | tail -20
```

告知用户：首次打开 `nvim` 时会自动下载剩余插件（约 30 秒），这是正常现象。

### Step 7：验证

运行验证检查：
```bash
bash <skill_dir>/scripts/install.sh --verify
```

输出格式：
```
VERIFY:zsh_startup_time:0.15s ✅
VERIFY:homebrew:ok ✅
VERIFY:mise:ok ✅
VERIFY:nvim:ok ✅
...
```

将验证结果整理后展示给用户，标注任何需要手动处理的项目。

### Step 8：收尾提示

安装完成后，告知用户：

1. **重启终端**（或新开一个窗口）让所有配置生效
2. 首次打开终端会触发 p10k 配置向导，按提示完成字体和样式选择
3. 如果字体显示异常，在终端设置中将字体改为 `JetBrainsMono Nerd Font`
4. 备份文件保存在原路径加 `.backup-时间戳` 后缀
5. 如需恢复：`cp ~/.zshrc.backup-XXXXXX ~/.zshrc`
6. 所有工具的详细使用方式请参考 `references/quickstart.md`，涵盖每个工具的常用命令和 LazyVim 快捷键速查表

## 冲突处理规则

| 冲突工具 | 处理方式 |
|---------|---------|
| nvm | 从 PATH 清除，unset NVM_DIR，迁移到 mise |
| pyenv | 从 PATH 清除，unset PYENV_ROOT，迁移到 mise |
| jenv | 从 PATH 清除，迁移到 mise |
| conda/anaconda | 注释掉 conda init 块，提示用户手动卸载 |
| starship | 注释掉 starship init，切换到 powerlevel10k |
| oh-my-zsh | 保留 OMZ 插件片段（zinit snippet OMZP::），卸载 OMZ 框架本体 |
| 系统 python | 不动，mise 的 shims 会优先覆盖 |

## 注意事项

- 所有配置文件**不包含**任何公司内网相关内容（无 `.moa_tools`、无 `.moaextrc`）
- 安装脚本需要网络连接（Homebrew、GitHub）
- Apple Silicon (arm64) 和 Intel (x86_64) 均支持，Homebrew 路径自动适配
- 整个安装过程约 10-20 分钟（取决于网速）

## 参考文件说明

- `scripts/install.sh` — 核心安装脚本，读取此文件了解每个安装步骤的细节
- `references/ghostty.config.template` — Ghostty 终端配置模板（主题、字体、透明度、分屏快捷键、Quick Terminal）；写入路径为 `~/.config/ghostty/config`
- `references/zshrc.template` — zshrc 完整模板
- `references/zshenv.template` — zshenv 完整模板
- `references/zprofile.template` — zprofile 模板
- `references/gitconfig.template` — gitconfig 模板（含 delta 配置）
- `references/mise-config.template` — mise 全局配置模板
- `references/quickstart.md` — **安装完成后的快速上手指南**，涵盖所有工具、插件、命令的常用使用方式，包括：powerlevel10k 配置、zinit 插件管理、mise 版本管理、uv Python 工具链、fzf/zoxide/eza/bat/fd/ripgrep/lazygit/git-delta/gh/btop/httpie/yq/tlrc 的完整用法，以及 LazyVim 编辑器的基础操作和快捷键速查表。安装完成后告知用户可参考此文件快速上手。

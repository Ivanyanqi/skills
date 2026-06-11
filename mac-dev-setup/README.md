# mac-dev-setup

Mac 终端开发环境一键部署 Skill。在新 Mac 或已有配置的 Mac 上安装并配置完整的终端开发环境。

---

## 包含内容

| 类别 | 工具 |
|------|------|
| **终端** | Ghostty |
| **提示符** | powerlevel10k |
| **插件管理** | zinit |
| **zsh 插件** | zsh-autosuggestions、zsh-history-substring-search、fast-syntax-highlighting、zsh-autopair、you-should-use、forgit |
| **版本管理** | mise（替代 nvm / pyenv / jenv） |
| **Python 工具链** | uv |
| **编辑器** | Neovim + LazyVim |
| **现代 CLI** | bat、eza、fzf、zoxide、lazygit、ripgrep、fd、btop、git-delta、gh、yq、tlrc、httpie |
| **字体** | JetBrainsMono Nerd Font、MesloLGS NF、Hack Nerd Font |

---

## 快速开始

### 全新安装

```bash
# 1. 检测当前环境
bash scripts/install.sh --detect-only

# 2. 完整安装所有组件
bash scripts/install.sh --all

# 3. 验证安装结果
bash scripts/install.sh --verify
```

### 跳过特定组件

```bash
bash scripts/install.sh --all --skip neovim --skip gh
```

### 仅写入配置文件（不重装工具）

```bash
bash scripts/install.sh --config-only
```

---

## 配置文件

安装完成后，以下配置文件会被写入 home 目录（写入前自动备份原文件）：

| 模板文件 | 写入路径 | 说明 |
|---------|---------|------|
| `references/ghostty.config.template` | `~/.config/ghostty/config` | Ghostty 终端：主题、字体、透明度、分屏、Quick Terminal |
| `references/zshrc.template` | `~/.zshrc` | 插件加载、别名、工具初始化 |
| `references/zshenv.template` | `~/.zshenv` | 环境变量、PATH |
| `references/zprofile.template` | `~/.zprofile` | 登录 shell 配置 |
| `references/gitconfig.template` | `~/.gitconfig` | git 配置，含 git-delta pager |
| `references/mise-config.template` | `~/.config/mise/config.toml` | mise 全局版本配置 |

备份文件保存在原路径加 `.backup-时间戳` 后缀，如需恢复：

```bash
cp ~/.zshrc.backup-20240101120000 ~/.zshrc
```

---

## 冲突处理

| 冲突工具 | 处理方式 |
|---------|---------|
| nvm | 从 PATH 清除，迁移到 mise |
| pyenv | 从 PATH 清除，迁移到 mise |
| jenv | 从 PATH 清除，迁移到 mise |
| conda / anaconda | 注释掉 conda init 块，提示手动卸载 |
| starship | 注释掉 starship init，切换到 powerlevel10k |
| oh-my-zsh | 保留 OMZ 插件片段（zinit snippet OMZP::），卸载 OMZ 框架本体 |

---

## 安装后

1. **重启终端**（或新开窗口）让所有配置生效
2. 首次打开终端会触发 **p10k 配置向导**，按提示选择样式
3. 字体显示异常时，在终端设置中将字体改为 `JetBrainsMono Nerd Font`
4. 首次打开 `nvim` 会自动下载 LazyVim 插件（约 30 秒）
5. 详细使用方式参考 **[references/quickstart.md](references/quickstart.md)**

---

## 文件结构

```
mac-dev-setup/
├── README.md                        # 本文件
├── SKILL.md                         # Agent 执行指令
├── scripts/
│   └── install.sh                   # 核心安装脚本
└── references/
    ├── quickstart.md                # 安装后快速上手指南（所有工具用法）
    ├── ghostty.config.template      # Ghostty 终端配置
    ├── zshrc.template               # ~/.zshrc
    ├── zshenv.template              # ~/.zshenv
    ├── zprofile.template            # ~/.zprofile
    ├── gitconfig.template           # ~/.gitconfig
    └── mise-config.template         # ~/.config/mise/config.toml
```

---

## 注意事项

- 所有配置文件**不包含**任何公司内网相关内容
- 需要网络连接（Homebrew、GitHub）
- Apple Silicon (arm64) 和 Intel (x86_64) 均支持，Homebrew 路径自动适配
- 整个安装过程约 10–20 分钟（取决于网速）

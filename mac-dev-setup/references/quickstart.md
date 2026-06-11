# 终端环境快速上手指南

> 安装完成后，重启终端（或 `source ~/.zshrc`）让所有配置生效，然后参考本文档快速掌握每个工具。

---

## 目录

- [Ghostty — 终端模拟器](#ghostty--终端模拟器)
- [Shell 体验增强](#shell-体验增强)
  - [powerlevel10k — 提示符](#powerlevel10k--提示符)
  - [zinit — 插件管理器](#zinit--插件管理器)
  - [zsh-autosuggestions — 命令建议](#zsh-autosuggestions--命令建议)
  - [zsh-history-substring-search — 历史搜索](#zsh-history-substring-search--历史搜索)
  - [fast-syntax-highlighting — 语法高亮](#fast-syntax-highlighting--语法高亮)
  - [zsh-autopair — 括号自动配对](#zsh-autopair--括号自动配对)
  - [you-should-use — 别名提醒](#you-should-use--别名提醒)
  - [forgit — 交互式 Git 操作](#forgit--交互式-git-操作)
- [版本管理](#版本管理)
  - [mise — 多语言版本管理](#mise--多语言版本管理)
  - [uv — Python 工具链](#uv--python-工具链)
- [现代 CLI 工具](#现代-cli-工具)
  - [fzf — 模糊搜索](#fzf--模糊搜索)
  - [zoxide — 智能目录跳转](#zoxide--智能目录跳转)
  - [eza — 文件列表](#eza--文件列表)
  - [bat — 文件查看](#bat--文件查看)
  - [fd — 文件搜索](#fd--文件搜索)
  - [ripgrep — 内容搜索](#ripgrep--内容搜索)
  - [lazygit — Git 可视化](#lazygit--git-可视化)
  - [git-delta — Diff 高亮](#git-delta--diff-高亮)
  - [gh — GitHub CLI](#gh--github-cli)
  - [btop — 系统监控](#btop--系统监控)
  - [httpie — HTTP 调试](#httpie--http-调试)
  - [yq — YAML/JSON 处理](#yq--yamljson-处理)
  - [tlrc — 命令速查](#tlrc--命令速查)
- [编辑器](#编辑器)
  - [LazyVim — Neovim 配置框架](#lazyvim--neovim-配置框架)

---

## Ghostty — 终端模拟器

配置文件路径：`~/.config/ghostty/config`，修改后重启 Ghostty 生效。

**快捷键**

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+\`` | 全局唤出 / 收起 Quick Terminal（任意应用内均可触发） |
| `Cmd+D` | 向右分屏 |
| `Cmd+Shift+Enter` | 当前分屏最大化 / 还原 |
| `Cmd+Shift+H/J/K/L` | 在分屏之间移动焦点（左/下/上/右） |
| `Cmd+T` | 新建 Tab |
| `Cmd+W` | 关闭当前 Tab / 分屏 |
| `Cmd++` / `Cmd+-` | 增大 / 减小字号 |
| `Cmd+0` | 重置字号 |

**Quick Terminal（快速终端）**

按 `Ctrl+\`` 可在任意应用上方弹出一个半屏终端，松开后自动隐藏（`quick-terminal-autohide = true`）。当前配置为从顶部弹出，占屏幕高度 50%。

**主要配置说明**

| 配置项 | 当前值 | 说明 |
|--------|--------|------|
| `theme` | `TokyoNight` | 配色主题 |
| `background-opacity` | `0.88` | 背景透明度（0-1） |
| `background-blur-radius` | `20` | 背景模糊半径 |
| `font-family` | `JetBrainsMono Nerd Font` | 字体（含 Nerd Font 图标） |
| `font-size` | `14` | 字号 |
| `font-thicken` | `true` | 字体加粗渲染（Retina 屏更清晰） |
| `scrollback-limit` | `50000000` | 滚动缓冲行数（约 5000 万行） |
| `copy-on-select` | `clipboard` | 选中文字自动复制到系统剪贴板 |
| `cursor-style` | `block` | 光标样式（block / bar / underline） |

**修改配置**

```bash
nvim ~/.config/ghostty/config    # 编辑配置文件
```

修改后重启 Ghostty（`Cmd+Q` 退出再重新打开）即可生效。

---

## Shell 体验增强

### powerlevel10k — 提示符

提供信息丰富的终端提示符，显示 git 状态、当前语言版本、命令执行时间等。

**首次配置**

```bash
p10k configure    # 启动交互式配置向导，按提示选择样式
```

**重新配置**

```bash
p10k configure    # 随时重新运行，覆盖之前的选择
```

**手动编辑**

配置文件在 `~/.p10k.zsh`，可以直接编辑调整显示内容和颜色。

**字体问题**：如果提示符出现乱码方块，在终端设置中将字体改为 `JetBrainsMono Nerd Font`（安装脚本已自动安装）。

---

### zinit — 插件管理器

管理所有 zsh 插件，支持懒加载（异步加载，不影响启动速度）。

```bash
zinit update --all                        # 更新所有插件和 snippet
zinit update romkatv/powerlevel10k        # 更新指定插件
zinit self-update                         # 更新 zinit 本身
zinit loaded                              # 列出已加载的插件
zinit plugins                             # 列出已安装的插件
zinit times                               # 查看各插件加载耗时（排查启动慢）
zinit delete romkatv/powerlevel10k        # 删除指定插件
zinit status romkatv/powerlevel10k        # 查看插件 git 状态
zinit changes romkatv/powerlevel10k       # 查看插件最近变更（git log）
zinit zstatus                             # 查看 zinit 整体状态
```

插件配置在 `~/.zshrc` 中，修改后重启终端生效。

---

### zsh-autosuggestions — 命令建议

根据历史记录，在光标后以灰色显示补全建议。

| 操作 | 效果 |
|------|------|
| 输入命令前缀 | 自动显示历史匹配建议（灰色） |
| `→`（右方向键）| 接受整条建议 |
| `End` | 接受整条建议 |
| `Ctrl+F` | 接受整条建议 |
| `Alt+→` | 接受建议中的下一个单词 |
| 继续输入 | 忽略建议，按自己输入走 |

---

### zsh-history-substring-search — 历史搜索

按已输入内容在历史记录中上下翻找，比普通 `↑` 更精准。

| 操作 | 效果 |
|------|------|
| 输入部分命令，然后按 `↑` | 在历史中找包含该内容的上一条命令 |
| `↓` | 找下一条 |
| `Ctrl+P` / `Ctrl+N` | 同 `↑` / `↓` |

例如：输入 `git` 后按 `↑`，只会在历史中翻 git 相关命令，而不是所有命令。

---

### fast-syntax-highlighting — 语法高亮

实时高亮命令行输入，命令存在显示绿色，不存在显示红色，路径自动下划线。无需任何操作，自动生效。

---

### zsh-autopair — 括号自动配对

输入 `(`、`[`、`{`、`"`、`'` 时自动补全对应的闭合符号，光标停在中间。删除开括号时自动同时删除闭括号。无需任何操作，自动生效。

---

### you-should-use — 别名提醒

当你输入了一个有别名的命令时，自动提示你应该用哪个别名。

```
$ git status
YSU: Found existing alias for "git status". You should use: "gst"
```

帮助你逐渐记住并使用别名，提升效率。如果觉得提示烦人，可以在 `~/.zshrc` 中加 `export YSU_MODE=ALL` 或 `unset YSU_MESSAGE_FORMAT` 关闭。

---

### forgit — 交互式 Git 操作

基于 fzf 的交互式 git 命令集，用方向键选择文件/提交，无需手动输入文件名。

| 命令 | 功能 |
|------|------|
| `ga` | 交互式 `git add`，选择要暂存的文件 |
| `glo` | 交互式查看 git log，预览 diff |
| `gd` | 交互式 `git diff`，选择文件查看变更 |
| `grh` | 交互式 `git reset HEAD`，取消暂存 |
| `gcf` | 交互式 `git checkout`，选择文件恢复 |
| `gss` | 交互式 `git stash show` |
| `gsp` | 交互式 `git stash pop` |
| `gclean` | 交互式清理未跟踪文件 |
| `gfu` | 交互式 fixup commit（选择要修复的提交） |

在交互界面中：`↑↓` 选择，`Enter` 确认，`Tab` 多选，`Ctrl+C` 取消。

---

## 版本管理

### mise — 多语言版本管理

统一管理 Node.js、Python、Java、Maven 等版本，替代 nvm / pyenv / jenv。全局配置在 `~/.config/mise/config.toml`，项目级配置在项目目录的 `.mise.toml`。

**查看状态**

```bash
mise ls              # 列出所有已安装版本及激活状态
mise current         # 查看当前目录激活的各语言版本
mise doctor          # 诊断环境问题
```

**安装版本**

```bash
# Node.js
mise install node@22          # 安装指定版本
mise install node@lts         # 安装最新 LTS
mise install node             # 安装 .mise.toml 中指定的版本

# Python
mise install python@3.12
mise install python@latest

# Java（使用 Temurin 发行版）
mise install java@temurin-21
mise install java@temurin-17
mise install java@corretto-8

# Maven
mise install maven@3.9
```

**切换版本**

```bash
# 全局切换（影响所有目录）
mise use --global node@22
mise use --global python@3.12
mise use --global java@temurin-21

# 项目级切换（在项目目录下执行，生成 .mise.toml）
cd my-project
mise use node@18              # 只在此项目目录下使用 node 18
```

**查看可安装版本**

```bash
mise ls-remote node           # 列出所有可安装的 Node.js 版本
mise ls-remote java           # 列出所有可安装的 Java 版本
mise ls-remote python         # 列出所有可安装的 Python 版本
```

**卸载版本**

```bash
mise uninstall node@18        # 卸载指定版本
mise prune                    # 清理未被任何配置引用的版本
```

**项目配置文件示例**（`.mise.toml`）

```toml
[tools]
node = "18"
python = "3.11"
java = "temurin-17"
```

提交 `.mise.toml` 到 git，团队成员运行 `mise install` 即可自动安装对应版本。

---

### uv — Python 工具链

极速 Python 包管理器和项目管理工具，替代 pip / virtualenv / poetry。

**包管理**

```bash
uv pip install requests       # 安装包（比 pip 快 10-100x）
uv pip install -r requirements.txt
uv pip list                   # 列出已安装包
uv pip uninstall requests
```

**项目管理**

```bash
uv init my-project            # 创建新项目（生成 pyproject.toml）
cd my-project
uv add requests               # 添加依赖
uv add --dev pytest           # 添加开发依赖
uv remove requests            # 移除依赖
uv sync                       # 同步依赖（安装 pyproject.toml 中所有依赖）
uv run python main.py         # 在项目虚拟环境中运行脚本
uv run pytest                 # 在项目虚拟环境中运行命令
```

**虚拟环境**

```bash
uv venv                       # 在当前目录创建 .venv
uv venv --python 3.11         # 指定 Python 版本
source .venv/bin/activate     # 激活（或直接用 uv run）
```

**工具安装**（全局可用的 Python 工具）

```bash
uv tool install ruff          # 安装 ruff（全局可用）
uv tool install black
uv tool list                  # 列出已安装工具
uv tool upgrade ruff          # 升级工具
```

---

## 现代 CLI 工具

### fzf — 模糊搜索

交互式模糊搜索工具，已集成到 zsh 快捷键中。

**快捷键（在终端中直接使用）**

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+R` | 模糊搜索命令历史，选中后插入命令行 |
| `Ctrl+T` | 模糊搜索当前目录下的文件，选中后插入命令行 |
| `Alt+C` | 模糊搜索子目录，选中后直接 cd 进入 |

**在交互界面中**

| 操作 | 效果 |
|------|------|
| 输入关键词 | 实时过滤 |
| `↑↓` | 移动选择 |
| `Enter` | 确认选择 |
| `Tab` | 多选（部分场景） |
| `Ctrl+C` / `Esc` | 取消 |

**命令行直接使用**

```bash
# 管道传入 fzf，交互选择后输出
ls | fzf
cat ~/.zsh_history | fzf

# 选中文件后用 vim 打开
vim $(fzf)

# 结合 fd 搜索文件
fd --type f | fzf

# 预览文件内容（需要 bat）
fzf --preview 'bat --color=always {}'
```

---

### zoxide — 智能目录跳转

记录访问过的目录，用关键词快速跳转，无需输完整路径。

```bash
z checklist          # 跳到历史中匹配 "checklist" 的目录
z doc api            # 多关键词匹配（同时包含 doc 和 api 的路径）
zi                   # 用 fzf 交互式选择历史目录
z -                  # 跳回上一个目录（类似 cd -）
```

**查看数据库**

```bash
zoxide query -l      # 列出所有记录的目录（按访问频率排序）
zoxide query -s doc  # 查看匹配 "doc" 的目录及其分数
```

> 刚安装时数据库为空，需先正常用 `cd` 积累一些历史记录，之后 `z` 才能发挥作用。

---

### eza — 文件列表

`ls` 的现代替代，支持图标、颜色、git 状态显示。已设置别名，直接用：

```bash
ls           # 普通列表（带图标和颜色）
ll           # 详细列表（权限、大小、时间）
la           # 详细列表（含隐藏文件）
lt           # 树形结构（当前目录）
```

**更多用法**

```bash
eza -la --git                  # 显示 git 状态（M=修改，A=新增）
eza --tree --level=2           # 树形结构，限制深度为 2 层
eza -la --sort=size            # 按文件大小排序
eza -la --sort=modified        # 按修改时间排序
eza -la --reverse              # 反向排序
eza --only-dirs                # 只显示目录
```

---

### bat — 文件查看

`cat` 的现代替代，自动语法高亮、显示行号、集成 git diff。已设置 `cat` 别名。

```bash
cat main.py          # 带语法高亮查看文件（cat 已别名为 bat）
catp main.py         # 带分页查看（文件很长时用，catp = bat with pager）
bat -n main.py       # 显示行号
bat -A main.py       # 显示不可见字符（调试空白字符问题）
bat --diff main.py   # 只显示 git 变更的行（高亮 diff）
```

**指定语言**

```bash
bat --language=json config.txt   # 强制用 JSON 语法高亮
bat --language=yaml config.txt
```

**查看主题**

```bash
bat --list-themes                # 列出所有可用主题
bat --theme=TwoDark main.py      # 使用指定主题预览
```

---

### fd — 文件搜索

`find` 的现代替代，语法简洁，自动忽略 `.gitignore` 中的文件。

```bash
fd main              # 搜索文件名包含 "main" 的文件
fd '\.py$'           # 搜索所有 .py 文件（正则）
fd .py               # 搜索所有 .py 文件（简写）
fd .py src/          # 在 src/ 目录下搜索
```

**常用选项**

```bash
fd -t f .py          # 只搜索文件（-t f），排除目录
fd -t d node_modules # 只搜索目录（-t d）
fd -e py -e ts       # 搜索多种扩展名
fd -H .env           # 包含隐藏文件（-H）
fd -I .py            # 不忽略 .gitignore（-I）
fd --max-depth 2 .py # 限制搜索深度
```

**结合其他命令**

```bash
fd .py | xargs bat                    # 查看所有 py 文件内容
fd -e log -x rm                       # 删除所有 .log 文件（-x 对每个结果执行命令）
fd .py -x wc -l                       # 统计每个 py 文件行数
```

---

### ripgrep — 内容搜索

`grep` 的现代替代，搜索代码内容极快，自动忽略 `.gitignore`。

```bash
rg "TODO"                        # 搜索当前目录所有文件中的 TODO
rg "def main"                    # 搜索函数定义
rg "import React" -l             # 只列出匹配的文件名（-l）
rg "useState" -C 3               # 显示匹配行前后各 3 行上下文（-C）
rg -i "error"                    # 忽略大小写（-i）
```

**按文件类型搜索**

```bash
rg "func.*init" -t py            # 只搜 Python 文件
rg "useState" -t ts              # 只搜 TypeScript 文件
rg "TODO" -g "*.java"            # 用 glob 模式指定文件
rg "TODO" -g "!vendor/"          # 排除 vendor 目录
```

**高级用法**

```bash
rg "class\s+\w+" --type py       # 正则搜索 Python 类定义
rg "TODO|FIXME|HACK"             # 搜索多个关键词（正则 OR）
rg -v "test"                     # 反向匹配（不包含 test 的行）
rg -c "import"                   # 统计每个文件的匹配次数（-c）
rg -n "main" src/                # 显示行号（-n）
rg --json "error" | jq .         # 输出 JSON 格式（配合 jq 处理）
```

---

### lazygit — Git 可视化

终端内的 Git 图形界面，用键盘操作所有 git 功能。

```bash
lg    # 打开 lazygit（lg 是别名）
```

**界面布局**

打开后分为 5 个面板（用数字键 `1-5` 或 `Tab` 切换）：

```
1: 文件状态    2: 分支列表    3: 提交历史    4: Stash    5: 远程
```

**文件面板（面板 1）常用操作**

| 按键 | 功能 |
|------|------|
| `空格` | 暂存 / 取消暂存文件 |
| `a` | 暂存 / 取消暂存所有文件 |
| `Enter` | 进入文件，查看 diff 或选择行级暂存 |
| `d` | 丢弃文件变更（恢复到 HEAD） |
| `c` | 提交（打开提交信息输入框） |
| `C` | 用 `$EDITOR` 编辑提交信息 |
| `A` | Amend 上一次提交 |

**分支面板（面板 2）常用操作**

| 按键 | 功能 |
|------|------|
| `空格` | 切换到选中分支 |
| `n` | 新建分支 |
| `d` | 删除分支 |
| `r` | 重命名分支 |
| `M` | 将选中分支 merge 到当前分支 |
| `R` | 将选中分支 rebase 到当前分支 |

**提交历史面板（面板 3）常用操作**

| 按键 | 功能 |
|------|------|
| `Enter` | 查看提交详情和变更文件 |
| `空格` | 检出该提交 |
| `r` | 交互式 rebase（从该提交开始） |
| `d` | 删除该提交（drop） |
| `e` | 编辑该提交（reword） |
| `f` | Fixup 到该提交 |
| `p` | Cherry-pick 该提交 |

**全局操作**

| 按键 | 功能 |
|------|------|
| `p` | git pull |
| `P` | git push |
| `f` | git fetch |
| `?` | 查看当前面板所有快捷键 |
| `q` | 退出 lazygit |
| `x` | 打开命令菜单（更多操作） |
| `:` | 直接输入 git 命令 |

---

### git-delta — Diff 高亮

自动增强 `git diff`、`git log`、`git show` 的输出，无需额外命令，已在 `~/.gitconfig` 中配置为默认 pager。

```bash
git diff             # 自动使用 delta 高亮，side-by-side 对比
git log -p           # 查看提交历史时也自动高亮
git show HEAD        # 查看最新提交变更
```

**配置说明**（`~/.gitconfig` 中已设置）

```
side-by-side = true    # 左右对比显示（而非上下）
line-numbers = true    # 显示行号
navigate = true        # 用 n/N 在 diff 块之间跳转
syntax-theme = Dracula # 语法高亮主题
```

**在 delta 界面中**

| 按键 | 功能 |
|------|------|
| `n` | 跳到下一个 diff 块 |
| `N` | 跳到上一个 diff 块 |
| `q` | 退出 |
| `空格` | 向下翻页 |

---

### gh — GitHub CLI

在终端中操作 GitHub，无需打开浏览器。

**认证**

```bash
gh auth login        # 首次登录，按提示完成 OAuth 认证
gh auth status       # 查看当前登录状态
```

**Pull Request**

```bash
gh pr list                        # 列出当前仓库的 PR
gh pr create                      # 创建 PR（交互式填写标题、描述）
gh pr create --title "fix: bug" --body "description"
gh pr view 123                    # 查看 PR #123 详情
gh pr checkout 123                # 检出 PR #123 到本地
gh pr merge 123                   # 合并 PR
gh pr review 123 --approve        # 批准 PR
gh pr review 123 --request-changes --body "需要修改..."
```

**Issue**

```bash
gh issue list                     # 列出 issue
gh issue create                   # 创建 issue
gh issue view 42                  # 查看 issue #42
gh issue close 42                 # 关闭 issue
```

**仓库操作**

```bash
gh repo clone owner/repo          # 克隆仓库
gh repo create my-repo --public   # 创建新仓库
gh repo view                      # 查看当前仓库信息
gh repo fork                      # Fork 当前仓库
```

**其他常用**

```bash
gh run list                       # 查看 GitHub Actions 运行记录
gh run view 123                   # 查看某次 Actions 运行详情
gh release list                   # 查看 Release 列表
gh release create v1.0.0          # 创建 Release
gh gist create file.txt           # 创建 Gist
```

---

### btop — 系统监控

`top` / `htop` 的现代替代，支持鼠标操作，界面美观。

```bash
btop    # 打开界面
```

**界面操作**

| 按键 | 功能 |
|------|------|
| `q` | 退出 |
| `F2` / `o` | 打开选项设置 |
| `F5` / `p` | 切换进程排序方式 |
| `F6` / `f` | 过滤进程（输入关键词） |
| `k` | 向选中进程发送信号（kill） |
| `m` | 切换内存显示单位 |
| `1` | 切换 CPU 显示（单核/总览） |
| `↑↓` | 在进程列表中移动 |
| `Enter` | 展开进程详情 |

鼠标可以直接点击进程、拖动分隔线调整面板大小。

---

### httpie — HTTP 调试

`curl` 的现代替代，自动格式化 JSON 输出，语法更直观。

```bash
# GET 请求
http get httpbin.org/get
http httpbin.org/get              # 默认就是 GET，可省略

# POST JSON（key=value 自动序列化为 JSON）
http post httpbin.org/post name=yanqi age:=18 active:=true

# 带请求头
http get api.example.com Authorization:"Bearer your-token"
http get api.example.com X-Custom-Header:value

# 带查询参数
http get api.example.com page==1 size==20

# 发送原始 JSON body
echo '{"key": "value"}' | http post api.example.com

# 下载文件
http --download get example.com/file.zip

# 查看请求和响应详情（调试用）
http --verbose get httpbin.org/get
http -v get httpbin.org/get       # 简写
```

**语法规则**

| 语法 | 含义 |
|------|------|
| `key=value` | JSON 字符串字段 |
| `key:=value` | JSON 非字符串字段（数字、布尔、数组） |
| `key==value` | URL 查询参数 |
| `Header:value` | 请求头（首字母大写） |
| `@file.json` | 从文件读取 body |

---

### yq — YAML/JSON 处理

命令行 YAML / JSON / TOML 处理工具，语法类似 `jq`。

```bash
# 读取字段
yq '.name' config.yaml
yq '.dependencies.react' package.json

# 修改字段
yq '.version = "2.0.0"' config.yaml

# 原地修改文件
yq -i '.version = "2.0.0"' config.yaml

# 格式转换
yq -o=json config.yaml            # YAML 转 JSON
yq -o=yaml config.json            # JSON 转 YAML

# 合并文件
yq '. * load("override.yaml")' base.yaml

# 遍历数组
yq '.items[].name' config.yaml

# 条件过滤
yq '.items[] | select(.enabled == true)' config.yaml
```

---

### tlrc — 命令速查

`tldr` 的 Rust 实现，查看命令的实用示例（比 `man` 简洁得多）。

```bash
tldr tar          # 查看 tar 命令的常用示例
tldr git          # 查看 git 常用操作
tldr fd           # 查看 fd 使用示例
tldr --update     # 更新本地缓存
tldr --list       # 列出所有可查询的命令
```

> 不记得某个命令怎么用时，先 `tldr <命令名>`，比翻 man page 快得多。

---

## 编辑器

### LazyVim — Neovim 配置框架

基于 Neovim 的现代编辑器配置，开箱即用，内置 LSP、补全、语法高亮、文件树等。

```bash
nvim              # 打开 Neovim
nvim file.py      # 打开指定文件
nvim .            # 打开当前目录（文件树）
```

**首次启动**：会自动下载并安装所有插件（约 30 秒），等待完成即可。

---

#### 基础操作（Vim 模式）

Neovim 有多种模式，这是最重要的概念：

| 模式 | 进入方式 | 用途 |
|------|---------|------|
| Normal | `Esc` | 移动、命令操作（默认模式） |
| Insert | `i` / `a` / `o` | 输入文字 |
| Visual | `v` / `V` / `Ctrl+V` | 选择文本 |
| Command | `:` | 执行命令（保存、退出等） |

**最基础的操作**

```
i         进入 Insert 模式（在光标前插入）
a         进入 Insert 模式（在光标后插入）
o         在下方新建一行并进入 Insert 模式
Esc       返回 Normal 模式
:w        保存文件
:q        退出
:wq       保存并退出
:q!       强制退出（不保存）
```

---

#### 移动（Normal 模式）

**基础移动**

| 按键 | 移动 |
|------|------|
| `h j k l` | 左 下 上 右 |
| `w` | 下一个单词开头 |
| `b` | 上一个单词开头 |
| `e` | 当前/下一个单词结尾 |
| `0` | 行首 |
| `$` | 行尾 |
| `gg` | 文件开头 |
| `G` | 文件结尾 |
| `Ctrl+d` | 向下半页 |
| `Ctrl+u` | 向上半页 |
| `{` / `}` | 上/下一个空行（段落跳转） |

**跳转**

| 按键 | 功能 |
|------|------|
| `%` | 跳到匹配的括号 |
| `gd` | 跳到定义（LSP） |
| `gr` | 查看所有引用（LSP） |
| `Ctrl+o` | 跳回上一个位置 |
| `Ctrl+i` | 跳到下一个位置 |
| `''` | 跳回上次跳转前的位置 |

---

#### LazyVim 快捷键（Space 键为 Leader）

LazyVim 以 `Space`（空格）为 Leader 键，按下空格后会弹出 which-key 提示菜单。

**文件操作**

| 快捷键 | 功能 |
|--------|------|
| `Space + e` | 打开/关闭文件树（Neo-tree） |
| `Space + f + f` | 模糊搜索文件（Telescope） |
| `Space + f + r` | 最近打开的文件 |
| `Space + f + g` | 搜索 git 文件 |
| `Space + Space` | 快速切换 buffer |

**搜索**

| 快捷键 | 功能 |
|--------|------|
| `Space + /` | 在当前文件中搜索 |
| `Space + s + g` | 全局搜索（grep，基于 ripgrep） |
| `Space + s + w` | 搜索光标下的单词 |
| `Space + s + s` | 搜索 LSP 符号 |

**代码操作（LSP）**

| 快捷键 | 功能 |
|--------|------|
| `gd` | 跳到定义 |
| `gr` | 查看引用 |
| `gI` | 跳到实现 |
| `K` | 查看文档（hover） |
| `Space + c + a` | 代码 Action（快速修复、重构等） |
| `Space + c + r` | 重命名符号 |
| `Space + c + f` | 格式化文件 |
| `[d` / `]d` | 上/下一个诊断错误 |
| `Space + x + x` | 打开 Trouble（错误列表） |

**Git 操作（gitsigns）**

| 快捷键 | 功能 |
|--------|------|
| `]h` | 下一个 git hunk |
| `[h` | 上一个 git hunk |
| `Space + g + h + s` | 暂存当前 hunk |
| `Space + g + h + r` | 重置当前 hunk |
| `Space + g + h + p` | 预览当前 hunk |
| `Space + g + g` | 打开 lazygit |

**Buffer 管理**

| 快捷键 | 功能 |
|--------|------|
| `Shift+H` | 切换到左边的 buffer |
| `Shift+L` | 切换到右边的 buffer |
| `Space + b + d` | 关闭当前 buffer |
| `Space + b + o` | 关闭其他所有 buffer |

**窗口分割**

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+w + v` | 垂直分割 |
| `Ctrl+w + s` | 水平分割 |
| `Ctrl+h/j/k/l` | 在窗口间移动 |
| `Ctrl+w + q` | 关闭当前窗口 |

---

#### 插件管理（Lazy.nvim）

```
:Lazy          # 打开插件管理界面
:Lazy update   # 更新所有插件
:Lazy sync     # 同步（安装新增、删除移除的插件）
:Lazy clean    # 清理不再使用的插件
```

在 Lazy 界面中按 `?` 查看帮助，按 `q` 退出。

---

#### LSP 和工具安装（Mason）

Mason 管理 LSP server、formatter、linter 的安装。

```
:Mason         # 打开 Mason 界面
```

在 Mason 界面中：`i` 安装，`X` 卸载，`u` 更新，`/` 搜索，`q` 退出。

常用 LSP：`pyright`（Python）、`ts_ls`（TypeScript）、`lua_ls`（Lua）、`jdtls`（Java）。

---

#### 自定义配置

配置文件在 `~/.config/nvim/lua/config/`：

- `keymaps.lua` — 添加自定义快捷键
- `options.lua` — 修改编辑器选项
- `autocmds.lua` — 添加自动命令

添加插件：在 `~/.config/nvim/lua/plugins/` 目录下新建 `.lua` 文件，例如：

```lua
-- ~/.config/nvim/lua/plugins/my-plugins.lua
return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
  },
}
```

保存后重启 nvim，Lazy 会自动安装新插件。

---

## 快速参考卡

### 常用别名汇总

| 别名 | 实际命令 | 说明 |
|------|---------|------|
| `ls` | `eza --color --icons` | 文件列表 |
| `ll` | `eza -l --color --icons` | 详细列表 |
| `la` | `eza -la --color --icons` | 含隐藏文件 |
| `lt` | `eza --tree --color --icons` | 树形结构 |
| `cat` | `bat --paging=never` | 语法高亮查看 |
| `catp` | `bat` | 带分页查看 |
| `lg` | `lazygit` | Git 可视化 |
| `z` | `zoxide` | 智能跳转 |
| `zi` | `zoxide query -i` | 交互式跳转 |

### 工具速查

| 需求 | 命令 |
|------|------|
| 找文件 | `fd <名称>` |
| 搜内容 | `rg <关键词>` |
| 查命令历史 | `Ctrl+R` |
| 跳目录 | `z <关键词>` |
| 查看文件 | `cat <文件>` |
| 列文件 | `ll` |
| Git 操作 | `lg` |
| 查命令用法 | `tldr <命令>` |
| 管理版本 | `mise ls` / `mise use` |
| 系统监控 | `btop` |
| HTTP 调试 | `http get <url>` |

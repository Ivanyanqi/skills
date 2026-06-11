#!/usr/bin/env bash
# =============================================================================
# mac-dev-setup — 终端开发环境安装脚本
#
# 用法：
#   bash install.sh --detect-only     # 仅检测，不安装
#   bash install.sh --all             # 完整安装
#   bash install.sh --all --skip neovim --skip gh
#   bash install.sh --config-only     # 仅写入配置文件
#   bash install.sh --verify          # 验证安装结果
#
# 输出约定（供 Agent 解析）：
#   DETECT:<component>:<status>       # 检测结果
#   INSTALL:<component>:<result>      # 安装结果
#   VERIFY:<check>:<result>           # 验证结果
#   INFO:<message>                    # 人类可读信息
#   WARN:<message>                    # 警告
#   ERROR:<message>                   # 错误
# =============================================================================

set -euo pipefail

# ── 全局变量 ──────────────────────────────────────────────────────────────────
SKIP_LIST=()
MODE="all"
BREW_PREFIX=""
ARCH=$(uname -m)

# ── 颜色输出 ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; NC='\033[0m'

info()  { echo -e "${BLUE}INFO:${NC} $*"; }
warn()  { echo -e "${YELLOW}WARN:${NC} $*"; }
ok()    { echo -e "${GREEN}✅${NC} $*"; }
fail()  { echo -e "${RED}❌${NC} $*"; }

# ── 参数解析 ──────────────────────────────────────────────────────────────────
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --detect-only)  MODE="detect"; shift ;;
      --all)          MODE="all";    shift ;;
      --config-only)  MODE="config"; shift ;;
      --verify)       MODE="verify"; shift ;;
      --skip)         SKIP_LIST+=("$2"); shift 2 ;;
      *) echo "ERROR:unknown_arg:$1"; shift ;;
    esac
  done
}

# ── 工具函数 ──────────────────────────────────────────────────────────────────
should_skip() { local c="$1"; for s in "${SKIP_LIST[@]:-}"; do [[ "$s" == "$c" ]] && return 0; done; return 1; }

cmd_exists() { command -v "$1" &>/dev/null; }

brew_installed() { brew list --formula 2>/dev/null | grep -qx "$1"; }

brew_cask_installed() { brew list --cask 2>/dev/null | grep -qx "$1"; }

get_brew_prefix() {
  if [[ "$ARCH" == "arm64" ]]; then echo "/opt/homebrew"
  else echo "/usr/local"; fi
}

# ── Step 0：Homebrew ──────────────────────────────────────────────────────────
detect_homebrew() {
  if cmd_exists brew; then
    BREW_PREFIX=$(brew --prefix)
    echo "DETECT:homebrew:installed:$(brew --version | head -1)"
  else
    BREW_PREFIX=$(get_brew_prefix)
    echo "DETECT:homebrew:missing"
  fi
}

install_homebrew() {
  if cmd_exists brew; then
    ok "Homebrew 已安装，跳过"
    echo "INSTALL:homebrew:skipped"
    return
  fi
  info "安装 Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # 让当前 shell 立即可用
  if [[ "$ARCH" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    BREW_PREFIX="/opt/homebrew"
  else
    eval "$(/usr/local/bin/brew shellenv)"
    BREW_PREFIX="/usr/local"
  fi
  echo "INSTALL:homebrew:ok"
}

# ── Step 1：检测冲突工具 ──────────────────────────────────────────────────────
detect_conflicts() {
  # nvm
  if [[ -d "$HOME/.nvm" ]] || [[ -n "${NVM_DIR:-}" ]]; then
    echo "DETECT:conflict:nvm"
  fi
  # pyenv
  if cmd_exists pyenv || [[ -d "$HOME/.pyenv" ]]; then
    echo "DETECT:conflict:pyenv"
  fi
  # jenv
  if cmd_exists jenv || [[ -d "$HOME/.jenv" ]]; then
    echo "DETECT:conflict:jenv"
  fi
  # conda
  if cmd_exists conda || [[ -d "$HOME/anaconda3" ]] || [[ -d "$HOME/miniconda3" ]]; then
    echo "DETECT:conflict:conda"
  fi
  # starship（作为主提示符）
  if cmd_exists starship && grep -q 'starship init' "$HOME/.zshrc" 2>/dev/null && ! grep -q '#.*starship init' "$HOME/.zshrc" 2>/dev/null; then
    echo "DETECT:conflict:starship_active"
  fi
  # oh-my-zsh 框架
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo "DETECT:conflict:oh_my_zsh"
  fi
}

# ── Step 2：检测各组件 ────────────────────────────────────────────────────────
detect_components() {
  # Ghostty
  if brew_cask_installed "ghostty" || [[ -d "/Applications/Ghostty.app" ]]; then
    echo "DETECT:ghostty:installed"
  else
    echo "DETECT:ghostty:missing"
  fi

  # 字体
  if fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd"; then
    echo "DETECT:font_jetbrains:installed"
  else
    echo "DETECT:font_jetbrains:missing"
  fi
  if fc-list 2>/dev/null | grep -qi "MesloLGS NF"; then
    echo "DETECT:font_meslo:installed"
  else
    echo "DETECT:font_meslo:missing"
  fi

  # zinit
  local zinit_home="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
  if [[ -d "$zinit_home/.git" ]]; then
    echo "DETECT:zinit:installed"
  else
    echo "DETECT:zinit:missing"
  fi

  # powerlevel10k
  if [[ -d "$HOME/.local/share/zinit/plugins/romkatv---powerlevel10k" ]]; then
    echo "DETECT:powerlevel10k:installed"
  else
    echo "DETECT:powerlevel10k:missing"
  fi

  # mise
  if cmd_exists mise || [[ -f "$HOME/.local/bin/mise" ]]; then
    echo "DETECT:mise:installed:$(mise --version 2>/dev/null || echo unknown)"
  else
    echo "DETECT:mise:missing"
  fi

  # uv
  if cmd_exists uv || [[ -f "$HOME/.local/bin/uv" ]]; then
    echo "DETECT:uv:installed"
  else
    echo "DETECT:uv:missing"
  fi

  # CLI 工具
  local brew_tools=(bat eza fzf zoxide lazygit ripgrep fd btop git-delta gh yq tlrc httpie neovim)
  for tool in "${brew_tools[@]}"; do
    if brew_installed "$tool"; then
      echo "DETECT:$tool:installed"
    else
      echo "DETECT:$tool:missing"
    fi
  done

  # LazyVim
  if [[ -f "$HOME/.config/nvim/init.lua" ]] && [[ -d "$HOME/.local/share/nvim/lazy/LazyVim" ]]; then
    echo "DETECT:lazyvim:installed"
  elif [[ -f "$HOME/.config/nvim/init.lua" ]]; then
    echo "DETECT:lazyvim:nvim_config_exists_no_lazyvim"
  else
    echo "DETECT:lazyvim:missing"
  fi

  # 配置文件
  [[ -f "$HOME/.zshrc" ]]    && echo "DETECT:zshrc:exists"    || echo "DETECT:zshrc:missing"
  [[ -f "$HOME/.zshenv" ]]   && echo "DETECT:zshenv:exists"   || echo "DETECT:zshenv:missing"
  [[ -f "$HOME/.zprofile" ]] && echo "DETECT:zprofile:exists" || echo "DETECT:zprofile:missing"
  [[ -f "$HOME/.gitconfig" ]] && echo "DETECT:gitconfig:exists" || echo "DETECT:gitconfig:missing"
  [[ -f "$HOME/.config/ghostty/config" ]] && echo "DETECT:ghostty_config:exists" || echo "DETECT:ghostty_config:missing"
}

# ── Step 3：安装 Homebrew 工具 ────────────────────────────────────────────────
install_brew_tools() {
  info "安装 Homebrew CLI 工具..."

  local formulas=(bat eza fzf zoxide lazygit ripgrep fd btop git-delta gh yq tlrc httpie neovim)
  local casks=(ghostty font-jetbrains-mono-nerd-font font-meslo-lg-nerd-font font-hack-nerd-font)

  # 添加字体 tap
  brew tap homebrew/cask-fonts 2>/dev/null || true

  for formula in "${formulas[@]}"; do
    should_skip "$formula" && { info "跳过 $formula（用户选择）"; echo "INSTALL:$formula:skipped"; continue; }
    if brew_installed "$formula"; then
      info "$formula 已安装"
      echo "INSTALL:$formula:already_installed"
    else
      info "安装 $formula..."
      brew install "$formula" && echo "INSTALL:$formula:ok" || echo "INSTALL:$formula:failed"
    fi
  done

  for cask in "${casks[@]}"; do
    local cask_name="${cask#font-}"  # 用于 skip 检查
    should_skip "$cask" && { info "跳过 $cask（用户选择）"; echo "INSTALL:$cask:skipped"; continue; }
    if brew_cask_installed "$cask"; then
      info "$cask 已安装"
      echo "INSTALL:$cask:already_installed"
    else
      info "安装 $cask..."
      brew install --cask "$cask" && echo "INSTALL:$cask:ok" || echo "INSTALL:$cask:failed"
    fi
  done

  # fzf 需要额外安装 shell 集成
  if brew_installed fzf; then
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc 2>/dev/null || true
  fi

  # tlrc 与旧 tldr 冲突处理
  if brew_installed tldr && brew_installed tlrc; then
    brew unlink tldr 2>/dev/null || true
    info "已解除旧 tldr 链接，使用 tlrc"
  fi
}

# ── Step 4：安装 mise ─────────────────────────────────────────────────────────
install_mise() {
  should_skip "mise" && { echo "INSTALL:mise:skipped"; return; }

  if cmd_exists mise || [[ -f "$HOME/.local/bin/mise" ]]; then
    info "mise 已安装"
    echo "INSTALL:mise:already_installed"
    return
  fi

  info "安装 mise..."
  curl -fsSL https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
  echo "INSTALL:mise:ok"
}

# ── Step 5：安装 uv ───────────────────────────────────────────────────────────
install_uv() {
  should_skip "uv" && { echo "INSTALL:uv:skipped"; return; }

  if cmd_exists uv || [[ -f "$HOME/.local/bin/uv" ]]; then
    info "uv 已安装"
    echo "INSTALL:uv:already_installed"
    return
  fi

  info "安装 uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  echo "INSTALL:uv:ok"
}

# ── Step 6：安装 zinit ────────────────────────────────────────────────────────
install_zinit() {
  should_skip "zinit" && { echo "INSTALL:zinit:skipped"; return; }

  local zinit_home="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
  if [[ -d "$zinit_home/.git" ]]; then
    info "zinit 已安装"
    echo "INSTALL:zinit:already_installed"
    return
  fi

  info "安装 zinit..."
  mkdir -p "$(dirname "$zinit_home")"
  git clone https://github.com/zdharma-continuum/zinit.git "$zinit_home"
  echo "INSTALL:zinit:ok"
}

# ── Step 7：配置 LazyVim ──────────────────────────────────────────────────────
install_lazyvim() {
  should_skip "lazyvim" && { echo "INSTALL:lazyvim:skipped"; return; }
  should_skip "neovim"  && { echo "INSTALL:lazyvim:skipped_neovim"; return; }

  if [[ -d "$HOME/.local/share/nvim/lazy/LazyVim" ]]; then
    info "LazyVim 已安装"
    echo "INSTALL:lazyvim:already_installed"
    return
  fi

  # 备份现有 nvim 配置
  for d in "$HOME/.config/nvim" "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"; do
    [[ -d "$d" ]] && mv "$d" "${d}.backup-$(date +%Y%m%d%H%M%S)" && info "已备份 $d"
  done

  info "克隆 LazyVim starter..."
  git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
  rm -rf "$HOME/.config/nvim/.git"

  info "首次同步 LazyVim 插件（约 1-2 分钟）..."
  local nvim_path
  nvim_path=$(command -v nvim || echo "$BREW_PREFIX/bin/nvim")
  PATH="$HOME/.local/share/mise/shims:$BREW_PREFIX/bin:$PATH" \
    "$nvim_path" --headless "+Lazy! sync" +qa 2>&1 | \
    grep -E "Finished|Error|Failed|clone" | tail -10 || true

  echo "INSTALL:lazyvim:ok"
}

# ── Step 8：处理冲突 ──────────────────────────────────────────────────────────
handle_conflicts() {
  # 这个函数由 SKILL.md 中的 Agent 在用户确认后调用
  # 此处仅输出需要处理的冲突信息，实际修改由配置文件写入完成

  # 检测 nvm 残留
  if [[ -d "$HOME/.nvm" ]]; then
    warn "检测到 ~/.nvm 目录，mise 已接管版本管理，nvm 目录可以安全删除"
    echo "CONFLICT_ACTION:nvm:directory_can_be_removed:$HOME/.nvm"
  fi

  # 检测 pyenv
  if [[ -d "$HOME/.pyenv" ]]; then
    warn "检测到 ~/.pyenv 目录，mise 已接管版本管理"
    echo "CONFLICT_ACTION:pyenv:directory_can_be_removed:$HOME/.pyenv"
  fi

  # 检测 oh-my-zsh
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    warn "检测到 oh-my-zsh，新配置使用 zinit 替代，oh-my-zsh 目录可以安全删除"
    echo "CONFLICT_ACTION:oh_my_zsh:directory_can_be_removed:$HOME/.oh-my-zsh"
  fi
}

# ── Step 9：验证安装 ──────────────────────────────────────────────────────────
verify_installation() {
  info "验证安装结果..."

  # zsh 启动时间
  local startup_time
  startup_time=$( { time zsh -i -c exit; } 2>&1 | grep real | awk '{print $2}' )
  echo "VERIFY:zsh_startup_time:${startup_time:-unknown}"

  # 核心工具
  local tools=(brew mise nvim bat eza fzf zoxide lazygit rg fd btop delta gh yq tldr)
  for tool in "${tools[@]}"; do
    if cmd_exists "$tool"; then
      echo "VERIFY:$tool:ok"
    else
      echo "VERIFY:$tool:missing"
    fi
  done

  # uv
  if cmd_exists uv || [[ -f "$HOME/.local/bin/uv" ]]; then
    echo "VERIFY:uv:ok"
  else
    echo "VERIFY:uv:missing"
  fi

  # zinit
  local zinit_home="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
  [[ -d "$zinit_home/.git" ]] && echo "VERIFY:zinit:ok" || echo "VERIFY:zinit:missing"

  # LazyVim
  [[ -d "$HOME/.local/share/nvim/lazy/LazyVim" ]] && echo "VERIFY:lazyvim:ok" || echo "VERIFY:lazyvim:missing"

  # 配置文件
  for f in .zshrc .zshenv .zprofile .gitconfig; do
    [[ -f "$HOME/$f" ]] && echo "VERIFY:$f:ok" || echo "VERIFY:$f:missing"
  done

  # Ghostty 配置
  if [[ -f "$HOME/.config/ghostty/config" ]]; then
    echo "VERIFY:ghostty_config:ok"
  else
    echo "VERIFY:ghostty_config:missing"
  fi

  # 字体
  if fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd"; then
    echo "VERIFY:nerd_font:ok"
  else
    echo "VERIFY:nerd_font:missing"
  fi

  # p10k 配置
  [[ -f "$HOME/.p10k.zsh" ]] && echo "VERIFY:p10k_config:ok" || echo "VERIFY:p10k_config:missing_run_p10k_configure"
}

# ── 主流程 ────────────────────────────────────────────────────────────────────
main() {
  parse_args "$@"

  case "$MODE" in
    detect)
      detect_homebrew
      detect_conflicts
      detect_components
      ;;

    all)
      install_homebrew
      install_brew_tools
      install_mise
      install_uv
      install_zinit
      install_lazyvim
      handle_conflicts
      echo "INSTALL:all:complete"
      ;;

    config)
      # 仅写入配置文件，由 SKILL.md 中的 Agent 负责实际文件复制
      # 此模式输出需要写入的文件列表
      echo "CONFIG:zshrc:$HOME/.zshrc"
      echo "CONFIG:zshenv:$HOME/.zshenv"
      echo "CONFIG:zprofile:$HOME/.zprofile"
      echo "CONFIG:gitconfig:$HOME/.gitconfig"
      echo "CONFIG:mise_config:$HOME/.config/mise/config.toml"
      echo "CONFIG:ghostty_config:$HOME/.config/ghostty/config"
      ;;

    verify)
      verify_installation
      ;;
  esac
}

main "$@"

#!/usr/bin/env bash
# =============================================================
# terminal-setup install.sh
# 一键安装 yanqi 的终端配置套件
# 支持全新 Mac 和已有配置的 Mac，幂等执行
# =============================================================

set -euo pipefail

# ── 颜色输出 ─────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo -e "${BLUE}[INFO]${RESET} $*"; }
success() { echo -e "${GREEN}[✓]${RESET} $*"; }
warn()    { echo -e "${YELLOW}[!]${RESET} $*"; }
error()   { echo -e "${RED}[✗]${RESET} $*"; exit 1; }
step()    { echo -e "\n${BOLD}${CYAN}▶ $*${RESET}"; }

# ── Skill 根目录（脚本所在位置的上一级）─────────────────────
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ASSETS_DIR="$SKILL_DIR/assets"

# ── 冲突处理函数 ─────────────────────────────────────────────
# 用法: handle_conflict <目标文件> <源文件>
# 返回 0=继续安装（已处理），1=跳过
handle_conflict() {
  local target="$1"
  local source="$2"

  if [[ ! -f "$target" ]]; then
    return 0  # 文件不存在，直接安装
  fi

  echo ""
  warn "文件已存在: ${BOLD}$target${RESET}"
  echo "  [b] 备份原文件后覆盖"
  echo "  [s] 跳过，保留原文件"
  echo "  [d] 查看差异后再决定"
  echo -n "  请选择 [b/s/d]: "
  read -r choice

  case "$choice" in
    b|B)
      local backup="${target}.backup-$(date +%Y%m%d%H%M%S)"
      cp "$target" "$backup"
      success "已备份到 $backup"
      return 0
      ;;
    s|S)
      info "跳过 $target"
      return 1
      ;;
    d|D)
      echo ""
      diff --color=always "$target" "$source" || true
      echo ""
      echo -n "  查看差异后，是否覆盖？[b=备份覆盖 / s=跳过]: "
      read -r choice2
      case "$choice2" in
        b|B)
          local backup="${target}.backup-$(date +%Y%m%d%H%M%S)"
          cp "$target" "$backup"
          success "已备份到 $backup"
          return 0
          ;;
        *)
          info "跳过 $target"
          return 1
          ;;
      esac
      ;;
    *)
      info "跳过 $target"
      return 1
      ;;
  esac
}

# ── 安装函数 ─────────────────────────────────────────────────

install_homebrew() {
  step "检查 Homebrew"
  if command -v brew &>/dev/null; then
    success "Homebrew 已安装 ($(brew --version | head -1))"
    return
  fi
  info "安装 Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apple Silicon 需要添加到 PATH
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  success "Homebrew 安装完成"
}

install_ghostty() {
  step "检查 Ghostty"
  if [[ -d "/Applications/Ghostty.app" ]]; then
    success "Ghostty 已安装"
  else
    info "安装 Ghostty..."
    brew install --cask ghostty
    success "Ghostty 安装完成"
  fi

  # 写入 Ghostty 配置
  local config_dir="$HOME/.config/ghostty"
  local config_file="$config_dir/config"
  mkdir -p "$config_dir"

  if handle_conflict "$config_file" "$ASSETS_DIR/ghostty-config"; then
    cp "$ASSETS_DIR/ghostty-config" "$config_file"
    success "Ghostty 配置已写入 $config_file"
  fi
}

install_font() {
  step "检查 JetBrainsMono Nerd Font"
  if brew list --cask font-jetbrains-mono-nerd-font &>/dev/null 2>&1; then
    success "JetBrainsMono Nerd Font 已安装"
  else
    info "安装 JetBrainsMono Nerd Font..."
    brew install --cask font-jetbrains-mono-nerd-font
    success "字体安装完成"
  fi
}

install_eza() {
  step "检查 eza"
  if command -v eza &>/dev/null; then
    success "eza 已安装 ($(eza --version | head -1))"
  else
    info "安装 eza..."
    brew install eza
    success "eza 安装完成"
  fi
}

install_zinit() {
  step "检查 zinit"
  local zinit_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
  if [[ -d "$zinit_dir/.git" ]]; then
    success "zinit 已安装"
  else
    info "安装 zinit..."
    mkdir -p "$(dirname "$zinit_dir")"
    git clone https://github.com/zdharma-continuum/zinit.git "$zinit_dir"
    success "zinit 安装完成"
  fi
}

install_zshrc() {
  step "配置 ~/.zshrc"
  if handle_conflict "$HOME/.zshrc" "$ASSETS_DIR/zshrc"; then
    cp "$ASSETS_DIR/zshrc" "$HOME/.zshrc"
    success "~/.zshrc 已写入"
  fi
}

install_p10k() {
  step "配置 ~/.p10k.zsh"
  if handle_conflict "$HOME/.p10k.zsh" "$ASSETS_DIR/p10k.zsh"; then
    cp "$ASSETS_DIR/p10k.zsh" "$HOME/.p10k.zsh"
    success "~/.p10k.zsh 已写入"
  fi
}

# ── 主流程 ───────────────────────────────────────────────────

main() {
  echo ""
  echo -e "${BOLD}${CYAN}╔══════════════════════════════════════╗${RESET}"
  echo -e "${BOLD}${CYAN}║     Terminal Setup — yanqi 配置套件   ║${RESET}"
  echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${RESET}"
  echo ""
  echo "安装内容: Homebrew · Ghostty · JetBrainsMono NF · eza · zinit · p10k"
  echo ""

  install_homebrew
  install_ghostty
  install_font
  install_eza
  install_zinit
  install_zshrc
  install_p10k

  echo ""
  echo -e "${BOLD}${GREEN}╔══════════════════════════════════════╗${RESET}"
  echo -e "${BOLD}${GREEN}║           ✅ 安装完成！               ║${RESET}"
  echo -e "${BOLD}${GREEN}╚══════════════════════════════════════╝${RESET}"
  echo ""
  echo -e "执行以下命令激活配置："
  echo ""
  echo -e "  ${BOLD}exec zsh${RESET}"
  echo ""
  echo -e "首次启动会自动下载 zinit 插件（约需 30 秒），之后每次启动都会很快。"
  echo -e "如需重新配置提示符风格，运行: ${BOLD}p10k configure${RESET}"
  echo ""
}

main "$@"

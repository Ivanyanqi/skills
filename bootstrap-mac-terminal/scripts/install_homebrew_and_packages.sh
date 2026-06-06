#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"

require_macos

if ! xcode-select -p >/dev/null 2>&1; then
  log "正在安装 Xcode Command Line Tools。"
  xcode-select --install || true
  fail "请先完成 Command Line Tools 安装，然后重新运行这个脚本。"
fi

if ! brew_path="$(brew_bin)"; then
  log "正在安装 Homebrew。"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew_path="$(brew_bin)" || fail "Homebrew 安装完成后仍然无法使用 brew。"
fi

eval "$("${brew_path}" shellenv)"

ensure_line_in_file "eval \"\$(${brew_path} shellenv)\"" "${HOME}/.zprofile"

"${brew_path}" update
"${brew_path}" tap homebrew/cask-fonts
"${brew_path}" install eza neovim tree-sitter-cli ripgrep fd git
"${brew_path}" install --cask iterm2 font-jetbrains-mono-nerd-font

log "Homebrew 包和 cask 已安装完成。"

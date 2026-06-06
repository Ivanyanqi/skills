#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"

require_macos

command -v nvim >/dev/null 2>&1 || fail "还没有安装 Neovim，请先运行 install_homebrew_and_packages.sh。"

if [[ -e "${HOME}/.config/nvim" ]] && ! confirm "要用打包好的 Neovim 配置替换现有 ~/.config/nvim 吗？"; then
  fail "用户取消了 ~/.config/nvim 替换。"
fi

backup_if_exists "${HOME}/.config/nvim"
mkdir -p "${HOME}/.config"
cp -R "${SKILL_ROOT}/assets/nvim" "${HOME}/.config/nvim"

nvim --headless "+Lazy! sync" "+qa"
nvim --headless "+MasonInstall lua-language-server pyright bash-language-server json-lsp yaml-language-server" "+qa"

log "Neovim 配置完成。"

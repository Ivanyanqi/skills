#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"

require_macos

command -v nvim >/dev/null 2>&1 || fail "Neovim is not installed. Run install_homebrew_and_packages.sh first."

if [[ -e "${HOME}/.config/nvim" ]] && ! confirm "Replace existing ~/.config/nvim with the bundled Neovim config?"; then
  fail "User declined ~/.config/nvim replacement."
fi

backup_if_exists "${HOME}/.config/nvim"
mkdir -p "${HOME}/.config"
cp -R "${SKILL_ROOT}/assets/nvim" "${HOME}/.config/nvim"

nvim --headless "+Lazy! sync" "+qa"
nvim --headless "+MasonInstall lua-language-server pyright bash-language-server json-lsp yaml-language-server" "+qa"

log "Neovim setup complete."

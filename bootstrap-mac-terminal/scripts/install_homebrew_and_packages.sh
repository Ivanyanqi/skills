#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"

require_macos

if ! xcode-select -p >/dev/null 2>&1; then
  log "Installing Xcode Command Line Tools."
  xcode-select --install || true
  fail "Complete the Command Line Tools installer, then rerun this script."
fi

if ! brew_path="$(brew_bin)"; then
  log "Installing Homebrew."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew_path="$(brew_bin)" || fail "Homebrew installation completed but brew is still unavailable."
fi

eval "$("${brew_path}" shellenv)"

ensure_line_in_file "eval \"\$(${brew_path} shellenv)\"" "${HOME}/.zprofile"

"${brew_path}" update
"${brew_path}" tap homebrew/cask-fonts
"${brew_path}" install eza neovim tree-sitter-cli ripgrep fd git
"${brew_path}" install --cask iterm2 font-jetbrains-mono-nerd-font

log "Installed Homebrew packages and casks."

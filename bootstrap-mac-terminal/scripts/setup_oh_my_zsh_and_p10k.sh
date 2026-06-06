#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"

require_macos

if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  log "Installing oh-my-zsh."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

mkdir -p "${HOME}/.oh-my-zsh/custom/plugins" "${HOME}/.oh-my-zsh/custom/themes"

if [[ ! -d "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"
fi

if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
    "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi

if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
fi

if [[ -e "${HOME}/.zshrc" ]] && ! confirm "Replace existing ~/.zshrc with the bundled terminal template?"; then
  fail "User declined ~/.zshrc replacement."
fi

if [[ -e "${HOME}/.p10k.zsh" ]] && ! confirm "Replace existing ~/.p10k.zsh with the bundled prompt config?"; then
  fail "User declined ~/.p10k.zsh replacement."
fi

backup_if_exists "${HOME}/.zshrc"
backup_if_exists "${HOME}/.p10k.zsh"

cp "${SKILL_ROOT}/assets/zsh/zshrc.template" "${HOME}/.zshrc"
cp "${SKILL_ROOT}/assets/zsh/p10k.zsh" "${HOME}/.p10k.zsh"

if [[ "${SHELL}" != */zsh ]] && command -v zsh >/dev/null 2>&1; then
  if confirm "Switch the login shell to $(command -v zsh)?"; then
    chsh -s "$(command -v zsh)"
  else
    log "Skipped login shell change."
  fi
fi

log "Shell prompt setup complete. Open a new terminal session to load the new shell config."

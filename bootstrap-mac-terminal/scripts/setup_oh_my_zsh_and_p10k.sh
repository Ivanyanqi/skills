#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"

require_macos

if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  log "正在安装 oh-my-zsh。"
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

if [[ -e "${HOME}/.zshrc" ]] && ! confirm "要用打包好的终端模板替换现有 ~/.zshrc 吗？"; then
  fail "用户取消了 ~/.zshrc 替换。"
fi

if [[ -e "${HOME}/.p10k.zsh" ]] && ! confirm "要用打包好的提示符配置替换现有 ~/.p10k.zsh 吗？"; then
  fail "用户取消了 ~/.p10k.zsh 替换。"
fi

backup_if_exists "${HOME}/.zshrc"
backup_if_exists "${HOME}/.p10k.zsh"

cp "${SKILL_ROOT}/assets/zsh/zshrc.template" "${HOME}/.zshrc"
cp "${SKILL_ROOT}/assets/zsh/p10k.zsh" "${HOME}/.p10k.zsh"

if [[ "${SHELL}" != */zsh ]] && command -v zsh >/dev/null 2>&1; then
  if confirm "要把登录 shell 切换成 $(command -v zsh) 吗？"; then
    chsh -s "$(command -v zsh)"
  else
    log "已跳过登录 shell 切换。"
  fi
fi

log "Shell 提示符配置完成。请打开一个新的终端会话以加载新配置。"

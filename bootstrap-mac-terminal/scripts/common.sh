#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

log() {
  printf '\n[%s] %s\n' "$(date +%H:%M:%S)" "$*"
}

fail() {
  printf '\n[ERROR] %s\n' "$*" >&2
  exit 1
}

confirm() {
  local prompt="$1"
  read -r -p "${prompt} [y/N] " reply || true
  [[ "${reply:-}" =~ ^[Yy]$ ]]
}

backup_path() {
  local target="$1"
  printf '%s.codex-bak.%s' "${target}" "${TIMESTAMP}"
}

backup_if_exists() {
  local target="$1"
  if [[ -e "${target}" || -L "${target}" ]]; then
    local backup
    backup="$(backup_path "${target}")"
    mv "${target}" "${backup}"
    log "已备份 ${target} -> ${backup}"
  fi
}

require_macos() {
  [[ "$(uname -s)" == "Darwin" ]] || fail "这个 skill 目前只支持 macOS。"
}

brew_bin() {
  if command -v brew >/dev/null 2>&1; then
    command -v brew
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    printf '/opt/homebrew/bin/brew\n'
  elif [[ -x /usr/local/bin/brew ]]; then
    printf '/usr/local/bin/brew\n'
  else
    return 1
  fi
}

ensure_line_in_file() {
  local line="$1"
  local file="$2"
  mkdir -p "$(dirname "${file}")"
  touch "${file}"
  if ! grep -Fqx "${line}" "${file}"; then
    printf '%s\n' "${line}" >> "${file}"
    log "已向 ${file} 添加内容：${line}"
  fi
}

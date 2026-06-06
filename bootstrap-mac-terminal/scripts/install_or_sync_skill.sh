#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"

target_dir="${HOME}/.codex/skills/bootstrap-mac-terminal"

if [[ "${SKILL_ROOT}" == "${target_dir}" ]]; then
  log "当前已经是在全局 Codex skills 目录中运行这个 skill。"
  exit 0
fi

mkdir -p "${HOME}/.codex/skills"
backup_if_exists "${target_dir}"
cp -R "${SKILL_ROOT}" "${target_dir}"

log "可移植 skill 已同步到 ${target_dir}"

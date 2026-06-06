#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"

target_dir="${HOME}/.codex/skills/bootstrap-mac-terminal"

if [[ "${SKILL_ROOT}" == "${target_dir}" ]]; then
  log "This skill is already running from the global Codex skills directory."
  exit 0
fi

mkdir -p "${HOME}/.codex/skills"
backup_if_exists "${target_dir}"
cp -R "${SKILL_ROOT}" "${target_dir}"

log "Portable skill synced to ${target_dir}"

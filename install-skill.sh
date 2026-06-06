#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
TARGET_ROOT="${HOME}/.codex/skills"

log() {
  printf '[install-skill] %s\n' "$*"
}

fail() {
  printf '[install-skill][ERROR] %s\n' "$*" >&2
  exit 1
}

install_one() {
  local skill_name="$1"
  local source_dir="${REPO_ROOT}/${skill_name}"
  local target_dir="${TARGET_ROOT}/${skill_name}"

  [[ -d "${source_dir}" ]] || fail "找不到 skill：${skill_name}"
  [[ -f "${source_dir}/SKILL.md" ]] || fail "${skill_name} 缺少 SKILL.md"

  mkdir -p "${TARGET_ROOT}"
  rm -rf "${target_dir}.codex-sync-old"
  if [[ -d "${target_dir}" ]]; then
    mv "${target_dir}" "${target_dir}.codex-sync-old"
    log "已备份现有目录 ${target_dir} -> ${target_dir}.codex-sync-old"
  fi

  cp -R "${source_dir}" "${target_dir}"
  log "已安装 ${skill_name} -> ${target_dir}"
}

discover_skills() {
  find "${REPO_ROOT}" -mindepth 1 -maxdepth 1 -type d ! -name ".git" | while read -r dir; do
    if [[ -f "${dir}/SKILL.md" ]]; then
      basename "${dir}"
    fi
  done
}

main() {
  local skills=()

  if [[ $# -gt 0 ]]; then
    skills=("$@")
  else
    while read -r skill; do
      [[ -n "${skill}" ]] && skills+=("${skill}")
    done < <(discover_skills)
  fi

  [[ ${#skills[@]} -gt 0 ]] || fail "没有找到可安装的 skill。"

  for skill in "${skills[@]}"; do
    install_one "${skill}"
  done

  log "完成。"
}

main "$@"

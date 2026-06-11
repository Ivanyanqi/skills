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

  # skill 级别的后置处理
  post_install "${skill_name}" "${target_dir}"
}

post_install() {
  local skill_name="$1"
  local target_dir="$2"

  case "${skill_name}" in
    mac-dev-setup)
      # 确保 ghostty 配置目录存在（install.sh --config-only 写入时需要）
      mkdir -p "${HOME}/.config/ghostty"
      log "已确保 ~/.config/ghostty 目录存在"
      ;;
  esac
}

discover_skills() {
  find "${REPO_ROOT}" -mindepth 1 -maxdepth 1 -type d ! -name ".git" | sort | while read -r dir; do
    if [[ -f "${dir}/SKILL.md" ]]; then
      basename "${dir}"
    fi
  done
}

list_skills() {
  log "可用的 skill："
  while read -r skill; do
    [[ -n "${skill}" ]] && printf '  - %s\n' "${skill}"
  done < <(discover_skills)
}

main() {
  local skills=()

  # 解析参数
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --list|-l)
        list_skills
        exit 0
        ;;
      --help|-h)
        echo "用法："
        echo "  ./install-skill.sh                  # 安装所有 skill"
        echo "  ./install-skill.sh mac-dev-setup    # 安装指定 skill"
        echo "  ./install-skill.sh --list           # 列出所有可用 skill"
        exit 0
        ;;
      *)
        skills+=("$1")
        shift
        ;;
    esac
  done

  # 未指定则安装全部
  if [[ ${#skills[@]} -eq 0 ]]; then
    while read -r skill; do
      [[ -n "${skill}" ]] && skills+=("${skill}")
    done < <(discover_skills)
  fi

  [[ ${#skills[@]} -gt 0 ]] || fail "没有找到可安装的 skill。"

  for skill in "${skills[@]}"; do
    install_one "${skill}"
  done

  log "完成。已安装 ${#skills[@]} 个 skill 到 ${TARGET_ROOT}"
}

main "$@"

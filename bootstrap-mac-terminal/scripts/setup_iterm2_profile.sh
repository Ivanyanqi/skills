#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"

require_macos

prefs_plist="${HOME}/Library/Preferences/com.googlecode.iterm2.plist"
profile_asset="${SKILL_ROOT}/assets/iterm2/default-profile.plist"
preset_asset="${SKILL_ROOT}/assets/iterm2/tokyo-night-preset.plist"
temp_plist="$(mktemp /tmp/bootstrap-mac-terminal-iterm2.XXXXXX.plist)"

cleanup() {
  rm -f "${temp_plist}"
}
trap cleanup EXIT

[[ -f "${profile_asset}" ]] || fail "Missing profile asset: ${profile_asset}"
[[ -f "${preset_asset}" ]] || fail "Missing preset asset: ${preset_asset}"

if [[ ! -f "${prefs_plist}" ]]; then
  fail "Launch iTerm2 once, then rerun this script so the preference file exists."
fi

cp "${prefs_plist}" "${temp_plist}"

default_guid="$(
  /usr/libexec/PlistBuddy -c 'Print :"Default Bookmark Guid"' "${temp_plist}" 2>/dev/null
)"
[[ -n "${default_guid}" ]] || fail "Could not read the default iTerm2 bookmark GUID."

profile_index=""
idx=0
while true; do
  guid="$(
    /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':${idx}:Guid" "${temp_plist}" 2>/dev/null || true
  )"
  if [[ -z "${guid}" ]]; then
    break
  fi
  if [[ "${guid}" == "${default_guid}" ]]; then
    profile_index="${idx}"
    break
  fi
  idx=$((idx + 1))
done

[[ -n "${profile_index}" ]] || fail "Could not locate the default iTerm2 profile."

/usr/libexec/PlistBuddy -c 'Print :"Custom Color Presets"' "${temp_plist}" >/dev/null 2>&1 || \
  /usr/libexec/PlistBuddy -c 'Add :"Custom Color Presets" dict' "${temp_plist}"
/usr/libexec/PlistBuddy -c 'Delete :"Custom Color Presets":"Tokyo Night"' "${temp_plist}" >/dev/null 2>&1 || true
/usr/libexec/PlistBuddy -c 'Add :"Custom Color Presets":"Tokyo Night" dict' "${temp_plist}"
/usr/libexec/PlistBuddy -c "Merge ${preset_asset} :'Custom Color Presets':'Tokyo Night'" "${temp_plist}"
/usr/libexec/PlistBuddy -c "Merge ${preset_asset} :'New Bookmarks':${profile_index}" "${temp_plist}"
/usr/libexec/PlistBuddy -c "Merge ${profile_asset} :'New Bookmarks':${profile_index}" "${temp_plist}"
/usr/libexec/PlistBuddy -c "Delete :'New Bookmarks':${profile_index}:'Background Image Location'" "${temp_plist}" >/dev/null 2>&1 || true

defaults import com.googlecode.iterm2 "${temp_plist}"
killall cfprefsd >/dev/null 2>&1 || true

log "iTerm2 profile defaults applied. Restart iTerm2 if it is already open."

#!/usr/bin/env bash

set -euo pipefail

# Switch the default Xcode to be incompatible, then use DEVELOPER_DIR 
# attribute on spm_repositories to specify the one that should be used.

exit_on_error() {
  local err_msg="${1:-}"
  [[ -n "${err_msg}" ]] || err_msg="Unspecified error occurred."
  echo >&2 "${err_msg}"
  exit 1
}

normalize_path() {
  local path="${1}"
  if [[ -d "${path}" ]]; then
    local dirname="$(dirname "${path}")"
  else
    local dirname="$(dirname "${path}")"
    local basename="$(basename "${path}")"
  fi
  dirname="$(cd "${dirname}" > /dev/null && pwd)"
  if [[ -z "${basename:-}" ]]; then
    echo "${dirname}"
  fi
  echo "${dirname}/${basename}"
}

do_sudo() {
  local sudo_flags=()
  [[ ! -z "${SUDO_ASKPASS:-}" ]] && sudo_flags+=(--askpass)
  sudo ${sudo_flags[@]:-} "${@:-}"
}

starting_dir="$(pwd)"
bazel_cmds=()
bazel="${BIT_BAZEL_BINARY:-}"
workspace_dir="${BIT_WORKSPACE_DIR:-}"

# Process args
while (("$#")); do
  case "${1}" in
    "--bazel")
      bazel_rel_path="${2}"
      shift 2
      ;;
    "--bazel_cmd")
      bazel_cmds+=("${2}")
      shift 2
      ;;
    "--workspace")
      workspace_path="${2}"
      shift 2
      ;;
    *)
      shift 1
      ;;
  esac
done


[[ -n "${bazel:-}" ]] || exit_on_error "Must specify the location of the Bazel binary."
[[ -n "${workspace_dir:-}" ]] || exit_on_error "Must specify the location of the workspace directory."

cd "${workspace_dir}"

# BEGIN Custom test logic 

# Find Xcode 12.4
xcode_12_4_locations=("/Applications/Xcode-12.4.app"  "/Applications/Xcode_12.4.app" "/Applications/Xcode-12.4.0.app")
for path in "${xcode_12_4_locations[@]}" ; do
  [[ -d "${path}" ]] && xcode_12_4_location="${path}" && break
done
[[ -z "${xcode_12_4_location:-}" ]]  && exit_on_error "Could not find Xcode 12.4."

# Identify the current default Xcode 
current_xcode=$(xcode-select --print-path)

# Set trap for cleanup
cleanup() {
  do_sudo xcode-select --switch "${current_xcode}"
  cd "${starting_dir}"
}
trap cleanup EXIT

# Switch default Xcode 12.4 which has SPM 5.3.
do_sudo xcode-select --switch "${xcode_12_4_location}"

# Use DEVELOPER_DIR to specify the current Xcode
export DEVELOPER_DIR="${current_xcode}"

# END Custom test logic 

# Execute the Bazel commands
for cmd in "${bazel_cmds[@]}" ; do
  # Break the cmd string into parts
  read -a cmd_parts <<< ${cmd}
  # Execute the Bazel command
  "${bazel}" "${cmd_parts[@]}"
done

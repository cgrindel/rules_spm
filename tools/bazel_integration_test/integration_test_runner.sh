#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)"

# DEBUG BEGIN
echo >&2 "*** CHUCK:  MADE IT" 
# DEBUG END

bazel_cmds=()

# DEBUG BEGIN
workspace_files=()
# DEBUG END

# Process args
while (("$#")); do
  case "${1}" in
    "--bazel")
      bazel="${2}"
      shift 2
      ;;
    "--bazel_cmd")
      bazel_cmds+=("${2}")
      shift 2
      ;;
    *)
      workspace_files+=("${1}")
      shift 1
      ;;
  esac
done

# DEBUG BEGIN
echo >&2 "*** CHUCK:  bazel: ${bazel}" 
echo >&2 "*** CHUCK:  workspace_files" 
for wfile in "${workspace_files[@]}" ; do
  echo >&2 "  wfile: ${wfile}" 
done
tree
# DEBUG END

for cmd in "${bazel_cmds[@]}" ; do
  # Break the cmd string into parts
  read -a cmd_parts <<< ${cmd}
  # DEBUG BEGIN
  echo >&2 "*** CHUCK:  cmd: ${cmd}" 
  echo >&2 "*** CHUCK:  #cmd_parts[@]: ${#cmd_parts[@]}" 
  # DEBUG END
  "${bazel}" "${cmd_parts[@]}"
done


# DEBUG BEGIN
exit 1
# DEBUG END

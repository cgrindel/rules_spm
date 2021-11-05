#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)"

# DEBUG BEGIN
echo >&2 "*** CHUCK:  MADE IT" 
# DEBUG END

bazel_cmds=()

# Process args
while (("$#")); do
  case "${1}" in
    "--bazel")
      bazel="${2}"
      shift 1
      ;;
    "--bazel_cmd")
      bazel_cmds+=("${2}")
      shift 1
      ;;
    *)
      shift 1
      ;;
  esac
done

# DEBUG BEGIN
echo >&2 "*** CHUCK:  bazel: ${bazel}" 
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

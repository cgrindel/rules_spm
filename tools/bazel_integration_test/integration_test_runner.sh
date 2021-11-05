#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)"

# DEBUG BEGIN
echo >&2 "*** CHUCK:  MADE IT" 
# DEBUG END

# Process args
while (("$#")); do
  case "${1}" in
    "--bazel")
      bazel="${2}"
      shift 1
      ;;
    *)
      shift 1
      ;;
  esac
done

# DEBUG BEGIN
echo >&2 "*** CHUCK:  bazel: ${bazel}" 
"${bazel}" version
exit 1
# DEBUG END

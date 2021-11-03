#!/usr/bin/env bash

set -euo pipefail

get_workspace_root() {
  local script_dir="${1}"
  if [[ ! -z "${BUILD_WORKING_DIRECTORY}"  ]]; then
    echo "${BUILD_WORKING_DIRECTORY}"
  else
    echo "$(cd "${script_dir}/.." > /dev/null && pwd)"
  fi
}

# Switch the default Xcode to be incompatible, then use DEVELOPER_DIR 
# attribute on spm_repositories to specify the one that should be used.

force_rebuild=false

# Process args
while (("$#")); do
  case "${1}" in
    "--clean")
      force_rebuild=true
      shift 1
      ;;
    "--example")
      example_workspace="${2}"
      shift 2
      ;;
    *)
      shift 1
      ;;
  esac
done

starting_dir="$(pwd)"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)"

# if [[ ! -z "${BUILD_WORKING_DIRECTORY}"  ]]; then
#   workspace_root="${BUILD_WORKING_DIRECTORY}"
# else
#   workspace_root="$(cd "${script_dir}/.." > /dev/null && pwd)"
# fi
workspace_root="$(get_workspace_root "${script_dir}")"

# Set trap for cleanup
cleanup() {
  cd "${starting_dir}"
}
trap cleanup EXIT

example_workspace_dir="${workspace_root}/examples/${example_workspace}"
cd "${example_workspace_dir}"

# Clean if this is a force
[[ ${force_rebuild} = true ]] && bazelisk clean

# Execute the tests
bazelisk test //...

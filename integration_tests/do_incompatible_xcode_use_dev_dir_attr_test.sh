#!/usr/bin/env bash

set -euo pipefail

# DEBUG BEGIN
set -x
# DEBUG END

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
    *)
      shift 1
      ;;
  esac
done

starting_dir="$(pwd)"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)"

if [[ ! -z "${BUILD_WORKING_DIRECTORY}"  ]]; then
  workspace_root="${BUILD_WORKING_DIRECTORY}"
else
  # workspace_root="${script_dir}/.."
  workspace_root="$(cd "${script_dir}/.." > /dev/null && pwd)"
fi

# simple_with_dev_dir
example_workspace="simple_with_dev_dir"
example_workspace_dir="${workspace_root}/examples/${example_workspace}"
cd "${example_workspace_dir}"

# Find Xcode 12.4
xcode_12_4_locations=("/Applications/Xcode-12.4.app"  "/Applications/Xcode_12.4.app")
for path in "${xcode_12_4_locations[@]}" ; do
  [[ -d "${path}" ]] && xcode_12_4_location="${path}" && break
done
[[ -z "${xcode_12_4_location:-}" ]]  && echo >&2 "Could not find Xcode 12.4." && exit 1

# Identify the current default Xcode 
current_xcode=$(xcode-select --print-path)
echo "current_xcode: ${current_xcode}"

# Set trap for cleanup
cleanup() {
  sudo xcode-select --switch "${current_xcode}"
  cd "${starting_dir}"
}
trap cleanup EXIT

# Switch default Xcode 12.4 which has SPM 5.3.
sudo xcode-select --switch "${xcode_12_4_location}"

[[ ${force_rebuild} = true ]] && bazelisk clean

# The DEVELOPER_DIR value is specified as an env attribute on spm_repositories.
# Execute the tests
bazelisk test //...

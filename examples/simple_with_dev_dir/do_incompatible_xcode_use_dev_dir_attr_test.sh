#!/usr/bin/env bash

set -euo pipefail

# Switch the default Xcode to be incompatible, then use DEVELOPER_DIR 
# attribute on spm_repositories to specify the one that should be used.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)"

# simple_with_dev_dir
pushd "${script_dir}"

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
  popd
}
trap cleanup EXIT

# Switch default Xcode 12.4 which has SPM 5.3.
sudo xcode-select --switch "${xcode_12_4_location}"

# The DEVELOPER_DIR value is specified as an env attribute on spm_repositories.
# Execute the tests
bazelisk test //...

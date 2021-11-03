#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)"

pushd "${script_dir}"

cleanup() {
  popd
}
trap cleanup EXIT


# Default Xcode has SPM 5.4 or later; build with Xcode that has SPM
# less than 5.4.
bazelisk test --xcode_version_config=//:host_xcodes //...


#!/usr/bin/env bash

# This was lovingly copied from
# https://github.com/bazelbuild/rules_python/blob/main/tools/bazel_integration_test/update_deleted_packages.sh.

# For integration tests, we want to be able to glob() up the sources inside a nested package
# See explanation in .bazelrc

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)"

if [[ -z "${BUILD_WORKING_DIRECTORY}"  ]]; then
  workspace_root="$(cd "${script_dir}/.." > /dev/null && pwd)"
else
  workspace_root="${BUILD_WORKING_DIRECTORY}"
fi

cd "${workspace_root}"

# Update the .bazelrc file with the deleted packages flag.
# The sed -i.bak pattern is compatible between macos and linux
sed -i.bak "/^[^#].*--deleted_packages/s#=.*#=$(\
    find examples/*/* \( -name BUILD -or -name BUILD.bazel \) | xargs -n 1 dirname | paste -sd, -\
)#" .bazelrc

# Remove the the backup file.
rm .bazelrc.bak


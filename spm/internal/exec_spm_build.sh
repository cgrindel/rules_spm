#!/usr/bin/env bash

set -euo pipefail

swift_worker="${1}"
build_config=${2}
package_path="${3}"
build_path="${4}"
shift 4


# Execute the SPM build
"${swift_worker}" swift build \
  --verbose \
  --manifest-cache none \
  --disable-sandbox \
  --disable-repository-cache \
  --configuration ${build_config} \
  --package-path "${package_path}" \
  --build-path "${build_path}"


# Replace the specified files with the provided ones
while (("$#")); do
  src="${1}"
  dest="${2}"
  cp -f "${src}" "${dest}"
  shift 2
done

#!/usr/bin/env bash

set -euo pipefail

build_config=${1}
package_path="${2}"
build_path="${3}"
shift 3

# Execute the SPM build
swift build \
  --manifest-cache none \
  --disable-sandbox \
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

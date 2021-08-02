#!/usr/bin/env bash

set -euo pipefail

swift_worker="${1}"
build_config=${2}
package_path="${3}"
build_path="${4}"
shift 4


# # DEBUG BEGIN
# set -x
# chuck_dbg_dir="${build_path}/chuck_debug"
# mkdir -p "${chuck_dbg_dir}"
# # WORKED
# # pushd "${chuck_dbg_dir}"
# # git clone -c core.symlinks=true --mirror https://github.com/apple/swift-nio.git
# # popd

# # WORKED
# # swift_nio_dir="${chuck_dbg_dir}/swift-nio-foo"
# # git clone -c core.symlinks=true --mirror https://github.com/apple/swift-nio.git "${swift_nio_dir}"

# set +x
# echo >&2 "*** CHUCK: FINISHED MANUAL CLONE" 
# # DEBUG END

# Execute the SPM build
"${swift_worker}" swift build \
  --verbose \
  --manifest-cache local \
  --disable-sandbox \
  --disable-repository-cache \
  --configuration ${build_config} \
  --package-path "${package_path}" \
  --build-path "${build_path}"

# "${swift_worker}" swift build \
#   --verbose \
#   --manifest-cache none \
#   --disable-sandbox \
#   --disable-repository-cache \
#   --configuration ${build_config} \
#   --package-path "${package_path}" \
#   --build-path "${build_path}"

# Replace the specified files with the provided ones
while (("$#")); do
  src="${1}"
  dest="${2}"
  cp -f "${src}" "${dest}"
  shift 2
done

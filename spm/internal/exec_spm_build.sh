#!/usr/bin/env bash

set -euo pipefail

swift_worker="${1}"
build_config=${2}
package_path="${3}"
build_path="${4}"
shift 4
# cache_path="${5}"
# shift 5

# The SPM deps that were fetched are in a directory in the source area with the
# same basename as the build_path.
fetched_dir="${package_path}/$(basename "${build_path}")"

# fetched_dir="${package_path}/spm_build"

# DEBUG BEGIN
echo >&2 "*** CHUCK:  pwd: $(pwd)" 
echo >&2 "*** CHUCK:  swift_worker: ${swift_worker}" 
echo >&2 "*** CHUCK:  build_config: ${build_config}" 
echo >&2 "*** CHUCK:  package_path: ${package_path}" 
echo >&2 "*** CHUCK:  build_path: ${build_path}" 

echo >&2 "*** CHUCK: Current Directory Listing:" 
ls -la

# fetched_dir="${package_path}/spm_build"
echo >&2 "*** CHUCK: Fetched Stuff: ${fetched_dir}" 
# tree -a "${fetched_dir}"

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
# DEBUG END

# Copy all of the fetch data to the output so that the SPM build will succeed?
cp -v -R -L "${fetched_dir}/" "${build_path}" 

# DEBUG BEGIN
# tree -a "${build_path}"
# DEBUG END

# Execute the SPM build
"${swift_worker}" swift build \
  --verbose \
  --manifest-cache none \
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

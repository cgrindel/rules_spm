#!/usr/bin/env bash

set -euo pipefail

swift_worker="${1}"
build_config=${2}
package_path="${3}"
build_path="${4}"
shift 4

# The SPM deps that were fetched are in a directory in the source area with the
# same basename as the build_path.
fetched_dir="${package_path}/$(basename "${build_path}")"

# DEBUG BEGIN
tree -d
# DEBUG END

# Copy all of the fetch data to the output so that the SPM build will succeed?
# Note the slash at the end of the source. It tells cp to copy the contents of
# the source directory not the actual directory.
cp -R -L "${fetched_dir}/" "${build_path}" 

# Execute the SPM build
"${swift_worker}" swift build \
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

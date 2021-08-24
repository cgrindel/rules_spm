#!/usr/bin/env bash

set -euo pipefail

args=()
while (("$#")); do
  case "${1}" in
    "--swift-worker")
      swift_worker="${2}"
      shift 2
      ;;
    "--build-config")
      build_config="${2}"
      shift 2
      ;;
    "--package-path")
      package_path="${2}"
      shift 2
      ;;
    "--build-path")
      build_path="${2}"
      shift 2
      ;;
    "--arch")
      arch="${2}"
      shift 2
      ;;
    *)
      args+=("${1}")
      shift 1
      ;;
  esac
done

# The SPM deps that were fetched are in a directory in the source area with the
# same basename as the build_path.
fetched_dir="${package_path}/$(basename "${build_path}")"

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
  --build-path "${build_path}" \
  --arch "${arch}"

# Replace the specified files with the provided ones
idx=0
while [ "$idx" -lt "${#args[@]}" ]; do
  src="${args[idx]}"
  dest="${args[idx+1]}"
  cp -f "${src}" "${dest}"
  idx=$((idx+2))
done

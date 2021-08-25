#!/usr/bin/env bash

set -euo pipefail

# DEBUG BEGIN
# echo >&2 "*** CHUCK:  __BAZEL_XCODE_SDKROOT__: ${__BAZEL_XCODE_SDKROOT__}" 
# echo >&2 "*** CHUCK:  SDKROOT: ${SDKROOT}" 
# DEBUG END

args=()
while (("$#")); do
  case "${1}" in
    # "--swift-worker")
    #   swift_worker="${2}"
    #   shift 2
    #   ;;
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
    "--target_triple")
      target_triple="${2}"
      shift 2
      ;;
    "--sdk_name")
      sdk_name="${2}"
      shift 2
      ;;
    # "--arch")
    #   arch="${2}"
    #   shift 2
    #   ;;
    *)
      args+=("${1}")
      shift 1
      ;;
  esac
done

sdk_path=$(xcrun --sdk "${sdk_name}" --show-sdk-path)

# The SPM deps that were fetched are in a directory in the source area with the
# same basename as the build_path.
fetched_dir="${package_path}/$(basename "${build_path}")"

# Copy all of the fetch data to the output so that the SPM build will succeed?
# Note the slash at the end of the source. It tells cp to copy the contents of
# the source directory not the actual directory.
cp -R -L "${fetched_dir}/" "${build_path}" 

# Execute the SPM build
# "${swift_worker}" swift build \
xcrun swift build \
  --manifest-cache none \
  --disable-sandbox \
  --disable-repository-cache \
  --configuration ${build_config} \
  --package-path "${package_path}" \
  --build-path "${build_path}" \
  -Xswiftc "-sdk" -Xswiftc "${sdk_path}" \
  -Xswiftc "-target" -Xswiftc "${target_triple}"

  # -Xswiftc "-sdk" -Xswiftc "__BAZEL_XCODE_SDKROOT__" \
  # --triple "${target_triple}"
  # --sdk "__BAZEL_XCODE_SDKROOT__" \
  # --arch "${arch}"

# Replace the specified files with the provided ones
idx=0
while [ "$idx" -lt "${#args[@]}" ]; do
  src="${args[idx]}"
  dest="${args[idx+1]}"
  cp -f "${src}" "${dest}"
  idx=$((idx+2))
done

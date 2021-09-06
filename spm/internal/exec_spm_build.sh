#!/usr/bin/env bash

set -euo pipefail

args=()
while (("$#")); do
  case "${1}" in
    "--swift")
      swift_exec="${2}"
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
    "--target_triple")
      target_triple="${2}"
      shift 2
      ;;
    "--sdk_name")
      sdk_name="${2}"
      shift 2
      ;;
    --*)
      echo >&2 "Unrecognized flag ${1}"
      exit 1
      ;;
    *)
      args+=("${1}")
      shift 1
      ;;
  esac
done

# DEBUG BEGIN
echo >&2 "*** CHUCK:  PATH: ${PATH}" 
# echo >&2 "*** CHUCK:  swift_exec: ${swift_exec}" 
# swift_dir=$(dirname $swift_exec)
# echo >&2 "*** CHUCK:  swift_dir: ${swift_dir}" 
# ls -l "${swift_dir}" >&2
# echo >&2 "*** CHUCK:  /usr/local/bin:" 
# ls -l /usr/local/bin >&2
# DEBUG END

# # Make sure that the Swift bin directory is first in the PATH. This addresses
# # the `invalid linker name in argument '-fuse-ld=gold'` error when running
# # SPM. In short, it allows SPM to find the correct linker.
# real_swift_exec=$(realpath $swift_exec)
# real_swift_dir=$(dirname $real_swift_exec)
# export PATH="${real_swift_dir}:$PATH"

# The SPM deps that were fetched are in a directory in the source area with the
# same basename as the build_path.
fetched_dir="${package_path}/$(basename "${build_path}")"

# Copy all of the fetch data to the output so that the SPM build will succeed?
# Note the slash followed by a period at the end of the source. It tells cp to 
# copy the contents of the source directory not the actual directory.
cp -R -L "${fetched_dir}/." "${build_path}" 

build_args=()
build_args+=(--manifest-cache none)
build_args+=(--disable-sandbox)
build_args+=(--disable-repository-cache)
build_args+=(--configuration ${build_config})
build_args+=(--package-path "${package_path}")
build_args+=(--build-path "${build_path}")
build_args+=(-Xswiftc "-target" -Xswiftc "${target_triple}")
build_args+=(-Xcc "-target" -Xcc "${target_triple}")

if [[ -n "${sdk_name:-}" ]]; then
  # NOTE: This will only succeed when Xcode is installed.
  sdk_path=$(xcrun --sdk "${sdk_name}" --show-sdk-path)
  build_args+=(-Xswiftc "-sdk" -Xswiftc "${sdk_path}")
fi

# Execute the SPM build
"${swift_exec}" build "${build_args[@]}"

# Replace the specified files with the provided ones
idx=0
while [ "$idx" -lt "${#args[@]}" ]; do
  src="${args[idx]}"
  dest="${args[idx+1]}"
  cp -f "${src}" "${dest}"
  idx=$((idx+2))
done

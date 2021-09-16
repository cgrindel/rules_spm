#!/usr/bin/env bash

set -euo pipefail

build_args=()
spm_utilities=()
args=()
while (("$#")); do
  case "${1}" in
    "--swift")
      worker_exec="${2}"
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
    "--spm_utility")
      spm_utilities+=("${2}")
      shift 2
      ;;
    "-Xspm")
      build_args+=("${2}")
      shift 2
      ;;
    -*)
      echo >&2 "Unrecognized flag ${1}"
      exit 1
      ;;
    *)
      args+=("${1}")
      shift 1
      ;;
  esac
done

# SPM leverages other utilities (e.g. git). Make sure that the directories that
# hold the utilities are in the PATH.
path_dirs=$(for util in "${spm_utilities[@]}"; do echo "$(dirname "${util}")"; done | sort -u)
for path_dir in "${path_dirs[@]}" ; do
  export PATH="${path_dir}:${PATH}"
done

# The SPM deps that were fetched are in a directory in the source area with the
# same basename as the build_path.
fetched_dir="${package_path}/$(basename "${build_path}")"

# Copy all of the fetch data to the output so that the SPM build will succeed?
# Note the slash followed by a period at the end of the source. It tells cp to 
# copy the contents of the source directory not the actual directory.
cp -R -L "${fetched_dir}/." "${build_path}" 

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
"${worker_exec}" swift build "${build_args[@]}"

# Replace the specified files with the provided ones
idx=0
while [ "$idx" -lt "${#args[@]}" ]; do
  src="${args[idx]}"
  dest="${args[idx+1]}"
  cp -f "${src}" "${dest}"
  idx=$((idx+2))
done

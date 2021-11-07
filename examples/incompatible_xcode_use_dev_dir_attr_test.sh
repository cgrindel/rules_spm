#!/usr/bin/env bash

set -euo pipefail

clean=false

# Process args
while (("$#")); do
  case "${1}" in
    "--clean")
      clean=true
      shift 1
      ;;
    *)
      shift 1
      ;;
  esac
done

starting_dir="$(pwd)"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)"

args=()
args+=(--bazel "$(which bazel)")
args+=(--workspace "${script_dir}/simple_with_dev_dir/WORKSPACE")
args+=(--bazel_cmd "info")
args+=(--bazel_cmd "test //...")
[[ ${clean} = true ]] && args+=(--clean)

. "${script_dir}/do_incompatible_xcode_use_dev_dir_attr_test.sh" "${args[@]}"


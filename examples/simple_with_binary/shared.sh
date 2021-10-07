#!/usr/bin/env bash

# Shared shell script code

# Find the temporary directory.
find_tmp_dir() {
  local tmp_dirs=("${TMPDIR:-}" "${TMP:-}" /var/tmp /tmp)
  local ret_val=""
  for tmp_dir in "${tmp_dirs[@]}" ; do
    [ -d "${tmp_dir}" ] && ret_val="${tmp_dir}" && break
  done
  echo "${ret_val}"
}

# Generates a Bazel execution script for the provided target.
# 
# Args:
#   exec_script: The path where to output the execution script.
#   target: The executable Bazel target.
#
# Returns:
#   None.
gen_exec_script() {
  local exec_script="${1}"
  local target="${2}"
  bazel run --script_path "${exec_script}" "${target}"
}

# Parses a Bazel execution script and returns the path to the built binary.
#
# Args:
#   exec_script: The execution script path.
# 
# Returns:
#   The path of the binary from the exection script.
get_exec_binary() {
  local exec_script="${1}"
  local exec_last_line=$(tail -n 1 "${exec_script}")
  local exec_last_line_parts=(${exec_last_line})
  echo "${exec_last_line_parts[0]:-}"
}

# Execute the specified target by generating a Bazel execution script, parsing the script for the 
# binary and executing the binary with the provided arguments.
#
# Args:
#   exec_script: The execution script path.
#   target: The executable Bazel target.
#
# Returns:
#   None.
execute_target() {
  local exec_script_name="${1}"
  local target="${2}"
  shift 2

  local tmp_dir=$(find_tmp_dir)
  local exec_script="${tmp_dir}/${exec_script_name}"

  # Generate Bazel's script for the binary, if it does not exist
  [ ! -f "${exec_script}" ] && gen_exec_script "${exec_script}" "${target}"

  # Find the executable
  binary=$(get_exec_binary "${exec_script}")

  # If the binary does not exist, generate the script which will build the binary
  if [[ ! -f "${binary}" ]]; then
    gen_exec_script "${exec_script}" "${target}"
    binary=$(get_exec_binary "${exec_script}")
  fi

  # Execute the command
  "${binary}" "${@:-}"
}

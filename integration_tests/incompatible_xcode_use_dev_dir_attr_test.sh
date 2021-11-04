# --- begin runfiles.bash initialization v2 ---
# Copy-pasted from the Bazel Bash runfiles library v2.
set -uo pipefail; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
  source "$0.runfiles/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  { echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v2 ---

err_msg() {
  local msg="$1"
  echo >&2 "${msg}"
  exit 1
}

# DEBUG BEGIN
echo >&2 "*** CHUCK:  BUILD_WORKING_DIRECTORY: ${BUILD_WORKING_DIRECTORY:-}" 
echo >&2 "*** CHUCK: orig  pwd: $(pwd)" 
mkdir fake_home
export HOME="$(pwd)/fake_home"
bazel version
tree

cd ../../../../../../../..
echo >&2 "*** CHUCK: workspace  pwd: $(pwd)" 
ls -l 
exit 1
# DEBUG END

# workspace="cgrindel_rules_spm"
# test_binary="$(rlocation "${workspace}/integration_tests/do_incompatible_xcode_use_dev_dir_attr_test.sh")"

# # expected="Hello World"
# # "${binary}" | grep "${expected}" || err_msg "Failed to find expected output. ${expected}"
# . "${test_binary}"


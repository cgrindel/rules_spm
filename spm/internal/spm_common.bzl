load("@bazel_skylib//lib:paths.bzl", "paths")

def _create_clang_hdrs_key(pkg_name, target_name):
    return "%s/%s" % (pkg_name, target_name)

_build_dirname = "spm_build"
_checkouts_path = paths.join(_build_dirname, "checkouts")

spm_common = struct(
    create_clang_hdrs_key = _create_clang_hdrs_key,
    build_dirname = _build_dirname,
    checkouts_path = _checkouts_path,
)

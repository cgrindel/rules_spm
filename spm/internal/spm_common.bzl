load("@bazel_skylib//lib:paths.bzl", "paths")

def _create_clang_hdrs_key(pkg_name, target_name):
    return "%s/%s" % (pkg_name, target_name)

def _get_pkg(pkgs, pkg_name):
    for pkg in pkgs:
        if pkg.spm_name == pkg_name:
            return pkg
    fail("Failed to find package", pkg_name)

_build_dirname = "spm_build"
_checkouts_path = paths.join(_build_dirname, "checkouts")

spm_common = struct(
    create_clang_hdrs_key = _create_clang_hdrs_key,
    build_dirname = _build_dirname,
    checkouts_path = _checkouts_path,
    get_pkg = _get_pkg,
)

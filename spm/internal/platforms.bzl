bzl_oss = struct(
    macos = "macos",
    # GH024: Add Linux support.
    # linux = "linux",
)

bzl_archs = struct(
    x86_64 = "x86_64",
    arm64 = "arm64",
)

spm_oss = struct(
    macos = "macosx",
)

spm_vendors = struct(
    apple = "apple",
)

supported_bzl_platforms = [
    (bzl_oss.macos, bzl_archs.x86_64),
    (bzl_oss.macos, bzl_archs.arm64),
    # GH024: Add Linux support.
    # (bzloss.linux, bzlarchs.x86_64),
    # (bzloss.linux, bzlarchs.arm64),
]

_bzl_to_spm_os_mapping = {
    bzl_oss.macos: spm_oss.macos,
}

_spm_os_to_vendor_mapping = {
    spm_oss.macos: spm_vendors.apple,
}

def _create_toolchain_impl_name(bzl_os, bzl_arch):
    return "spm_%s_%s" % (bzl_os, bzl_arch)

def _create_toolchain_name(bzl_os, bzl_arch):
    return "spm_%s_%s_toolchain" % (bzl_os, bzl_arch)

def _generate_toolchain_names():
    toolchain_names = []
    for bzl_os, bzl_arch in supported_bzl_platforms:
        toolchain_names.append(_create_toolchain_name(bzl_os, bzl_arch))
    return toolchain_names

def _get_spm_arch(bzl_arch):
    # No mapping at this time.
    return bzl_arch

def _get_spm_os(bzl_os):
    spm_os = _bzl_to_spm_os_mapping.get(bzl_os)
    if spm_os == None:
        fail("No SPM OS mapping for %s." % (bzl_os))
    return spm_os

def _get_spm_vendor(bzl_os):
    spm_os = _get_spm_os(bzl_os)
    spm_vendor = _spm_os_to_vendor_mapping.get(spm_os)
    if spm_vendor == None:
        fail("Vendor name not found for %s OS." % (bzl_os))
    return spm_vendor

platforms = struct(
    toolchain_impl_name = _create_toolchain_impl_name,
    toolchain_name = _create_toolchain_name,
    toolchain_names = _generate_toolchain_names,
    spm_os = _get_spm_os,
    spm_arch = _get_spm_arch,
    spm_vendor = _get_spm_vendor,
)

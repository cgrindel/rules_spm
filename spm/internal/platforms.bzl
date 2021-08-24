# bzl_oss = struct(
#     macos = "macos",
#     ios = "ios",
#     # GH024: Add Linux support.
#     # linux = "linux",
# )

# bzl_archs = struct(
#     x86_64 = "x86_64",
#     # https://stackoverflow.com/questions/52624308/xcode-arm64-vs-arm64e
#     arm64 = "arm64",
#     arm64e = "arm64e",
# )

swift_oss = struct(
    macos = "darwin",
    ios = "ios",
    # GH024: Add Linux support.
    # linux = "linux",
)

spm_oss = struct(
    macos = "macosx",
    ios = "ios",
)

spm_vendors = struct(
    apple = "apple",
)

# SUPPORTED_BZL_PLATFORMS = [
#     (bzl_oss.macos, bzl_archs.x86_64),
#     (bzl_oss.macos, bzl_archs.arm64),
#     # (bzl_oss.macos, bzl_archs.arm64e),
#     (bzl_oss.ios, bzl_archs.arm64),
#     # GH024: Add Linux support.
#     # (bzloss.linux, bzlarchs.x86_64),
#     # (bzloss.linux, bzlarchs.arm64),
# ]

# _bzl_to_spm_os_mapping = {
#     bzl_oss.macos: spm_oss.macos,
#     bzl_oss.ios: spm_oss.ios,
# }

_swift_to_spm_os_mapping = {
    swift_oss.macos: spm_oss.macos,
    swift_oss.ios: spm_oss.ios,
}

_spm_os_to_vendor_mapping = {
    spm_oss.macos: spm_vendors.apple,
    spm_oss.ios: spm_vendors.apple,
}

# def _create_toolchain_impl_name(bzl_os, bzl_arch):
#     """Create the name for the toolchain implementation.

#     Args:
#         bzl_os: A `string` representing the Bazel OS value.
#         bzl_arch: A `string` representing the Bazel architecture value.

#     Returns:
#         A `string`.
#     """
#     return "spm_%s_%s" % (bzl_os, bzl_arch)

# def _create_toolchain_name(bzl_os, bzl_arch):
#     """Create the name for the toolchain.

#     Args:
#         bzl_os: A `string` representing the Bazel OS value.
#         bzl_arch: A `string` representing the Bazel architecture value.

#     Returns:
#         A `string`.
#     """
#     return "spm_%s_%s_toolchain" % (bzl_os, bzl_arch)

# def _generate_toolchain_names():
#     """Generates a list of the supported toolchain names.

#     Returns:
#        A `list` of toolchain names (see `platforms.toolchain_name()`).
#     """
#     toolchain_names = []
#     for bzl_os, bzl_arch in SUPPORTED_BZL_PLATFORMS:
#         toolchain_names.append(_create_toolchain_name(bzl_os, bzl_arch))
#     return toolchain_names

# def _get_spm_arch(bzl_arch):
#     """Maps the Bazel architeture value to a suitable SPM architecture value.

#     Args:
#         bzl_arch: A `string` representing the Bazel architecture value.

#     Returns:
#         A `string` representing the SPM architecture value.
#     """

#     # No mapping at this time.
#     return bzl_arch

# def _get_spm_os(bzl_os):
#     """Maps the Bazel OS value to a suitable SPM OS value.

#     Args:
#         bzl_os: A `string` representing the Bazel OS value.

#     Returns:
#         A `string` representing the SPM OS value.
#     """
#     spm_os = _bzl_to_spm_os_mapping.get(bzl_os)
#     if spm_os == None:
#         fail("No SPM OS mapping for %s." % (bzl_os))
#     return spm_os

# def _get_spm_vendor(bzl_os):
#     """Maps the Bazel OS value to the corresponding SPM vendor value.

#     Args:
#         bzl_os: A `string` representing the Bazel OS value.

#     Returns:
#         A `string` representing the SPM vendor value.
#     """
#     spm_os = _get_spm_os(bzl_os)
#     spm_vendor = _spm_os_to_vendor_mapping.get(spm_os)
#     if spm_vendor == None:
#         fail("Vendor name not found for %s OS." % (bzl_os))
#     return spm_vendor

def _get_spm_arch(swift_cpu):
    """Maps the Bazel architeture value to a suitable SPM architecture value.

    Args:
        bzl_arch: A `string` representing the Bazel architecture value.

    Returns:
        A `string` representing the SPM architecture value.
    """

    # No mapping at this time.
    return swift_cpu

def _get_spm_os(swift_os):
    """Maps the Bazel OS value to a suitable SPM OS value.

    Args:
        bzl_os: A `string` representing the Bazel OS value.

    Returns:
        A `string` representing the SPM OS value.
    """
    spm_os = _swift_to_spm_os_mapping.get(swift_os.lower())
    if spm_os == None:
        fail("No SPM OS mapping for %s." % (swift_os))
    return spm_os

def _get_spm_vendor(swift_os):
    """Maps the Bazel OS value to the corresponding SPM vendor value.

    Args:
        bzl_os: A `string` representing the Bazel OS value.

    Returns:
        A `string` representing the SPM vendor value.
    """
    spm_os = _get_spm_os(swift_os)
    spm_vendor = _spm_os_to_vendor_mapping.get(spm_os)
    if spm_vendor == None:
        fail("Vendor name not found for %s OS." % (swift_os))
    return spm_vendor

platforms = struct(
    # toolchain_impl_name = _create_toolchain_impl_name,
    # toolchain_name = _create_toolchain_name,
    # toolchain_names = _generate_toolchain_names,
    spm_os = _get_spm_os,
    spm_arch = _get_spm_arch,
    spm_vendor = _get_spm_vendor,
)

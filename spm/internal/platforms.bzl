swift_oss = struct(
    macos = "darwin",
    ios = "ios",
    # GH024: Add Linux support.
    # linux = "linux",
)

swift_archs = struct(
    x86_64 = "x86_64",
    # https://stackoverflow.com/questions/52624308/xcode-arm64-vs-arm64e
    arm64 = "arm64",
    arm64e = "arm64e",
)

spm_oss = struct(
    macos = "macosx",
    ios = "ios",
)

spm_vendors = struct(
    apple = "apple",
)

_swift_to_spm_os_mapping = {
    swift_oss.macos: spm_oss.macos,
    swift_oss.ios: spm_oss.ios,
}

_spm_os_to_vendor_mapping = {
    spm_oss.macos: spm_vendors.apple,
    spm_oss.ios: spm_vendors.apple,
}

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

    # No mapping at this time.
    return swift_os

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
    spm_os = _get_spm_os,
    spm_arch = _get_spm_arch,
    spm_vendor = _get_spm_vendor,
)

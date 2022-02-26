"""Definition for swift_toolchains module."""

def _get_sdk_name(platform):
    """Returns the SDK name for the provided platform.

    Args:
        platform: The `apple_platform` value describing the target platform.

    Returns:
        A `string` value representing the SDK name.
    """
    return platform.name_in_plist.lower()

def _get_os_name(platform):
    """Returns the OS name for the given platform. This value can be used when constructing target triplets.

    Args:
        platform: The `apple_platform` value describing the target platform.

    Returns:
        A `string` value representing the OS name.
    """
    platform_string = str(platform.platform_type)
    if platform_string == "macos":
        platform_string = "macosx"
    return platform_string

def _target_triple(arch, vendor, sys, abi = ""):
    """Creates a target triple.

    Documentation:
        https://clang.llvm.org/docs/CrossCompilation.html#target-triple

    Args:
        arch: A `string` representing the architecture. (e.g. `x86_64`,
              `arm64`)
        vendor: A `string` representing the vendor. (e.g. `apple`, `nvidia`,
                `unknown`)
        sys: A `string` representing the operating system. (e.g. `none`,
             `linux`, `darwin`)
        abi: Optional. A `string` representing the abi. (e.g. `gnu`, `android`)

    Returns:
        A `string` representing a target triple.
    """
    triple = "{arch}-{vendor}-{sys}".format(
        arch = arch,
        vendor = vendor,
        sys = sys,
    )
    if abi:
        triple = triple + "-" + abi
    return triple

# This was heavily inspired by
# https://github.com/bazelbuild/rules_swift/blob/master/swift/internal/xcode_swift_toolchain.bzl#L594.
def _swift_apple_target_triple(cpu, platform, version):
    """Returns a target triple string for an Apple platform.

    Args:
        cpu: The CPU of the target.
        platform: The `apple_platform` value describing the target platform.
        version: The target platform version as a dotted version string.

    Returns:
        A target triple `string` describing the platform.
    """
    platform_string = _get_os_name(platform)
    environment = ""
    if not platform.is_device:
        environment = "-simulator"

    sys = "{platform}{version}{environment}".format(
        environment = environment,
        platform = platform_string,
        version = version,
    )
    return _target_triple(
        arch = cpu,
        vendor = "apple",
        sys = sys,
    )

swift_toolchains = struct(
    apple_target_triple = _swift_apple_target_triple,
    sdk_name = _get_sdk_name,
    os_name = _get_os_name,
    target_triple = _target_triple,
)

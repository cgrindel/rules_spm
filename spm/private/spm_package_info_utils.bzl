"""Definition for spm_package_info_utils module."""

def _get(pkg_infos, pkg_name):
    """Returns the `SPMPackageInfo` with the specified name from the list of `SPMPackageInfo` values.

    Args:
        pkg_infos: A `list` of `SPMPackageInfo` values.
        pkg_name: A `string` representing the name of the desired
                  `SPMPackageInfo`.

    Returns:
        An `SPMPackageInfo` value.
    """
    for pi in pkg_infos:
        if pi.name == pkg_name:
            return pi
    fail("Could not find package with name", pkg_name)

def _get_module_info(pkg_info, module_name):
    """Returns the module information with the specified module name.

    Args:
        pkg_info: An `SPMPackageInfo` value.
        module_name: The module name `string`.

    Returns:
        If the module is a Swift module, a `struct` value as created by
        `providers.swift_module()` is returend. If the module is a clang
        module a `struct` value as created by `providers.clang_module()` is
        returned.
    """
    for binary in pkg_info.swift_binaries:
        if binary.name == module_name:
            return binary
    for module in pkg_info.swift_modules:
        if module.module_name == module_name:
            return module
    for module in pkg_info.clang_modules:
        if module.module_name == module_name:
            return module
    for module in pkg_info.system_library_modules:
        if module.module_name == module_name:
            return module
    fail("Could not find module with name", module_name, "in package", pkg_info.name)

spm_package_info_utils = struct(
    get = _get,
    get_module_info = _get_module_info,
)

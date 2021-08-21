SPMOS_SPMARCH = [
    ("macos", "x86_64"),
    ("macos", "arm64"),
    # GH024: Add Linux support.
    # ("linux", "x86_64"),
    # ("linux", "arm64"),
]

def _create_toolchain_impl_name(spmos, spmarch):
    return "spm_%s_%s" % (spmos, spmarch)

def _create_toolchain_name(spmos, spmarch):
    return "spm_%s_%s_toolchain" % (spmos, spmarch)

def _generate_toolchain_names():
    toolchain_names = []
    for spmos, spmarch in SPMOS_SPMARCH:
        toolchain_names.append(_create_toolchain_name(spmos, spmarch))
    return toolchain_names

platforms = struct(
    toolchain_impl_name = _create_toolchain_impl_name,
    toolchain_name = _create_toolchain_name,
    toolchain_names = _generate_toolchain_names,
)

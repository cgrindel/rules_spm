load(
    "//spm/internal:repositories.bzl",
    _spm_rules_depdenencies = "spm_rules_dependencies",
)
load(
    "//spm/internal:spm_toolchain.bzl",
    _spm_register_toolchains = "spm_register_toolchains",
)

# Depdency Loading
spm_rules_dependencies = _spm_rules_depdenencies

spm_register_toolchains = _spm_register_toolchains

# MARK: - Register Toolchains

# _toolchain_names = [
#     "linux_toolchain",
#     "xcode_toolchain",
# ]

# def spm_register_toolchains():
#     """Called by clients of rules_spm to register the SPM toolchains."""
#     toolchain_labels = [SPM_LABEL_PREFIX + n for n in _toolchain_names]
#     native.register_toolchains(*toolchain_labels)

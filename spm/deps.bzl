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

# Toolchain Registration
spm_register_toolchains = _spm_register_toolchains

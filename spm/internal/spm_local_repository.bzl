load(":spm_repository_common.bzl", "configure_spm_repository")

def _spm_local_repository_impl(repository_ctx):
    # Make the code available via symlink or copy
    # TODO: IMPLEMENT ME!

    # Configure the repo
    configure_spm_repository(repository_ctx)

spm_local_repository = repository_rule(
    implementation = _spm_local_repository_impl,
    attrs = {
        "path": attr.string(
            mandatory = True,
            doc = "The path to the SPM package.",
        ),
        "_build_tpl": attr.label(
            default = "//spm/internal:BUILD.bazel.tpl",
        ),
    },
)

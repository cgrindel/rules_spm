load(":spm_repository_common.bzl", "configure_spm_repository")

def _spm_repository_impl(repository_ctx):
    # Download the archive
    repository_ctx.download_and_extract(
        url = repository_ctx.attr.urls,
        sha256 = repository_ctx.attr.sha256,
        stripPrefix = repository_ctx.attr.strip_prefix,
    )

    # Configure the repo
    configure_spm_repository(repository_ctx)

spm_repository = repository_rule(
    implementation = _spm_repository_impl,
    attrs = {
        "sha256": attr.string(),
        "strip_prefix": attr.string(),
        "urls": attr.string_list(
            mandatory = True,
            allow_empty = False,
            doc = "The URLs to use to download the repository.",
        ),
        "_build_tpl": attr.label(
            default = "//spm/internal:BUILD.bazel.tpl",
        ),
    },
)

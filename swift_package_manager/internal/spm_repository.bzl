def _spm_repository_impl(ctx):
    # Download the archive
    ctx.download_and_extract(
        url = ctx.attr.urls,
        sha256 = ctx.attr.sha256,
        stripPrefix = ctx.attr.strip_prefix,
    )

    # Template Substitutions
    substitutions = {
        "{spm_repos_name}": ctx.attr.name,
    }

    # Write BUILD.bazel file.
    ctx.template(
        "BUILD.bazel",
        ctx.attr._build_tpl,
        substitutions = substitutions,
        executable = False,
    )

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
            default = "@rules_swift_package_manager//swift_package_manager/internal:BUILD.bazel.tpl",
        ),
    },
)

# load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
# load("@rules_swift_package_manager//swift_package_manager/internal:spm_repository_info.bzl", "spm_repository_info")
#
# def spm_repository(name, urls, sha256, strip_prefix):
#     spm_repos_info_name = "%s_repos_info" % (name)
#     gen_build_file_name = "%s_build_file" % (name)
#
#     spm_repository_info(
#         name = spm_repos_info_name,
#         repos_name = name,
#     )
#
#     native.genrule(
#         name = gen_build_file_name,
#         outs = ["BUILD.%s" % (name)],
#         srcs = [
#             "@rules_swift_package_manager//swift_package_manager/internal:BUILD.spm_package.bzl",
#         ],
#         cmd = """
#         cat $(location @rules_swift_package_manager//swift_package_manager/internal:BUILD.spm_package.bzl) > $@
#         echo "SPM_REPOS_NAME = \"$(SPM_REPOS_NAME)\"" >> $@
#         """,
#         toolchains = [
#             ":%s" % (spm_repos_info_name),
#         ],
#     )
#
#     # TODO: Add archive name to spm_package and finish generating BUILD file.
#
#     http_archive(
#         name = name,
#         build_file = ":%s" % (gen_build_file_name),
#         sha256 = sha256,
#         strip_prefix = strip_prefix,
#         urls = urls,
#     )

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@rules_swift_package_manager//swift_package_manager/internal:spm_repository_info.bzl", "spm_repository_info")

def spm_repository(name, urls, sha256, strip_prefix):
    spm_repos_info_name = "%s_repos_info" % (name)
    gen_build_file_name = "%s_build_file" % (name)

    spm_repository_info(
        name = spm_repos_info_name,
        repos_name = name,
    )

    native.genrule(
        name = gen_build_file_name,
        outs = ["BUILD.%s" % (name)],
        srcs = [
            "@rules_swift_package_manager//swift_package_manager/internal:BUILD.spm_package.bzl",
        ],
        cmd = """
        cat $(location @rules_swift_package_manager//swift_package_manager/internal:BUILD.spm_package.bzl) > $@
        echo "SPM_REPOS_NAME = \"$(SPM_REPOS_NAME)\"" >> $@
        """,
        toolchains = [
            ":%s" % (spm_repos_info_name),
        ],
    )

    # TODO: Add archive name to spm_package and finish generating BUILD file.

    http_archive(
        name = name,
        build_file = ":%s" % (gen_build_file_name),
        sha256 = sha256,
        strip_prefix = strip_prefix,
        urls = urls,
    )

# def spm_repository(name, urls, sha256, strip_prefix):
#     http_archive(
#         name = name,
#         build_file = "@rules_swift_package_manager//swift_package_manager/internal:BUILD.spm_package.bzl",
#         sha256 = sha256,
#         strip_prefix = strip_prefix,
#         urls = urls,
#     )

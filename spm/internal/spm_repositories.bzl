load(":packages.bzl", "packages")

def _spm_repositories_impl(repository_ctx):
    pkgs = [packages.from_json(j) for j in repository_ctx.attr.dependencies]

    # DEBUG BEGIN
    print("*** CHUCK pkgs: ")
    for idx, item in enumerate(pkgs):
        print("*** CHUCK", idx, ":", item)

    # DEBUG END
    pass

spm_repositories = repository_rule(
    implementation = _spm_repositories_impl,
    attrs = {
        "dependencies": attr.string_list(
            mandatory = True,
            doc = "List of JSON strings specifying the SPM packages to load.",
        ),
    },
)

spm_pkg = packages.pkg_json

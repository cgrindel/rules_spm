load(":packages.bzl", "packages")

def _spm_repositories_impl(repository_ctx):
    packages = repository_ctx.attr.dependencies

    # DEBUG BEGIN
    print("*** CHUCK packages: ")
    for idx, item in enumerate(packages):
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

def spm_pkg(url, name = None, from_version = None):
    if name == None:
        name = packages.create_name(url)

    repo_dict = {
        "url": url,
        "name": name,
        "from": from_version,
    }
    return json.encode(repo_dict)

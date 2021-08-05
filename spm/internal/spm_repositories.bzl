load(":packages.bzl", "packages")

_package_tpl = """\
.package(url: "%s", from: "%s")\
"""

_target_dep_tpl = """\
.product(name: "%s", package: "%s")\
"""

def _spm_repositories_impl(repository_ctx):
    pkgs = [packages.from_json(j) for j in repository_ctx.attr.dependencies]

    # DEBUG BEGIN
    print("*** CHUCK pkgs: ")
    for idx, item in enumerate(pkgs):
        print("*** CHUCK", idx, ":", item)

    # DEBUG END

    # Generate Package.swift
    pkg_deps = [_package_tpl % (pkg.url, pkg.from_version) for pkg in pkgs]
    target_deps = [_target_dep_tpl % (pname, pkg.name) for pkg in pkgs for pname in pkg.products]
    substitutions = {
        "{swift_tools_version}": repository_ctx.attr.swift_version,
        "{swift_platforms}": ",\n".join(["    %s" % (p) for p in repository_ctx.attr.platforms]),
        "{package_dependencies}": ",\n".join(["    %s" % (d) for d in pkg_deps]),
        "{target_dependencies}": ",\n".join(["      %s" % (d) for d in target_deps]),
    }
    repository_ctx.template(
        "Package.swift",
        repository_ctx.attr._package_swift_tpl,
        substitutions = substitutions,
        executable = False,
    )

    # Create barebones source files
    repository_ctx.file(
        "Sources/Placeholder/Placeholder.swift",
        content = "# Intentionally blank",
        executable = False,
    )

    # Configure the SPM package

    pass

spm_repositories = repository_rule(
    implementation = _spm_repositories_impl,
    attrs = {
        "dependencies": attr.string_list(
            mandatory = True,
            doc = "List of JSON strings specifying the SPM packages to load.",
        ),
        "swift_version": attr.string(
            default = "5.3",
            doc = """\
            The version of Swift that will be declared in the placeholder/uber Swift package.\
            """,
        ),
        "platforms": attr.string_list(
            doc = """\
            The platforms to declare in the placeholder/uber Swift package. \
            (e.g. .macOS(.v10_15))\
            """,
        ),
        "_package_swift_tpl": attr.label(
            default = "//spm/internal:Package.swift.tpl",
        ),
    },
)

spm_pkg = packages.pkg_json

"""Module for defining and generating Bazel build files."""

load(":references.bzl", refs = "references")

def _load_statement(location, *symbols):
    # TODO: Sort and uniquify symbols
    # TODO: Ensure that at least one symbol was specified.
    return struct(
        location = location,
        symbols = symbols,
    )

def _target(type, name, declaration):
    return struct(
        type = type,
        name = name,
        declaration = declaration,
    )

def _create(load_statements = [], targets = []):
    # TODO: Sort and uniquify load_statements.
    # TODO: Sort targets by type and name.
    # TODO: Ensure that no target names are the same.
    return struct(
        load_statements = load_statements,
        targets = targets,
    )

def _merge(a, b):
    return _create(
        load_statements = a.load_statements + b.load_statements,
        targets = a.targets + b.targets,
    )

def _generate_load_statement(load_stmt):
    symbols_str = ", ".join([
        "\"{}\"".format(s)
        for s in load_stmt.symbols
    ])
    return """load("{location}", {symbols})""".format(
        location = load_stmt.location,
        symbols = symbols_str,
    )

def _generate_build_file_content(build_decl):
    load_statements = "\n".join([
        _generate_load_statement(ls)
        for ls in build_decl.load_statements
    ])
    target_decls = "".join([t.declaration for t in build_decl.targets])
    return load_statements + "\n" + target_decls

def _write_build_file(repository_ctx, path, build_decl):
    content = _generate_build_file_content(build_decl)
    repository_ctx.file(path, content = content, executable = False)

def _create_bazel_dep_str(pkg_name, target_ref):
    _rtype, pname, tname = refs.split(target_ref)
    if pname == pkg_name:
        return ":%s" % (tname)
    return "//%s:%s" % (pname, tname)

def _create_bazel_deps_str(pkg_name, target_deps):
    """Create deps list string suitable for injection into a module template.

    Args:
        pkg_name: The name of the Swift package as a `string`.
        target_deps: A `list` of the target's dependencies as target
                     references.

    Returns:
        A `string` value.
    """
    target_labels = []
    for target_ref in target_deps:
        target_labels.append(_create_bazel_dep_str(pkg_name, target_ref))
    deps = ["        \"%s\"," % (label) for label in target_labels]
    return "\n".join(deps)

build_declarations = struct(
    # Target Declaration
    target = _target,
    # Load Statement
    load_statement = _load_statement,
    # Build Declaration
    create = _create,
    merge = _merge,
    # Build File Generation
    generate_build_file_content = _generate_build_file_content,
    write_build_file = _write_build_file,
    # Dependencies
    create_bazel_deps_str = _create_bazel_deps_str,
)

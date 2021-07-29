# MARK: - Module Declarations

_declaration_types = struct(
    module = "module",
    extern_module = "extern_module",
    single_header = "single_header",
    umbrella_header = "umbrella_header",
    exclude_header = "exclude_header",
)

def _create_module_decl(module_id, explicit = False, framework = False, attributes = [], members = []):
    """Create a module declaration.

    Spec: https://clang.llvm.org/docs/Modules.html#module-declaration

    Args:
        module_id: A `string` that identifies the module.
        explicit: A `bool` that designates the module as explicit.
        framework: A `bool` that designzates the module as being Darwin framework.
        attributes: A `list` of `string` values specified as attrivutes.
        members: A `list` of the module members.

    Returns:
        A `struct` representing a module declaration.
    """
    return struct(
        decl_type = _declaration_types.module,
        module_id = module_id,
        explicit = explicit,
        framework = framework,
        attributes = attributes,
        members = members,
    )

def _create_extern_module_decl(module_id, definition_path):
    """Create an extern module declaration.

    Spec: https://clang.llvm.org/docs/Modules.html#module-declaration

    Args:
        module_id: A `string` that identifies the module.
        definition_path: The path (`string`) to a file that contains the definition for the
                         identified module.

    Returns:
        A `struct` representing an extern module declaration.
    """
    return struct(
        decl_type = _declaration_types.extern_module,
        module_id = module_id,
        definition_path = definition_path,
    )

# MARK: - Module Member Declarations

def _create_header_attributes(size = None, mtime = None):
    """Creates a struct representing header attributes.

    Spec: https://clang.llvm.org/docs/Modules.html#header-declaration

    Args:
        size: An `int` specifying the size attribute value.
        mtime: An `int` specifying the mtime attribute value.

    Returns:
        A `struct` representing header attribute values.
    """
    return struct(
        size = size,
        mtime = mtime,
    )

def _create_single_header(path, private = False, textual = False, attribs = None):
    """Creates a `struct` representing a single header declaration.

    Spec: https://clang.llvm.org/docs/Modules.html#header-declaration

    Args:
        path: A `string` specifying the path to the header.
        private: A `bool` specifying whether it is private.
        textual: A `bool` specifying whether it is a textual header.
        attribs: A `struct` as returned from `declarations.header_attribs()` representing the
                 header attributes.

    Returns:
        A `struct` representing a single
    """
    return struct(
        decl_type = _declaration_types.single_header,
        path = path,
        private = private,
        textual = textual,
        attribs = attribs,
    )

def _create_umbrella_header(path, attribs = None):
    """Creates a `struct` representing an umbrella header declaration.

    Spec: https://clang.llvm.org/docs/Modules.html#header-declaration

    Args:
        path: A `string` specifying the path to the header.
        attribs: A `struct` as returned from `declarations.header_attribs()` representing the
                 header attributes.

    Returns:
        A `struct` representing an umbrella header declaration.
    """
    return struct(
        decl_type = _declaration_types.umbrella_header,
        path = path,
        attribs = attribs,
    )

def _create_exclude_header(path, attribs = None):
    """Creates a `struct` representing an exclude header declaration.

    Spec: https://clang.llvm.org/docs/Modules.html#header-declaration

    Args:
        path: A `string` specifying the path to the header.
        attribs: A `struct` as returned from `declarations.header_attribs()` representing the
                 header attributes.

    Returns:
        A `struct` representing an exclude header declaration.
    """
    return struct(
        decl_type = _declaration_types.exclude_header,
        path = path,
        attribs = attribs,
    )

# MARK: - Namespaces

declaration_types = _declaration_types

declarations = struct(
    module = _create_module_decl,
    extern_module = _create_extern_module_decl,
    header_attribs = _create_header_attributes,
    single_header = _create_single_header,
)

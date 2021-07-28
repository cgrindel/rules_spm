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
        module_id = module_id,
        definition_path = definition_path,
    )

declarations = struct(
    module = _create_module_decl,
    extern_module = _create_extern_module_decl,
)

def collect_export_declaration(parsed_tokens):
    """Collect export declaration.

    Spec: https://clang.llvm.org/docs/Modules.html#export-declaration

    Syntax:
        export-declaration:
          export wildcard-module-id

        wildcard-module-id:
          identifier
          '*'
          identifier '.' wildcard-module-id

    Args:
        parsed_tokens: A `list` of tokens.

    Returns:
        A `tuple` where the first item is the collection result and the second is an
        error `struct` as returned from errors.create().
    """
    pass

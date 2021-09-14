def _create(
        name,
        doc_label = None,
        out_basename = None,
        doc_basename = None,
        header = None,
        symbols = None,
        is_stardoc = True):
    """Create a documentation provider.

    Args:
        name: A `string` which identifies the doc output. If no `symbols`
              are provided, all of the symbols which are defined in the
              corresponding `.bzl` file are documented.
        doc_label: Optional. A `string` which is the doc label name.
        out_basename: Optional. A `string` which is the basename for the
                      output file.
        doc_basename: Optional. A `string` which is the basename for the
                      final documentation file.
        header: Optional. The basename (`string`) of the header file, if
                one is being used.
        symbols: Optional. A `list` of symbol names that should be included
                 in the documentation.
        is_stardoc: A `bool` indicating whether a `stardoc` declaration should
                    be created.

    Returns:
      A `struct` representing a documentation provider.
    """
    if doc_label == None:
        doc_label = name + "_doc"
    if out_basename == None:
        out_basename = name + ".md_"
    if doc_basename == None:
        doc_basename = name + ".md"

    return struct(
        name = name,
        doc_label = doc_label,
        out_basename = out_basename,
        doc_basename = doc_basename,
        header = header,
        symbols = symbols,
        is_stardoc = is_stardoc,
    )

def _create_with_symbols(name, symbols = []):
    """Create a documentation provider using a list of symbols and appropriate defaults.

    Args:
        name: A `string` which identifies the doc output.
        symbols: A `list` of symbol names that should be included
                 in the documentation.

    Returns:
      A `struct` representing a documentation provider.
    """
    return _create(
        name = name,
        header = name + "_header.vm",
        symbols = symbols,
    )

def _create_api(name):
    """Create a documentation provider for an API file/struct.

    Args:
        name: A `string` which identifies the doc output.

    Returns:
      A `struct` representing a documentation provider.
    """
    api_name = name + "_api"
    return _create(name = api_name)

doc_providers = struct(
    create = _create,
    create_with_symbols = _create_with_symbols,
    create_api = _create_api,
)

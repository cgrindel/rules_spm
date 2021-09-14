def _create(
        name,
        doc_label = None,
        out_basename = None,
        doc_basename = None,
        header = None,
        symbols = None,
        is_stardoc = True):
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
    return _create(
        name = name,
        header = name + "_header.vm",
        symbols = symbols,
    )

def _create_api(name):
    api_name = name + "_api"

    # return _create(name = api_name, header = api_name + "_header.vm")
    return _create(name = api_name)

doc_providers = struct(
    create = _create,
    create_with_symbols = _create_with_symbols,
    create_api = _create_api,
)

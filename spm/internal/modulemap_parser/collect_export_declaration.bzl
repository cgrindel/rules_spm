load(":collection_results.bzl", "collection_results")
load(":errors.bzl", "errors")
load(":tokens.bzl", "tokens", rws = "reserved_words", tts = "token_types")
load(":declarations.bzl", "declarations")

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
    tlen = len(parsed_tokens)
    consumed_count = 0
    collect_result = None

    for idx in range(consumed_count, tlen - consumed_count):
        consumed_count += 1

    decl = declarations.export
    return collection_results.new([decl], consumed_count), None

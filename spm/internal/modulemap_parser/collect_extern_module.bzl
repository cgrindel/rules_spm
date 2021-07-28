load(":declarations.bzl", "declarations")
load(":tokens.bzl", "reserved_words", "tokens")
load(":collection_results.bzl", "collection_results")

tts = tokens.types
rws = reserved_words

def collect_extern_module(parsed_tokens):
    """Collect an extern module declaration.

    Spec: https://clang.llvm.org/docs/Modules.html#module-declaration

    Syntax:

    extern module module-id string-literal

    Args:
        parsed_tokens: A `list` of tokens.

    Returns:
        A `tuple` where the first item is the collection result and the second is an
        error `struct` as returned from errors.create().
    """

    tlen = len(parsed_tokens)
    extern_token, err = tokens.get_as(parsed_tokens, 0, tts.reserved, rws.extern, count = tlen)
    if err:
        return None, err

    module_token, err = tokens.get_as(parsed_tokens, 1, tts.reserved, rws.module, count = tlen)
    if err:
        return None, err

    module_id_token, err = tokens.get_as(parsed_tokens, 2, tts.identifier, count = tlen)
    if err:
        return None, err

    path_token, err = tokens.get_as(parsed_tokens, 3, tts.string_literal, count = tlen)
    if err:
        return None, err

    decl = declarations.extern_module(module_id_token.value, path_token.value)
    return collection_results.new([decl], 4), None

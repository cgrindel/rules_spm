"""Defintion for collect_module_attribute."""

load(":collection_results.bzl", "collection_results")
load(":tokens.bzl", "tokens", tts = "token_types")

# MARK: - Attribute Collection

def collect_module_attribute(parsed_tokens):
    """Collect a module attribute.

    Spec: https://clang.llvm.org/docs/Modules.html#attributes

    Syntax:
        attributes:
          attribute attributesopt

        attribute:
          '[' identifier ']'

    Args:
        parsed_tokens: A `list` of tokens.

    Returns:
        A `tuple` where the first item is the collection result and the second is an
        error `struct` as returned from errors.create().
    """
    tlen = len(parsed_tokens)

    _open_token, err = tokens.get_as(parsed_tokens, 0, tts.square_bracket_open, count = tlen)
    if err != None:
        return None, err

    attrib_token, err = tokens.get_as(parsed_tokens, 1, tts.identifier, count = tlen)
    if err != None:
        return None, err

    _open_token, err = tokens.get_as(parsed_tokens, 2, tts.square_bracket_close, count = tlen)
    if err != None:
        return None, err

    return collection_results.new([attrib_token.value], 3), None

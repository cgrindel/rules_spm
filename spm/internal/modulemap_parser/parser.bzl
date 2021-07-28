load(":tokenizer.bzl", "tokenizer")
load(":tokens.bzl", "reserved_words", "tokens")

def _collection_result(declarations, count, errors = []):
    """Creates a collection result `struct`.

    Args:
        declarations: The declarations that were collected.
        count: The number of tokens that were collected.
        errors: A `list` of errors that were found.

    Returns:
        A `struct` representing the data that was collected.
    """
    return struct(
        declarations = declarations,
        count = count,
        errors = errors,
    )

def _parser_result(declarations = [], errors = []):
    return struct(
        declarations = declarations,
        errors = errors,
    )

def _collect_extern_module(parsed_tokens):
    """Collect an extern module declaration.

    Syntax

    extern module module-id string-literal

    Args:
        parsed_tokens: A `list` of tokens.

    Returns:
        A collection result `struct`.
    """
    return _collection_result([], 0)

def _parse(text):
    tokenizer_result = tokenizer.tokenize(text)
    if len(tokenizer_result.errors) > 0:
        return _parser_result(errors = tokenizer_result.errors)

    parsed_tokens = tokenizer_result.tokens
    tokens_cnt = len(parsed_tokens)

    collected_decls = []
    skip_ahead = 0
    prefix_tokens = []
    for idx in range(tokens_cnt):
        if skip_ahead > 0:
            skip_ahead -= 1
            continue

        token = parsed_tokens[idx]
        collect_result = None

        if token.type == tokens.types.newline:
            pass

        elif token.type == tokens.types.reserved:
            if token.value == reserved_words.extern:
                collect_result = _collect_extern_module(parsed_tokens[idx:])

            elif token.value == reserved_words.module:
                # TODO: IMPLEMENT ME!
                pass

            else:
                prefix_tokens.append(token)

        else:
            prefix_tokens.append(token)

        if collect_result:
            collected_decls.extend(collect_result.declarations)
            skip_ahead = collect_result.count - 1

    return _parser_result(collected_decls)

parser = struct(
    parse = _parse,
    result = _parser_result,
)

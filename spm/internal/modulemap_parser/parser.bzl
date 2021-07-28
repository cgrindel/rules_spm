load(":declarations.bzl", "declarations")
load(":errors.bzl", "errors")
load(":tokenizer.bzl", "tokenizer")
load(":tokens.bzl", "reserved_words", "tokens")
load(":collection_results.bzl", "collection_results")

tts = tokens.types
rws = reserved_words

def _parser_result(declarations = []):
    return struct(
        declarations = declarations,
    )

def _collect_extern_module(parsed_tokens):
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

def _parse(text):
    tokenizer_result = tokenizer.tokenize(text)
    if len(tokenizer_result.errors) > 0:
        return None, errors.new("Errors from tokenizer", tokenizer_result.errors)

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
                collect_result, err = _collect_extern_module(parsed_tokens[idx:])
                if err:
                    return None, err

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

    return _parser_result(collected_decls), None

parser = struct(
    parse = _parse,
    result = _parser_result,
)

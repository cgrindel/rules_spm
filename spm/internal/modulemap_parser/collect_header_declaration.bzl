load(":errors.bzl", "errors")
load(":collection_results.bzl", "collection_results")
load(":tokens.bzl", "tokens", rws = "reserved_words", tts = "token_types")
load(":declarations.bzl", "declarations", dts = "declaration_types")

def collect_header_declaration(parsed_tokens, prefix_tokens):
    """Collect a header declaration.

    Spec: https://clang.llvm.org/docs/Modules.html#header-declaration

    Syntax:
        header-declaration:
          privateopt textualopt header string-literal header-attrsopt
          umbrella header string-literal header-attrsopt
          exclude header string-literal header-attrsopt

        header-attrs:
          '{' header-attr* '}'

        header-attr:
          size integer-literal
          mtime integer-literal

    Args:
        parsed_tokens: A `list` of tokens.
        prefix_tokens: A `list` of tokens that have been consumed but not yet processed.

    Returns:
        A `tuple` where the first item is the collection result and the second is an
        error `struct` as returned from errors.create().
    """
    tlen = len(parsed_tokens)

    decl_type = dts.single_header
    private = False
    textual = False

    prefix_tokens_count = len(prefix_tokens)
    if prefix_tokens_count > 0:
        token = prefix_tokens[0]

        # TODO: Create tokens.is_a(...)
        # if tokens.is_a(token, tts.reserved, rws.umbrella):

        if token.type == tts.reserved and token.value == rws.umbrella:
            decl_type = dts.umbrella_header
        elif token.type == tts.reserved and token.value == rws.exclude:
            decl_type = dts.exclude_header
        elif prefix_tokens_count > 1:
            for token in prefix_tokens[1:]:
                if token.type == tts.reserved and token.value == rws.private:
                    private = True
                elif token.type == tts.reserved and token.value == rws.textual:
                    textual = False
                else:
                    return None, errors.new(
                        "Unexpected token processing header declaration prefix tokens. token: %s" %
                        (token),
                    )

    consumed_count = 0

    header_token, err = tokens.get_as(parsed_tokens, 0, tts.reserved, rws.header, count = tlen)
    if err != None:
        return None, err
    consumed_count += 1

    path_token, err = tokens.get_as(parsed_tokens, 1, tts.string_literal, count = tlen)
    if err != None:
        return None, err
    consumed_count += 1

    for idx in range(consumed_count, tlen - consumed_count):
        consumed_count += 1

        # Get next token
        token, err = tokens.get(parsed_tokens, idx, count = tlen)
        if err != None:
            return None, err

    return None, errors.new("IMPLEMEMT ME!")

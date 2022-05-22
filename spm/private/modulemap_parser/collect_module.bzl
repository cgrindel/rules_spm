"""Defintion for collect_module."""

load(":collect_module_members.bzl", "collect_module_members")
load(":collection_results.bzl", "collection_results")
load(":declarations.bzl", "declarations")
load(":errors.bzl", "errors")
load(":tokens.bzl", "tokens", rws = "reserved_words", tts = "token_types")

# MARK: - Attribute Collection

def _collect_attribute(parsed_tokens):
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

# MARK: - Module Collection

def collect_module(parsed_tokens, is_submodule = False, prefix_tokens = []):
    """Collect a module declaration.

    Spec: https://clang.llvm.org/docs/Modules.html#module-declaration

    Syntax:
        explicitopt frameworkopt module module-id attributesopt '{' module-member* '}'

    Args:
        parsed_tokens: A `list` of tokens.
        is_submodule: A `bool` that designates whether the module is a child of another module.
        prefix_tokens: A `list` of tokens that have already been collected, but not applied.

    Returns:
        A `tuple` where the first item is the collection result and the second is an
        error `struct` as returned from errors.create().
    """
    explicit = False
    framework = False
    attributes = []
    members = []
    consumed_count = 0

    tlen = len(parsed_tokens)

    # Process the prefix tokens
    for token in prefix_tokens:
        if token.type == tts.reserved and token.value == rws.explicit:
            if not is_submodule:
                return None, errors.new("The explicit qualifier can only exist on submodules.")
            explicit = True

        elif token.type == tts.reserved and token.value == rws.framework:
            framework = True

        else:
            return None, errors.new(
                "Unexpected prefix token collecting module declaration. token: %s" % (token),
            )

    _module_token, err = tokens.get_as(parsed_tokens, 0, tts.reserved, rws.module, count = tlen)
    if err != None:
        return None, err
    consumed_count += 1

    module_id_token, err = tokens.get_as(parsed_tokens, 1, tts.identifier, count = tlen)
    if err != None:
        return None, err
    consumed_count += 1

    # Collect the attributes and module members
    skip_ahead = 0
    collect_result = None
    for idx in range(consumed_count, tlen - consumed_count):
        consumed_count += 1
        if skip_ahead > 0:
            skip_ahead -= 1
            continue

        collect_result = None
        err = None

        # Get next token
        token, err = tokens.get(parsed_tokens, idx, count = tlen)
        if err != None:
            return None, err

        # Process the token
        if tokens.is_a(token, tts.curly_bracket_open):
            collect_result, err = collect_module_members(parsed_tokens[idx:])
            if err != None:
                return None, err
            members.extend(collect_result.declarations)
            consumed_count += collect_result.count - 1
            break

        elif tokens.is_a(token, tts.square_bracket_open):
            collect_result, err = _collect_attribute(parsed_tokens[idx:])
            if err != None:
                return None, err
            attributes.extend(collect_result.declarations)

        else:
            return None, errors.new(
                "Unexpected token collecting attributes and module members. token: %s" % (token),
            )

        # Handle index advancement.
        if collect_result:
            skip_ahead = collect_result.count - 1

    # Create the declaration
    decl = declarations.module(
        module_id = module_id_token.value,
        explicit = explicit,
        framework = framework,
        attributes = attributes,
        members = members,
    )
    return collection_results.new([decl], consumed_count), None

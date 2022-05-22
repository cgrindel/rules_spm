"""Defintion for collect_submodule."""

load(":collect_module_attribute.bzl", "collect_module_attribute")
load(":collect_submodule_members.bzl", "collect_submodule_members")
load(":collection_results.bzl", "collection_results")
load(":declarations.bzl", "declarations")
load(":errors.bzl", "errors")
load(":tokens.bzl", "tokens", ops = "operators", rws = "reserved_words", tts = "token_types")

# MARK: - Module Collection

def collect_submodule(parsed_tokens, prefix_tokens = [], umbrella_decl = None):
    """Collect a submodule declaration.

    Spec: https://clang.llvm.org/docs/Modules.html#submodule-declaration

    Syntax:
        explicitopt frameworkopt module module-id attributesopt '{' module-member* '}'

    Args:
        parsed_tokens: A `list` of tokens.
        prefix_tokens: A `list` of tokens that have already been collected, but not applied.
        umbrella_decl: A `declaration` of type `umbrella`, in the case of an inferred declaration.

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
    if err == None:
        module_id = module_id_token.value
    else:
        if umbrella_decl == None:
            return None, err

        # A submodule without its next token as an identifier may be an inferred submodule.
        # Such a submodule gets its members from the umbrella declaration provided in the
        # parent module's members.
        _, i_err = tokens.get_as(parsed_tokens, 1, tts.operator, ops.asterisk, count = tlen)
        if i_err != None:
            return None, i_err
        module_id = umbrella_decl.path

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
            collect_result, err = collect_submodule_members(parsed_tokens[idx:])
            if err != None:
                return None, err
            members.extend(collect_result.declarations)
            consumed_count += collect_result.count - 1
            break

        elif tokens.is_a(token, tts.square_bracket_open):
            collect_result, err = collect_module_attribute(parsed_tokens[idx:])
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
        module_id = module_id,
        explicit = explicit,
        framework = framework,
        attributes = attributes,
        members = members,
    )
    return collection_results.new([decl], consumed_count), None

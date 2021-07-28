load(":errors.bzl", "errors")
load("@bazel_skylib//lib:partial.bzl", "partial")
load("@bazel_skylib//lib:sets.bzl", "sets")
load("@bazel_skylib//lib:structs.bzl", "structs")
load("@bazel_skylib//lib:types.bzl", "types")

# MARK: - Token Creation Functions

def _is_valid_value(value_type_or_set, value):
    """Returns a boolean indicating whether the specified value is valid for the specified value 
    type.

    Args:
        value_type_or_set: If this is a string, then it is considered to be a string type as returned
                           by type(). Otherwise, it is a set as returned by sets.make() which contains
                           the acceptable values.
        value: The value being evaluated.

    Returns:
        True if the value is valid. Otherwise, false.
    """
    if types.is_string(value_type_or_set):
        return type(value) == value_type_or_set
    return sets.contains(value_type_or_set, value)

def _create_token_type(name, value_type_or_set = type(None)):
    """Creates a token type struct.

    Args:
        name: The name of the type.
        value_type_or_set: The type name or set of acceptable values.

    Returns:
        A `struct` representing the token type.
    """
    return struct(
        name = name,
        value_type = value_type_or_set,
        is_valid_value_fn = partial.make(_is_valid_value, value_type_or_set),
    )

def _create(token_type_or_name, value = None):
    """Create a token of the specified type.

    Args:
        token_type_or_name: The token type or the name of the token type.
        value: Optional. The value associated with the token.

    Returns:
        A `struct` representing the token.
    """
    if types.is_string(token_type_or_name):
        token_type = _token_types_dict[token_type_or_name]
    else:
        token_type = token_type_or_name

    if not partial.call(token_type.is_valid_value_fn, value):
        fail("Invalid value for token type", token_type.name, value)

    return struct(
        type = token_type,
        value = value,
    )

# MARK: - Reserved Words

# _reserved_words = [
#     "config_macros",
#     "conflict",
#     "exclude",
#     "explicit",
#     "export",
#     "export_as",
#     "extern",
#     "framework",
#     "header",
#     "link",
#     "module",
#     "private",
#     "requires",
#     "textual",
#     "umbrella",
#     "use",
# ]
# RESERVED_WORDS = sets.make(_reserved_words)

_reserved_words = struct(
    config_macros = "config_macros",
    conflict = "conflict",
    exclude = "exclude",
    explicit = "explicit",
    export = "export",
    export_as = "export_as",
    extern = "extern",
    framework = "framework",
    header = "header",
    link = "link",
    module = "module",
    private = "private",
    requires = "requires",
    textual = "textual",
    umbrella = "umbrella",
    use = "use",
)
_reserved_words_dict = structs.to_dict(_reserved_words)
RESERVED_WORDS = sets.make([_reserved_words_dict[k] for k in _reserved_words_dict])

# MARK: - Operators

# NOTE: This is meant to be a set of the operators not a set of the operator characters.
# For instance, operator characters could be ["*", "=", "+"] while the list of operators
# could be ["*", "+", "+=", "="].
OPERATORS = sets.make(["*"])

# MARK: - Token Types

_token_types = struct(
    reserved = _create_token_type("reserved", RESERVED_WORDS),
    identifier = _create_token_type("identifier", "string"),
    string_literal = _create_token_type("string_literal", "string"),
    integer_literal = _create_token_type("integer_literal", "int"),
    float_literal = _create_token_type("float_literal", "float"),
    comment = _create_token_type("comment", "string"),
    operator = _create_token_type("operator", OPERATORS),
    curly_bracket_open = _create_token_type("curly_bracket_open"),
    curly_bracket_close = _create_token_type("curly_bracket_close"),
    newline = _create_token_type("newline"),
    square_bracket_open = _create_token_type("square_bracket_open"),
    square_bracket_close = _create_token_type("square_bracket_close"),
    exclamation_point = _create_token_type("exclamation_point"),
    comma = _create_token_type("comma"),
    period = _create_token_type("period"),
)

_token_types_dict = structs.to_dict(_token_types)

def _create_reserved(value):
    return _create(_token_types.reserved, value)

def _create_identifier(value):
    return _create(_token_types.identifier, value)

def _create_string_literal(value):
    return _create(_token_types.string_literal, value)

def _create_integer_literal(value):
    return _create(_token_types.integer_literal, value)

def _create_float_literal(value):
    return _create(_token_types.float_literal, value)

def _create_comment(value):
    return _create(_token_types.comment, value)

def _create_operator(value):
    return _create(_token_types.operator, value)

def _create_curly_bracket_open():
    return _create(_token_types.curly_bracket_open)

def _create_curly_bracket_close():
    return _create(_token_types.curly_bracket_close)

def _create_newline():
    return _create(_token_types.newline)

def _create_square_bracket_open():
    return _create(_token_types.square_bracket_open)

def _create_square_bracket_close():
    return _create(_token_types.square_bracket_close)

def _create_exclamation_point():
    return _create(_token_types.exclamation_point)

def _create_comma():
    return _create(_token_types.comma)

def _create_period():
    return _create(_token_types.period)

# MARK: - Token List Functions

def _next_token(tokens, idx, tokens_len = None):
    """Returns the next token in the list.

    Args:
        tokens: A `list` of tokens.
        idx: The current index.
        tokens_len: Optional. The number of tokens in the list.

    Returns:
        A `tuple` where the first item is the next token and the second item is an error, if any
        occurred.
    """
    if not tokens_len:
        tokens_len = len(tokens)
    next_idx = idx + 1
    if next_idx >= tokens_len:
        return None, errors.new("No more tokens available.")
    return tokens[next_idx], None

# MARK: - Tokens Namespace

tokens = struct(
    # Token Types
    types = _token_types,

    # Specialty sets
    reserved_words = RESERVED_WORDS,

    # Token Factories
    reserved = _create_reserved,
    identifier = _create_identifier,
    string_literal = _create_string_literal,
    integer_literal = _create_integer_literal,
    float_literal = _create_float_literal,
    comment = _create_comment,
    operator = _create_operator,
    curly_bracket_open = _create_curly_bracket_open,
    curly_bracket_close = _create_curly_bracket_close,
    newline = _create_newline,
    square_bracket_open = _create_square_bracket_open,
    square_bracket_close = _create_square_bracket_close,
    exclamation_point = _create_exclamation_point,
    comma = _create_comma,
    period = _create_period,

    # Token List Functions
    next = _next_token,
)

reserved_words = _reserved_words

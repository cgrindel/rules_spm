load("@bazel_skylib//lib:partial.bzl", "partial")
load("@bazel_skylib//lib:sets.bzl", "sets")
load("@bazel_skylib//lib:structs.bzl", "structs")
load("@bazel_skylib//lib:types.bzl", "types")

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

def _create_token_type(name, value_type_or_set = "none"):
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

RESERVED_WORDS = sets.make([
    "config_macros",
    "conflict",
    "exclude",
    "explicit",
    "export",
    "export_as",
    "extern",
    "framework",
    "header",
    "link",
    "module",
    "private",
    "requires",
    "textual",
    "umbrella",
    "use",
])

OPERATORS = sets.make(["*"])

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
    newLine = _create_token_type("newLine"),
    square_bracket_open = _create_token_type("square_bracket_open"),
    square_bracket_close = _create_token_type("square_bracket_close"),
    exclamation_point = _create_token_type("exclamation_point"),
    comma = _create_token_type("comma"),
    period = _create_token_type("period"),
)

_token_types_dict = structs.to_dict(_token_types)

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

tokens = struct(
    types = _token_types,
    create = _create,
)

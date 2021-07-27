load("@bazel_skylib//lib:partial.bzl", "partial")
load("@bazel_skylib//lib:sets.bzl", "sets")
load("@bazel_skylib//lib:structs.bzl", "structs")
load("@bazel_skylib//lib:types.bzl", "types")

# TOKEN_TYPE_NAMES = sets.make([
#     "reserved",
#     "identifier",
#     "string_literal",
#     "integer_literal",
#     "float_literal",
#     "comment",
#     "curly_bracket_open",
#     "curly_bracket_close",
#     "operator",
#     "newLine",
#     "square_bracket_open",
#     "square_bracket_close",
#     "exclamation_point",
#     "comma",
#     "period",
# ])

# def _create_token_type(name, hasValue = False):
#     return struct(
#         name = name,
#         hasValue = hasValue,
#     )

def _is_valid_value(value_type, value):
    # If the value_type is an actual string, do a type comparison.
    # Otherwise, the value_type is a set and we should check if the value is in the set.
    if types.is_string(value_type):
        return type(value) == value_type
    return sets.contains(value_type, value)

def _create_token_type(name, value_type = "none"):
    return struct(
        name = name,
        value_type = value_type,
        is_valid_value_fn = partial.make(_is_valid_value, value_type),
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

token_types = struct(
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

_token_types_dict = structs.to_dict(token_types)

def create_token(token_type_or_name, value = None):
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

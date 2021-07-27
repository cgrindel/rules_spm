load("@bazel_skylib//lib:sets.bzl", "sets")

_whitespaces = sets.make([
    " ",  # space
    "\t",  # horizontal tab
    # "\\v",  # vertical tab
    # "\\b",  # backspace
])

_newlines = sets.make([
    "\n",  # line feed
    "\r",  # carriage return
    # "\\f",  # form feed
])

_operators = sets.make(["*"])

character_sets = struct(
    whitespaces = _whitespaces,
    newlines = _newlines,
    operators = _operators,
)

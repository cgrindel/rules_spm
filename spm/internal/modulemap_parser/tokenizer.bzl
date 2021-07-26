load("@bazel_skylib//lib:sets.bzl", "sets")

TOKEN_TYPES = sets.make([
    "foo",
])

def create_token(type, value):
    return struct(
        type = type,
        value = value,
    )

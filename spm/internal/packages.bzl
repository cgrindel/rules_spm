load("@bazel_skylib//lib:paths.bzl", "paths")

def _create_name(url):
    basename = paths.basename(url)
    repo_name, ext = paths.split_extension(basename)
    git_user = paths.basename(paths.dirname(url))
    raw_name = "%s_%s" % (git_user, repo_name)
    return raw_name.replace("-", "_")

packages = struct(
    create_name = _create_name,
)

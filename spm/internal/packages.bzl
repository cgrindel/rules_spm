load("@bazel_skylib//lib:paths.bzl", "paths")

def _create_name(url):
    basename = paths.basename(url)
    repo_name, ext = paths.split_extension(basename)
    git_user = paths.basename(paths.dirname(url))
    raw_name = "%s_%s" % (git_user, repo_name)
    return raw_name.replace("-", "_")

def _create_pkg(url, name = None, from_version = None):
    if name == None:
        name = packages.create_name(url)

    return struct(
        url = url,
        name = name,
        from_version = from_version,
    )

def _to_json(url, name = None, from_version = None):
    pkg = packages.create(url, name = name, from_version = from_version)
    return json.encode(pkg)

def _from_json(json_str):
    pkg_dict = json.decode(json_str)
    return _create_pkg(**pkg_dict)

packages = struct(
    create_name = _create_name,
    create = _create_pkg,
    pkg_json = _to_json,
    from_json = _from_json,
)

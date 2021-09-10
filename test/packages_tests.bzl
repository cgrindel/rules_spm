load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal:packages.bzl", "packages")
load("//spm/internal:references.bzl", "reference_types", "references")

def _create_name_test(ctx):
    env = unittest.begin(ctx)

    asserts.equals(env, "bar-kit", packages.create_name("https://github.com/foo/bar-kit.git"))
    asserts.equals(env, "bar", packages.create_name("https://github.com/foo/bar.git"))

    return unittest.end(env)

create_name_test = unittest.make(_create_name_test)

def _create_test(ctx):
    env = unittest.begin(ctx)

    url = "https://github.com/foo/bar.git"
    path = "/path/to/foo/bar"
    from_version = "1.0.0"
    products = ["Foo", "Bar"]

    actual = packages.create(url = url, from_version = from_version, products = products)
    expected = struct(
        url = url,
        path = None,
        name = packages.create_name(url),
        from_version = from_version,
        revision = None,
        products = products,
    )
    asserts.equals(env, expected, actual)

    actual = packages.create(path = path, from_version = from_version, products = products)
    expected = struct(
        url = None,
        path = path,
        name = packages.create_name(path),
        from_version = from_version,
        revision = None,
        products = products,
    )
    asserts.equals(env, expected, actual)

    name = "howdy-bob"
    actual = packages.create(
        url = url,
        name = name,
        from_version = from_version,
        products = products,
    )
    expected = struct(
        url = url,
        path = None,
        name = name,
        from_version = from_version,
        revision = None,
        products = products,
    )
    asserts.equals(env, expected, actual)

    name = "howdy-bob"
    revision = "db8fccb22cc2d801db74cf93bea88697b13fbeb0"
    actual = packages.create(
        url,
        name = name,
        revision = revision,
        products = products,
    )
    expected = struct(
        url = url,
        path = None,
        name = name,
        from_version = None,
        revision = revision,
        products = products,
    )
    asserts.equals(env, expected, actual)

    return unittest.end(env)

create_test = unittest.make(_create_test)

def _copy_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

copy_test = unittest.make(_copy_test)

def _json_roundtrip_test(ctx):
    env = unittest.begin(ctx)

    json_str = packages.pkg_json("https://github.com/foo/bar-kit.git", from_version = "1.0.0", products = ["Foo"])
    actual = packages.from_json(json_str)
    expected = packages.create("https://github.com/foo/bar-kit.git", from_version = "1.0.0", products = ["Foo"])
    asserts.equals(env, expected, actual)

    revision = "db8fccb22cc2d801db74cf93bea88697b13fbeb0"
    json_str = packages.pkg_json("https://github.com/foo/bar-kit.git", revision = revision, products = ["Foo"])
    actual = packages.from_json(json_str)
    expected = packages.create("https://github.com/foo/bar-kit.git", revision = revision, products = ["Foo"])
    asserts.equals(env, expected, actual)

    pkgs = [
        packages.create("https://github.com/foo/bar-kit.git", from_version = "1.0.0", products = ["Foo"]),
        packages.create("https://github.com/foo/foo-kit.git", from_version = "1.0.0", products = ["Foo"]),
    ]
    json_str = json.encode(pkgs)
    result = packages.from_json(json_str)
    asserts.equals(env, pkgs, result)

    return unittest.end(env)

json_roundtrip_test = unittest.make(_json_roundtrip_test)

def _get_pkg_test(ctx):
    env = unittest.begin(ctx)

    pkgs = [
        packages.create("https://github.com/foo/bar-kit.git", from_version = "1.0.0", products = ["Foo"]),
        packages.create("https://github.com/foo/foo-kit.git", from_version = "1.0.0", products = ["Bar"]),
    ]
    pkg = packages.get_pkg(pkgs, "foo-kit")
    asserts.equals(env, pkgs[1], pkg)
    pkg = packages.get_pkg(pkgs, "does-not-exist")
    asserts.equals(env, None, pkg)

    return unittest.end(env)

get_pkg_test = unittest.make(_get_pkg_test)

def _get_product_refs_test(ctx):
    env = unittest.begin(ctx)

    pkgs = [
        packages.create("https://github.com/foo/bar-kit.git", from_version = "1.0.0", products = ["Bar"]),
        packages.create("https://github.com/foo/foo-kit.git", from_version = "1.0.0", products = ["Foo"]),
    ]
    actual = packages.get_product_refs(pkgs)
    expected = [
        references.create(reference_types.product, "bar-kit", "Bar"),
        references.create(reference_types.product, "foo-kit", "Foo"),
    ]
    asserts.equals(env, expected, actual)

    return unittest.end(env)

get_product_refs_test = unittest.make(_get_product_refs_test)

def packages_test_suite():
    return unittest.suite(
        "packages_tests",
        create_name_test,
        create_test,
        copy_test,
        json_roundtrip_test,
        get_pkg_test,
        get_product_refs_test,
    )

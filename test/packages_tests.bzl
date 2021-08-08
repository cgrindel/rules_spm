load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal:packages.bzl", "packages")

def _create_name_test(ctx):
    env = unittest.begin(ctx)

    asserts.equals(env, "bar-kit", packages.create_name("https://github.com/foo/bar-kit.git"))
    asserts.equals(env, "bar", packages.create_name("https://github.com/foo/bar.git"))

    return unittest.end(env)

create_name_test = unittest.make(_create_name_test)

def _create_test(ctx):
    env = unittest.begin(ctx)

    url = "https://github.com/foo/bar.git"
    from_version = "1.0.0"

    actual = packages.create(url, from_version = from_version, products = ["Foo", "Bar"])
    expected = struct(
        url = url,
        name = packages.create_name(url),
        from_version = from_version,
        products = ["Foo", "Bar"],
    )
    asserts.equals(env, expected, actual)

    name = "howdy-bob"
    actual = packages.create(
        url,
        name = name,
        from_version = from_version,
        products = ["Foo", "Bar"],
    )
    expected = struct(
        url = url,
        name = name,
        from_version = from_version,
        products = ["Foo", "Bar"],
    )
    asserts.equals(env, expected, actual)

    return unittest.end(env)

create_test = unittest.make(_create_test)

def _json_roundtrip_test(ctx):
    env = unittest.begin(ctx)

    json_str = packages.pkg_json("https://github.com/foo/bar-kit.git", from_version = "1.0.0", products = ["Foo"])
    actual = packages.from_json(json_str)
    expected = packages.create("https://github.com/foo/bar-kit.git", from_version = "1.0.0", products = ["Foo"])
    asserts.equals(env, expected, actual)

    unittest.fail(env, "Add test consuming JSON string array.")

    return unittest.end(env)

json_roundtrip_test = unittest.make(_json_roundtrip_test)

def packages_test_suite():
    return unittest.suite(
        "packages_tests",
        create_name_test,
        create_test,
        json_roundtrip_test,
    )

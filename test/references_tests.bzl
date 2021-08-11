load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal:references.bzl", "reference_types", "references")

def _create_test(ctx):
    env = unittest.begin(ctx)

    actual = references.create(reference_types.target, "foo-kit", "FooKit")
    asserts.equals(env, "target:foo-kit/FooKit", actual)

    return unittest.end(env)

create_test = unittest.make(_create_test)

def _split_test(ctx):
    env = unittest.begin(ctx)

    ref_type, pkg_name, name = references.split("target:foo-kit/FooKit")
    asserts.equals(env, reference_types.target, ref_type)
    asserts.equals(env, "foo-kit", pkg_name)
    asserts.equals(env, "FooKit", name)

    return unittest.end(env)

split_test = unittest.make(_split_test)

def _create_target_ref_test(ctx):
    env = unittest.begin(ctx)

    actual = references.create_target_ref("foo-kit", ["FooKit", None])
    expected = references.create(reference_types.target, "foo-kit", "FooKit")
    asserts.equals(env, expected, actual)

    return unittest.end(env)

create_target_ref_test = unittest.make(_create_target_ref_test)

def _create_product_ref_test(ctx):
    env = unittest.begin(ctx)

    actual = references.create_product_ref(["FooKit", "foo-kit", None])
    expected = references.create(reference_types.product, "foo-kit", "FooKit")
    asserts.equals(env, expected, actual)

    return unittest.end(env)

create_product_ref_test = unittest.make(_create_product_ref_test)

def _is_target_ref_test(ctx):
    env = unittest.begin(ctx)

    ref = references.create(reference_types.target, "foo-kit", "FooKit")
    asserts.true(env, references.is_target_ref(ref))

    ref = references.create(reference_types.product, "foo-kit", "FooKit")
    asserts.false(env, references.is_target_ref(ref))

    ref = references.create(reference_types.target, "foo-kit", "FooKit")
    asserts.true(env, references.is_target_ref(ref, for_pkg = "foo-kit"))

    ref = references.create(reference_types.target, "foo-kit", "FooKit")
    asserts.false(env, references.is_target_ref(ref, for_pkg = "bar-kit"))

    ref = references.create(reference_types.target, "foo-kit-not", "FooKit")
    asserts.false(env, references.is_target_ref(ref, for_pkg = "foo-kit"))

    return unittest.end(env)

is_target_ref_test = unittest.make(_is_target_ref_test)

def references_test_suite():
    return unittest.suite(
        "references_tests",
        create_test,
        split_test,
        create_product_ref_test,
        create_target_ref_test,
        is_target_ref_test,
    )

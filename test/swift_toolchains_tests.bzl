"""Tests for swift_toolchains module."""

load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm:defs.bzl", "swift_toolchains")

def _sdk_name_test(ctx):
    env = unittest.begin(ctx)

    platform = apple_common.platform.ios_simulator
    actual = swift_toolchains.sdk_name(platform)
    asserts.equals(env, "iphonesimulator", actual)

    return unittest.end(env)

sdk_name_test = unittest.make(_sdk_name_test)

def _os_name_test(ctx):
    env = unittest.begin(ctx)

    platform = apple_common.platform.ios_device
    asserts.equals(env, "ios", swift_toolchains.os_name(platform))

    platform = apple_common.platform.macos
    asserts.equals(env, "macosx", swift_toolchains.os_name(platform))

    return unittest.end(env)

os_name_test = unittest.make(_os_name_test)

def _target_triple_test(ctx):
    env = unittest.begin(ctx)

    asserts.equals(
        env,
        "x86_64-unknown-linux-gnu",
        swift_toolchains.target_triple("x86_64", "unknown", "linux", abi = "gnu"),
    )

    asserts.equals(
        env,
        "x86_64-unknown-linux",
        swift_toolchains.target_triple("x86_64", "unknown", "linux"),
    )

    return unittest.end(env)

target_triple_test = unittest.make(_target_triple_test)

def _apple_target_triple_test(ctx):
    env = unittest.begin(ctx)

    asserts.equals(
        env,
        "arm64-apple-macosx11.3",
        swift_toolchains.apple_target_triple("arm64", apple_common.platform.macos, "11.3"),
    )

    asserts.equals(
        env,
        "x86_64-apple-ios14.0-simulator",
        swift_toolchains.apple_target_triple("x86_64", apple_common.platform.ios_simulator, "14.0"),
    )

    return unittest.end(env)

apple_target_triple_test = unittest.make(_apple_target_triple_test)

def swift_toolchains_test_suite():
    return unittest.suite(
        "swift_toolchains_tests",
        sdk_name_test,
        os_name_test,
        target_triple_test,
        apple_target_triple_test,
    )

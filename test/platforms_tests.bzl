"""Tests for platforms module."""

load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load(
    "//spm:defs.bzl",
    "platforms",
    "spm_oss",
    "spm_vendors",
    "swift_archs",
)

def _spm_os_test(ctx):
    env = unittest.begin(ctx)

    asserts.equals(env, spm_oss.macos, platforms.spm_os(spm_oss.macos))

    return unittest.end(env)

spm_os_test = unittest.make(_spm_os_test)

def _spm_arch_test(ctx):
    env = unittest.begin(ctx)

    asserts.equals(env, swift_archs.arm64, platforms.spm_arch(swift_archs.arm64))

    return unittest.end(env)

spm_arch_test = unittest.make(_spm_arch_test)

def _spm_vendor_test(ctx):
    env = unittest.begin(ctx)

    asserts.equals(env, spm_vendors.apple, platforms.spm_vendor(spm_oss.macos))

    return unittest.end(env)

spm_vendor_test = unittest.make(_spm_vendor_test)

def platforms_test_suite():
    return unittest.suite(
        "platforms_tests",
        spm_os_test,
        spm_arch_test,
        spm_vendor_test,
    )

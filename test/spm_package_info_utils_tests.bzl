load("//spm/internal:spm_package_info_utils.bzl", "spm_package_info_utils")
load("//spm/internal:providers.bzl", "SPMPackageInfo", "providers")
load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

def _get_test(ctx):
    env = unittest.begin(ctx)

    pkg_infos = [
        SPMPackageInfo(
            name = "hello",
            swift_modules = [],
            clang_modules = [],
            system_library_modules = [],
        ),
        SPMPackageInfo(
            name = "goodbye",
            swift_modules = [],
            clang_modules = [],
            system_library_modules = [],
        ),
    ]
    result = spm_package_info_utils.get(pkg_infos, "goodbye")
    asserts.equals(env, "goodbye", result.name)
    result = spm_package_info_utils.get(pkg_infos, "hello")
    asserts.equals(env, "hello", result.name)

    return unittest.end(env)

get_test = unittest.make(_get_test)

def _get_module_info_test(ctx):
    env = unittest.begin(ctx)

    pkg_info = SPMPackageInfo(
        name = "hello",
        swift_modules = [
            providers.swift_module("MySwift"),
            providers.swift_module("NotMySwift"),
        ],
        clang_modules = [
            providers.clang_module("MyClang"),
            providers.clang_module("NotMyClang"),
        ],
        system_library_modules = [
            providers.system_library_module("MySystem"),
            providers.system_library_module("NotMySystem"),
        ],
    )

    result = spm_package_info_utils.get_module_info(pkg_info, "MySwift")
    asserts.equals(env, "MySwift", result.module_name)

    result = spm_package_info_utils.get_module_info(pkg_info, "MyClang")
    asserts.equals(env, "MyClang", result.module_name)

    result = spm_package_info_utils.get_module_info(pkg_info, "MySystem")
    asserts.equals(env, "MySystem", result.module_name)

    return unittest.end(env)

get_module_info_test = unittest.make(_get_module_info_test)

def spm_package_info_utils_test_suite():
    return unittest.suite(
        "spm_package_info_utils_tests",
        get_test,
        get_module_info_test,
    )

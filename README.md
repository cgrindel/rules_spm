# Swift Package Manager Rules for Bazel

![build status](https://github.com/cgrindel/rules_spm/actions/workflows/bazel.yml/badge.svg)

This repository contains rules for [Bazel](https://bazel.build/) that can be used to download, build
and consume Swift packages with [rules_swift](https://github.com/bazelbuild/rules_swift) rules.  The
rules in this repository build the external Swift packages with [Swift Package
Manager](https://swift.org/package-manager/), then make the outputs available to Bazel rules using
[objc_library](https://docs.bazel.build/versions/main/be/objective-c.html#objc_library) and
[swift_import](https://github.com/bazelbuild/rules_swift/blob/master/doc/rules.md#swift_import).


## Quick Start

The following provides a quick introduction on how to use the rules in this repository. Also, check
out the [examples directory](examples/) for more information.


### 1. Configure your workspace to use `rules_spm`

Add the following to your `WORKSPACE` file to add this repository and its dependencies.

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "cgrindel_rules_spm",
    sha256 = "cc7d756e672d6e48611d2e6681f5e49a9b983f84c4f8ef455df6ab6fd2ea1f9b",
    urls = ["https://github.com/cgrindel/rules_spm/archive/v0.1.0-alpha.tar.gz"],
)

load(
    "@cgrindel_rules_spm//spm:repositories.bzl",
    "rules_spm_dependencies",
)

rules_spm_dependencies()

load(
    "@build_bazel_rules_swift//swift:repositories.bzl",
    "swift_rules_dependencies",
)

swift_rules_dependencies()

load(
    "@build_bazel_rules_swift//swift:extras.bzl",
    "swift_rules_extra_dependencies",
)

swift_rules_extra_dependencies()
```

NOTE: This repository uses [rules_swift](https://github.com/bazelbuild/rules_swift) under the
covers. If you prefer to download a different version of the rules, then download the desired
version and initialize it before initializing this repository. The following shows an example.

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Load custom version of rules_swift.
http_archive(
    name = "build_bazel_rules_swift",
    sha256 = "f872c0388808c3f8de67e0c6d39b0beac4a65d7e07eff3ced123d0b102046fb6",
    url = "https://github.com/bazelbuild/rules_swift/releases/download/0.23.0/rules_swift.0.23.0.tar.gz",
)

load(
    "@build_bazel_rules_swift//swift:repositories.bzl",
    "swift_rules_dependencies",
)

swift_rules_dependencies()

load(
    "@build_bazel_rules_swift//swift:extras.bzl",
    "swift_rules_extra_dependencies",
)

swift_rules_extra_dependencies()

# Download this repository 
http_archive(
    name = "cgrindel_rules_spm",
    sha256 = "cc7d756e672d6e48611d2e6681f5e49a9b983f84c4f8ef455df6ab6fd2ea1f9b",
    urls = ["https://github.com/cgrindel/rules_spm/archive/v0.1.0-alpha.tar.gz"],
)

load(
    "@cgrindel_rules_spm//spm:repositories.bzl",
    "rules_spm_dependencies",
)

rules_spm_dependencies()
```

### 2. Add external Swift packages as dependencies to your workspace

Add the following to download and build [apple/swift-log](https://github.com/apple/swift-log) to
your workspace. NOTE: It is imperative that the products that will be used by your product are 
listed in the `products` list.

```python
load("@cgrindel_rules_spm//spm:spm.bzl", "spm_pkg", "spm_repositories")

spm_repositories(
    name = "swift_pkgs",
    dependencies = [
        spm_pkg(
            "https://github.com/apple/swift-log.git",
            from_version = "1.0.0",
            products = ["Logging"],
        ),
    ],
)
```

### 3. Use the module(s) defined in the Swift packages

Each Swift package can contain multiple Swift modules. A Bazel target is created for each Swift
module.

The following shows a Bazel BUILD file with a `swift_binary` that depends upon the `Logging` module
defined in [apple/swift-log](https://github.com/apple/swift-log).

```python
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_binary")

swift_binary(
    name = "simple",
    srcs = ["main.swift"],
    visibility = ["//swift:__subpackages__"],
    deps = [
        "@swift_pkgs//swift-log:Logging",
    ],
)
```

Lastly, import the Swift module and enjoy!

```python
import Logging

let logger = Logger(label: "com.example.main")
logger.info("Hello World!")
```

## Future Work

- [Ensure that toolchains are being leveraged properly.](https://github.com/cgrindel/rules_spm/issues/4)
- [Build the correct architecture in SPM](https://github.com/cgrindel/rules_spm/issues/5)
- [Ensure that the rules work on Linux](https://github.com/cgrindel/rules_spm/issues/24)
- [Properly handle clang modules with custom module.modulemap files](https://github.com/cgrindel/rules_spm/issues/19)


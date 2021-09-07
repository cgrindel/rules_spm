# Swift Package Manager Rules for Bazel

[![Build](https://github.com/cgrindel/rules_spm/actions/workflows/bazel.yml/badge.svg)](https://github.com/cgrindel/rules_spm/actions/workflows/bazel.yml)

This repository contains rules for [Bazel](https://bazel.build/) that can be used to download, build
and consume Swift packages with [rules_swift](https://github.com/bazelbuild/rules_swift) rules.  The
rules in this repository build the external Swift packages with [Swift Package
Manager](https://swift.org/package-manager/), then make the outputs available to Bazel rules.


## Prerequisites

### Mac OS

Be sure to install Xcode.

### Linux

You will need to [install Swift](https://swift.org/getting-started/#installing-swift). Make sure
that running `swift --version` works properly.

Don't forget that `rules_swift` [expects the use of
`clang`](https://github.com/bazelbuild/rules_swift#3-additional-configuration-linux-only). Hence,
you will need to specify `CC=clang` before running Bazel.

In addition, the Bazel toolchains want to use the [Gold
linker](https://en.wikipedia.org/wiki/Gold_(linker)). While it may be installed on the system, it is
possible that it will not be findable when using `clang` as mentioned previously. So, you may need
to create a symlink to the linker in the `clang` directory.

```sh
sudo ln -s $(which ld.gold) $(dirname $(which clang))
```


## Quick Start

The following provides a quick introduction on how to use the rules in this repository. Also, check
out the [examples directory](examples/) for more information.


### 1. Configure your workspace to use `rules_spm`

Add the following to your `WORKSPACE` file to add this repository and its dependencies.

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "cgrindel_rules_spm",
    sha256 = "ba24597390eba246b6125897ae4917f9be0bdfcf5c5273b9d5ad6ce75a57c791",
    strip_prefix = "rules_spm-0.3.0-alpha",
    urls = ["https://github.com/cgrindel/rules_spm/archive/v0.3.0-alpha.tar.gz"],
)

load(
    "@cgrindel_rules_spm//spm:deps.bzl",
    "spm_rules_dependencies",
)

spm_rules_dependencies()

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

### 2. Add external Swift packages as dependencies to your workspace

Add the following to download and build [apple/swift-log](https://github.com/apple/swift-log) to
your workspace. NOTE: It is imperative that the products that will be used by your project are 
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
module which is exported by the products that were listed in the `spm_pkg` declaration.

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


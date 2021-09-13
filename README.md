# Swift Package Manager Rules for Bazel

[![Build](https://github.com/cgrindel/rules_spm/actions/workflows/bazel.yml/badge.svg)](https://github.com/cgrindel/rules_spm/actions/workflows/bazel.yml)

This repository contains rules for [Bazel](https://bazel.build/) that can be used to download, build
and consume Swift packages with [rules_swift](https://github.com/bazelbuild/rules_swift) rules.  The
rules in this repository build the external Swift packages with [Swift Package
Manager](https://swift.org/package-manager/), then make the outputs available to Bazel rules.


## Reference Documentation

[Click here](doc/) for the reference documentation for the rules and other definitions in this repository.

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
possible that it will not be findable when using `clang` as mentioned previously. So, you will want
to do one of the following:

#### Option #1: Create a symlink to the linker in the `clang` directory.

```sh
sudo ln -s $(which ld.gold) $(dirname $(which clang))
```

This option worked well on a fairly minimal install of Ubuntu 20.04.

#### Option #2:

Specify a custom `PATH` to Bazel via `--action_env`. The custom `PATH` should have the Swift bin
directory as the first item.

```sh
swift_exec=$(which swift)
real_swift_exec=$(realpath $swift_exec)
real_swift_dir=$(dirname $real_swift_exec)
new_path="${real_swift_dir}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
cat >>local.bazelrc <<EOF
build --action_env=PATH=${new_path}
EOF
```

This approach was necessary to successfully execute the examples on an Ubuntu runner using Github
actions. See the [Github workflow](.github/workflows/bazel.yml) for more details.


## Quick Start

The following provides a quick introduction on how to use the rules in this repository. Also, check
out the [examples directory](examples/) for more information.


### 1. Configure your workspace to use `rules_spm`

Add the following to your `WORKSPACE` file to add this repository and its dependencies.

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "cgrindel_rules_spm",
    sha256 = "e45ae4d99ec0f8505cb8663368d8574a3eea481e8e966787fd02aabaf793007a",
    strip_prefix = "rules_spm-0.4.0",
    urls = ["https://github.com/cgrindel/rules_spm/archive/v0.4.0.tar.gz"],
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


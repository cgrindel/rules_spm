# Swift Package Manager Rules for Bazel

[![Build](https://github.com/cgrindel/rules_spm/actions/workflows/ci.yml/badge.svg?event=schedule)](https://github.com/cgrindel/rules_spm/actions/workflows/ci.yml)

This repository contains rules for [Bazel](https://bazel.build/) that can be used to download, build
and consume Swift packages with [rules_swift](https://github.com/bazelbuild/rules_swift) rules.  The
rules in this repository build the external Swift packages with [Swift Package
Manager](https://swift.org/package-manager/), then make the outputs available to Bazel rules.

## Table of Contents

* [Reference Documentation](#reference-documentation)
* [Prerequisites](#prerequisites)
  * [Mac OS](#mac-os)
  * [Linux](#linux)
    * [Option \#1: Create a symlink to the linker in the clang directory\.](#option-1-create-a-symlink-to-the-linker-in-the-clang-directory)
    * [Option \#2: Specify a custom PATH via \-\-action\_env](#option-2-specify-a-custom-path-via---action_env)
* [Quickstart](#quickstart)
  * [1\. Configure your workspace to use rules\_spm](#1-configure-your-workspace-to-use-rules_spm)
  * [2\. Add external Swift packages as dependencies to your workspace](#2-add-external-swift-packages-as-dependencies-to-your-workspace)
  * [3\. Use the module(s) defined in the Swift packages](#3-use-the-modules-defined-in-the-swift-packages)

## Reference Documentation

[Click here](/doc) for reference documentation for the rules and other definitions in this repository.

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

#### Option #2: Specify a custom `PATH` via `--action_env`

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

<a id="#quickstart"></a>

## Quickstart

The following provides a quick introduction on how to use the rules in this repository. Also, check
out the [examples directory](examples/) for more information.


### 1. Configure your workspace to use `rules_spm`

Add the following to your `WORKSPACE` file to add this repository and its dependencies.

<!-- BEGIN WORKSPACE SNIPPET -->
```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "cgrindel_rules_spm",
    sha256 = "ba4310ba33cd1864a95e41d1ceceaa057e56ebbe311f74105774d526d68e2a0d",
    strip_prefix = "rules_spm-0.10.0",
    urls = [
        "http://github.com/cgrindel/rules_spm/archive/v0.10.0.tar.gz",
    ],
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
<!-- END WORKSPACE SNIPPET -->

### 2. Add external Swift packages as dependencies to your workspace

Add the following to download and build [apple/swift-log](https://github.com/apple/swift-log) to
your workspace. NOTE: It is imperative that the products that will be used by your project are 
listed in the `products` list.

```python
load("@cgrindel_rules_spm//spm:defs.bzl", "spm_pkg", "spm_repositories")

spm_repositories(
    name = "swift_pkgs",
    dependencies = [
        spm_pkg(
            "https://github.com/apple/swift-log.git",
            exact_version = "1.4.2",
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


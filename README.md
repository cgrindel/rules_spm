# Swift Package Manager Rules for Bazel

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

local_repository(
    name = "cgrindel_rules_spm",
    path = "../..",
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
local_repository(
    name = "cgrindel_rules_spm",
    path = "../..",
)

load(
    "@cgrindel_rules_spm//spm:repositories.bzl",
    "rules_spm_dependencies",
)

rules_spm_dependencies()
```

### 2. Add external Swift packages as dependencies to your workspace

Add the following to download and build [apple/swift-log](https://github.com/apple/swift-log) to
your workspace.

```python
load(
    "@cgrindel_rules_spm//spm:spm.bzl",
    "spm_repository",
)

spm_repository(
    name = "apple_swift_log",
    sha256 = "de51662b35f47764b6e12e9f1d43e7de28f6dd64f05bc30a318cf978cf3bc473",
    strip_prefix = "swift-log-1.4.2",
    urls = ["https://github.com/apple/swift-log/archive/1.4.2.tar.gz"],
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
        "@apple_swift_log//:Logging",
    ],
)
```

Lastly, import the Swift module and enjoy!

```python
import Logging

let logger = Logger(label: "com.example.main")
logger.info("Hello World!")
```



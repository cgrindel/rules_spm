# Swift Package Manager Rules for Bazel

This repository contains rules for [Bazel](https://bazel.build/) that can be used to download, build
and consume Swift packages with [rules_swift](https://github.com/bazelbuild/rules_swift) rules.  The
rules in this repository build the external Swift packages with [Swift Package
Manager](https://swift.org/package-manager/), then make the outputs available to Bazel rules using
[objc_library](https://docs.bazel.build/versions/main/be/objective-c.html#objc_library) and
[swift_import](https://github.com/bazelbuild/rules_swift/blob/master/doc/rules.md#swift_import).


## Quick Setup

### 1. Configure your workspace

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


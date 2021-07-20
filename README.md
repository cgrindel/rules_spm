# Swift Package Manager Rules for Bazel

This repository contains rules for [Bazel](https://bazel.build/) that can be used to download, build
and consume Swift packages with [rules_swift](https://github.com/bazelbuild/rules_swift) rules.  The
rules in this repository build the external Swift packages with [Swift Package
Manager](https://swift.org/package-manager/), then make the outputs available to Bazel rules using
[objc_library](https://docs.bazel.build/versions/main/be/objective-c.html#objc_library) and
[swift_import](https://github.com/bazelbuild/rules_swift/blob/master/doc/rules.md#swift_import).

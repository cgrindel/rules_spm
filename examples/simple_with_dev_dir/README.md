# Simple Example Specifying the Xcode Version Using `env` Attribute

This example demonstrates how to declare a Swift package as a dependency, specify it as a dependency
in a `swift_binary` rule and then import it in a Swift source file. In this case, the client is
specifying the Xcode version by specifying the `DEVELOPER_DIR` as an `env` attribute value in the
`spm_repositories` declaration.

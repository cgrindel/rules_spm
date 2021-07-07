package_description_json = """
{
  "dependencies" : [

  ],
  "name" : "swift-log",
  "path" : "/private/var/tmp/_bazel_chuck/acd478c94e4d22147ca64882e3ea61f8/external/apple_swift_log",
  "platforms" : [

  ],
  "products" : [
    {
      "name" : "Logging",
      "targets" : [
        "Logging"
      ],
      "type" : {
        "library" : [
          "automatic"
        ]
      }
    }
  ],
  "targets" : [
    {
      "c99name" : "LoggingTests",
      "module_type" : "SwiftTarget",
      "name" : "LoggingTests",
      "path" : "Tests/LoggingTests",
      "sources" : [
        "CompatibilityTest+XCTest.swift",
        "CompatibilityTest.swift",
        "GlobalLoggingTest+XCTest.swift",
        "GlobalLoggingTest.swift",
        "LocalLoggingTest+XCTest.swift",
        "LocalLoggingTest.swift",
        "LoggingTest+XCTest.swift",
        "LoggingTest.swift",
        "MDCTest+XCTest.swift",
        "MDCTest.swift",
        "TestLogger.swift"
      ],
      "target_dependencies" : [
        "Logging"
      ],
      "type" : "test"
    },
    {
      "c99name" : "Logging",
      "module_type" : "SwiftTarget",
      "name" : "Logging",
      "path" : "Sources/Logging",
      "product_memberships" : [
        "Logging"
      ],
      "sources" : [
        "Locks.swift",
        "LogHandler.swift",
        "Logging.swift"
      ],
      "type" : "library"
    },
    {
      "c99name" : "NotVisible",
      "module_type" : "SwiftTarget",
      "name" : "NotVisible",
      "path" : "Sources/NotVisible",
      "sources" : [
        "Foo.swift"
      ],
      "type" : "library"
    }
  ],
  "tools_version" : "5.0"
}
"""

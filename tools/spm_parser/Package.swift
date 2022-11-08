// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "spm_parser",
    platforms: [
        .macOS(.v12),
    ],
    dependencies: [
        // Need to match the version that is used in swift-package-manager
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(
            url: "https://github.com/apple/swift-package-manager",
            revision: "54d12394b7ff04e63d11a4d2eb6294d3ed1816ed"
        ),
    ],
    targets: [
        .executableTarget(
            name: "spm_parser",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftPM", package: "swift-package-manager"),
            ]
        ),
        .testTarget(
            name: "spm_parserTests",
            dependencies: ["spm_parser"]
        ),
    ]
)

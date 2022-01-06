// swift-tools-version:{swift_tools_version}

import PackageDescription

let package = Package(
  name: "placeholder",
{swift_platforms}
  products: [
    .library(name: "Placeholder", targets: ["Placeholder"]),
  ],
  dependencies: [
{package_dependencies}
  ],
  targets: [
    .target( name: "Placeholder", dependencies: [
{target_dependencies}
    ]),
  ]
)

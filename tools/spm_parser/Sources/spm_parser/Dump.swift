import ArgumentParser
import Basics
import Foundation
import TSCBasic
import Workspace

@main
struct Dump: AsyncParsableCommand {
    @Argument(
        help: "The location of the Package.swift file to analyze.",
        completion: .file(),
        transform: ({ AbsolutePath($0) })
    )
    // var packagePath: String
    var packagePath: AbsolutePath

    // var packageAbsolutePath: AbsolutePath {
    //     return AbsolutePath(packagePath)
    // }

    // private var loadingTask: Task<Void, Never>?

    mutating func runAsync() async throws {
        // DEBUG BEGIN
        fputs("*** CHUCK packagePath: \(String(reflecting: packagePath))\n", stderr)
        // DEBUG END

        let observability = ObservabilitySystem { print("\($0): \($1)") }
        let workspace = try Workspace(forRootPackage: packagePath)

        // DEBUG BEGIN
        fputs("*** CHUCK START\n", stderr)
        // DEBUG END

        let manifest = try await workspace.loadRootManifest(
            at: packagePath,
            observabilityScope: observability.topScope
        )

        // DEBUG BEGIN
        fputs("*** CHUCK manifest: \(String(reflecting: manifest))\n", stderr)
        // DEBUG END

        let products = manifest.products.map { $0.name }.joined(separator: ", ")
        print("Products:", products)

        let targets = manifest.targets.map { $0.name }.joined(separator: ", ")
        print("Targets:", targets)
        // DEBUG BEGIN
        fputs("*** CHUCK manifest.targets:\n", stderr)
        for (idx, item) in manifest.targets.enumerated() {
            fputs("*** CHUCK   \(idx) : \(String(reflecting: item))\n", stderr)
        }
        // DEBUG END
    }
}

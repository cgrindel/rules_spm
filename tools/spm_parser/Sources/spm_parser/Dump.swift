import ArgumentParser
import Basics
import Foundation
import TSCBasic
import Workspace

@main
struct Dump: AsyncParsableCommand {
    enum DumpError: Error {
        // case failedToEncodeAsJSON
        case failedToConvertToUTF8
    }

    @Argument(
        help: "The location of the Package.swift file to analyze.",
        completion: .directory,
        transform: ({ AbsolutePath($0) })
    )
    var packagePath: AbsolutePath

    // @Option(
    //     help: "The location to write the target descriptions JSON."
    // )
    // var outputPath:

    // let encoder = JSONEncoder()
    lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()

    mutating func runAsync() async throws {
        let observability = ObservabilitySystem { print("\($0): \($1)") }
        let workspace = try Workspace(forRootPackage: packagePath)
        let manifest = try await workspace.loadRootManifest(
            at: packagePath,
            observabilityScope: observability.topScope
        )

        // let products = manifest.products.map { $0.name }.joined(separator: ", ")
        // print("Products:", products)

        // let targets = manifest.targets.map { $0.name }.joined(separator: ", ")
        // print("Targets:", targets)
        // // DEBUG BEGIN
        // fputs("*** CHUCK manifest.targets:\n", stderr)
        // for (idx, item) in manifest.targets.enumerated() {
        //     fputs("*** CHUCK   \(idx) : \(String(reflecting: item))\n", stderr)
        // }
        // // DEBUG END

        let targets = manifest.targets
        let jsonData = try encoder.encode(targets)
        guard let json = String(data: jsonData, encoding: .utf8) else {
            throw DumpError.failedToConvertToUTF8
        }

        // DEBUG BEGIN
        fputs("*** CHUCK json: \(json)\n", stderr)
        // DEBUG END
    }
}

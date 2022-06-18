import ArgumentParser
import Basics
import Foundation
import TSCBasic
import Workspace

@main
struct Dump: AsyncParsableCommand {
    enum DumpError: Error {
        case failedToCreateOutputFile(String)
        case failedToOpenOutputFile(String)
    }

    @Argument(
        help: "The location of the Package.swift file to analyze.",
        completion: .directory,
        transform: ({ AbsolutePath($0) })
    )
    var packagePath: AbsolutePath

    @Option(
        help: "The location to write the target descriptions JSON file.",
        completion: .file(extensions: ["json", "txt"]),
        transform: URL.init(fileURLWithPath:)
    )
    var outputFile: URL?

    lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()

    static let newLine: Data = "\n".data(using: .utf8)!

    mutating func runAsync() async throws {
        let observability = ObservabilitySystem { print("\($0): \($1)") }
        let workspace = try Workspace(forRootPackage: packagePath)
        let manifest = try await workspace.loadRootManifest(
            at: packagePath,
            observabilityScope: observability.topScope
        )
        let targets = manifest.targets

        // Encode to JSON
        let jsonData = try encoder.encode(targets)

        try writeOutput { fileHandle in
            try fileHandle.write(contentsOf: jsonData)
            try fileHandle.write(contentsOf: Dump.newLine)
        }
    }

    private func createFileHandle() throws -> FileHandle {
        guard let outputFile = outputFile else {
            return .standardOutput
        }
        // Create the file, then create the file handle
        guard FileManager.default.createFile(atPath: outputFile.path, contents: nil) else {
            throw DumpError.failedToCreateOutputFile(outputFile.path)
        }
        guard let outputFileHandle = FileHandle(forWritingAtPath: outputFile.path) else {
            throw DumpError.failedToOpenOutputFile(outputFile.path)
        }
        return outputFileHandle
    }

    func writeOutput(closure: (_ fileHandle: FileHandle) throws -> Void) throws {
        let fileHandle = try createFileHandle()
        defer {
            try? fileHandle.close()
        }
        try closure(fileHandle)
    }
}

import ArgumentParser
import Basics
import Foundation
import TSCBasic
import Workspace

@main
struct Dump: ParsableCommand {
    @Argument(
        help: "The location of the Package.swift file to analyze.",
        completion: .file()
    )
    var packagePath: String

    mutating func run() throws {
        // DEBUG BEGIN
        fputs("*** CHUCK packagePath: \(String(reflecting: packagePath))\n", stderr)
        // DEBUG END
    }
}

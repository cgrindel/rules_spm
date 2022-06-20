import class Foundation.Bundle
import XCTest

final class spm_parserTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        // Mac Catalyst won't have `Process`, but it is supported for executables.
        #if !targetEnvironment(macCatalyst)

            let fooBinary = productsDirectory.appendingPathComponent("spm_parser")

            // GH149: Remove this placeholder test after implementing real test.
            let process = Process()
            process.executableURL = fooBinary
            process.arguments = [
                "--help",
            ]
            let stdout = Pipe()
            let stderr = Pipe()
            process.standardOutput = stdout
            process.standardError = stderr
            try process.run()
            process.waitUntilExit()
            XCTAssertEqual(process.terminationStatus, 0)

            // GH149: Implement a test parsing a package.

            // try withSwiftPackage { packageDirURL in
            //     let process = Process()
            //     process.executableURL = fooBinary
            //     process.arguments = [
            //         packageDirURL.path,
            //     ]

            //     let pipe = Pipe()
            //     process.standardOutput = pipe

            //     try process.run()
            //     process.waitUntilExit()

            //     let data = pipe.fileHandleForReading.readDataToEndOfFile()
            //     let output = String(data: data, encoding: .utf8)

            //     XCTAssertEqual(output, "Hello, world!\n")
            // }
        #endif
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
        #if os(macOS)
            for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
                return bundle.bundleURL.deletingLastPathComponent()
            }
            fatalError("couldn't find the products directory")
        #else
            return Bundle.main.bundleURL
        #endif
    }

    typealias URLConsumer = (URL) throws -> Void

    func withSwiftPackage(
        file _: StaticString = #file, line _: UInt = #line,
        urlConsumer _: URLConsumer
    ) throws {
        // withTempDir(file: file, line: line) { tempDirURL in
        //     let fileManager = FileManager.default

        //     // Create the Package.swift file
        //     let packageManifestURL = tempDirURL.appendingPathComponent("Package.swift")
        //     fileManager.createFile()
        // }
    }

    func withTempDir(
        file: StaticString = #file, line: UInt = #line,
        urlConsumer: URLConsumer
    ) {
        // Create the temp directory URL
        let rootDirectory = NSTemporaryDirectory()
        let rootDirURL = URL(fileURLWithPath: rootDirectory, isDirectory: true)
        let tempDirURL = rootDirURL.appendingPathComponent(UUID().uuidString)

        // Create the temporary directory.
        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory(at: tempDirURL, withIntermediateDirectories: true)
        } catch {
            XCTFail("Error occurred while creating temporary directory. \(error)",
                    file: file, line: line)
            return
        }
        defer {
            if fileManager.fileExists(atPath: tempDirURL.path) {
                try? fileManager.removeItem(at: tempDirURL)
            }
        }

        // Execute the consumer
        do {
            try urlConsumer(tempDirURL)
        } catch {
            XCTFail("Caught unexpected error. \(error)", file: file, line: line)
        }
    }
}

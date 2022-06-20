import ArgumentParser

// Heavily inspired by
// https://medium.com/geekculture/develop-a-command-line-tool-using-swift-concurrency-e16d254361cb

// In ArgumentParser 1.1.0 and later, AsyncParsableCommand exists. However, swift-package-manager is
// pinned to no later than 1.0.3, right now.
protocol AsyncParsableCommand: ParsableCommand {
    mutating func runAsync() async throws
}

public extension ParsableCommand {
    static func main() async {
        do {
            var command = try parseAsRoot(nil)
            if var asyncCommand = command as? AsyncParsableCommand {
                try await asyncCommand.runAsync()
            } else {
                try command.run()
            }
        } catch {
            exit(withError: error)
        }
    }
}

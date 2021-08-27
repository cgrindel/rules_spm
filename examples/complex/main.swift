import Logging
import NIO

let logger = Logger(label: "com.example.main")

let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
defer {
    // swiftlint:disable force_try
    try! group.syncShutdownGracefully()
    // swiftlint:enable force_try
}

let eventLoop = group.next()
let future = eventLoop.submit {
    logger.info("Hello World!")
}

try future.wait()

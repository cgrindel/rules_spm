import FooKit
import Logging
import NIO

let logger = Logger(label: "com.example.main")

let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
defer {
  try! group.syncShutdownGracefully()
}

let eventLoop = group.next()

// Use a FooKit extension
let future = eventLoop.future()

try future.wait()

logger.info("Hello World!")

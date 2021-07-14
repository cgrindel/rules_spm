import Logging
import NIO

let logger = Logger(label: "com.example.main")

let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
defer {
  try! group.syncShutdownGracefully()
}

let eventLoop = group.next()
let future = eventLoop.submit {
  logger.info("Hello World!")
}

try future.wait()

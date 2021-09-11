import NIO

public extension EventLoop {
  func future() -> EventLoopFuture<Void> {
    return makeSucceededFuture(())
  }
}

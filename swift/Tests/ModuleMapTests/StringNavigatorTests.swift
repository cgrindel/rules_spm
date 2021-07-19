@testable import ModuleMap
import Truth
import XCTest

class StringNavigatorTests: XCTestCase {
  let input = "Hello, Chicken!"
  lazy var navigator = { StringNavigator(input) }()

  func test_navigation_WithNonEmptyString() throws {
    assertThat(navigator)
      .key(\.input) { $0.isEqualTo(input) }
      .key(\.currentIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }

    navigator.next()
    assertThat(navigator)
      .key(\.currentIndex) { $0.isEqualTo(input.index(after: input.startIndex)) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }

    navigator.previous()
    assertThat(navigator)
      .key(\.currentIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }

    // Try to navigate before the start of the input
    navigator.previous()
    assertThat(navigator)
      .key(\.currentIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }

    // Navigate to the end of the input
    for _ in 0 ..< input.count {
      navigator.next()
    }
    assertThat(navigator)
      .key(\.currentIndex) { $0.isEqualTo(input.endIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }

    // Try to navigate past the end of the input
    navigator.next()
    assertThat(navigator)
      .key(\.currentIndex) { $0.isEqualTo(input.endIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }

    // Reset to the beginning
    navigator.reset()
    navigator.next()
    navigator.mark()
    for _ in 0 ..< 4 {
      navigator.next()
    }
    assertThat(navigator)
      .key(\.markToCurrent) { $0.isEqualTo("ello") }

    fail("IMPLEMENT ME!")
  }

  func test_WithEmptyString() throws {
    fail("IMPLEMENT ME!")
  }
}

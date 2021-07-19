@testable import ModuleMap
import Truth
import XCTest

class StringNavigatorTests: XCTestCase {
  let input = "Hello, Chicken!"
  lazy var navigator = { StringNavigator(input) }()

  // TODO: Add current to the tests

  func test_navigation_WithNonEmptyString() throws {
    assertThat(navigator)
      .key(\.input) { $0.isEqualTo(input) }
      .key(\.currentIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markToCurrent) { $0.isEqualTo("") }

    navigator.next()
    assertThat(navigator)
      .key(\.currentIndex) { $0.isEqualTo(input.index(after: input.startIndex)) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markToCurrent) { $0.isEqualTo("H") }

    navigator.previous()
    assertThat(navigator)
      .key(\.currentIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markToCurrent) { $0.isEqualTo("") }

    // Try to navigate before the start of the input
    navigator.previous()
    assertThat(navigator)
      .key(\.currentIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markToCurrent) { $0.isEqualTo("") }

    // Navigate to the end of the input
    for _ in 0 ..< input.count {
      navigator.next()
    }
    assertThat(navigator)
      .key(\.currentIndex) { $0.isEqualTo(input.endIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markToCurrent) { $0.isEqualTo("Hello, Chicken!") }

    // Try to navigate past the end of the input
    navigator.next()
    assertThat(navigator)
      .key(\.currentIndex) { $0.isEqualTo(input.endIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }

    // Reset to the beginning
    navigator.reset()
    assertThat(navigator)
      .key(\.input) { $0.isEqualTo(input) }
      .key(\.currentIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markToCurrent) { $0.isEqualTo("") }

    // Mark a substring
    navigator.next()
    navigator.mark()
    for _ in 0 ..< 4 {
      navigator.next()
    }
    assertThat(navigator)
      .key(\.markToCurrent) { $0.isEqualTo("ello") }
  }

  func test_WithEmptyString() throws {
    var navigator = StringNavigator("")
    assertThat(navigator)
      .key(\.input) { $0.isEqualTo("") }
      .key(\.currentIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markToCurrent) { $0.isEqualTo("") }

    // Making sure that nothing causes a fatal error
    navigator.next()
    navigator.previous()
    navigator.mark()
  }
}

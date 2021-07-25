@testable import ModuleMap
import Truth
import XCTest

class StringNavigatorTests: XCTestCase {
  let input = "Hello, Chicken!"
  lazy var navigator = { StringNavigator(input) }()

  // swiftlint:disable function_body_length
  func test_navigation_WithNonEmptyString() throws {
    assertThat(navigator)
      .key(\.input) { $0.isEqualTo(input) }
      .key(\.currentIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markToCurrent) { $0.isEqualTo("") }
      .key(\.current) { $0.isNotNil { $0.isEqualTo("H") } }

    navigator.next()
    assertThat(navigator)
      .key(\.currentIndex) { $0.isEqualTo(input.index(after: input.startIndex)) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markToCurrent) { $0.isEqualTo("H") }
      .key(\.current) { $0.isNotNil { $0.isEqualTo("e") } }

    navigator.previous()
    assertThat(navigator)
      .key(\.currentIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markToCurrent) { $0.isEqualTo("") }
      .key(\.current) { $0.isNotNil { $0.isEqualTo("H") } }

    // Try to navigate before the start of the input
    navigator.previous()
    assertThat(navigator)
      .key(\.currentIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markToCurrent) { $0.isEqualTo("") }
      .key(\.current) { $0.isNotNil { $0.isEqualTo("H") } }

    // Navigate to the end of the input
    for _ in 0 ..< input.count {
      navigator.next()
    }
    assertThat(navigator)
      .key(\.currentIndex) { $0.isEqualTo(input.endIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markToCurrent) { $0.isEqualTo("Hello, Chicken!") }
      .key(\.current) { $0.isNil() }

    // Try to navigate past the end of the input
    navigator.next()
    assertThat(navigator)
      .key(\.currentIndex) { $0.isEqualTo(input.endIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.current) { $0.isNil() }

    // Reset to the beginning
    navigator.reset()
    assertThat(navigator)
      .key(\.input) { $0.isEqualTo(input) }
      .key(\.currentIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markToCurrent) { $0.isEqualTo("") }
      .key(\.current) { $0.isNotNil { $0.isEqualTo("H") } }

    // Mark a substring
    navigator.next()
    navigator.mark()
    for _ in 0 ..< 4 {
      navigator.next()
    }
    assertThat(navigator)
      .key(\.markToCurrent) { $0.isEqualTo("ello") }
      .key(\.current) { $0.isNotNil { $0.isEqualTo(",") } }
  }

  // swiftlint:enable function_body_length

  func test_WithEmptyString() throws {
    var navigator = StringNavigator("")
    assertThat(navigator)
      .key(\.input) { $0.isEqualTo("") }
      .key(\.currentIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markIndex) { $0.isEqualTo(input.startIndex) }
      .key(\.markToCurrent) { $0.isEqualTo("") }
      .key(\.current) { $0.isNil() }

    // Making sure that nothing causes a fatal error
    navigator.next()
    navigator.previous()
    navigator.mark()
  }

  func test_nextWhileIn() throws {
    var navigator = StringNavigator("1234 5678")
    navigator.mark()
    navigator.next(whileIn: .decimalDigits)
    assertThat(navigator.markToCurrent).isEqualTo("1234")
  }
}

@testable import ModuleMap
import Truth
import XCTest

class CharacterExtensionsTests: XCTestCase {
  func test_isIn() throws {
    do_isIn_test(char: "1", charSet: .decimalDigits, expected: true)
    do_isIn_test(char: "a", charSet: .decimalDigits, expected: true)
  }

  func do_isIn_test(
    char: Character,
    charSet: CharacterSet,
    expected: Bool,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    assertThat(char.isIn(charSet)).isEqualTo(expected, file: file, line: line)
  }
}

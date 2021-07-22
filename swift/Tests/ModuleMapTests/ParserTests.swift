@testable import ModuleMap
import Truth
import XCTest

class ParserTests: XCTestCase {
  // MARK: Empty String

  func test_parse_EmptyString_Success() throws {
    let result = try Parser.parse("")
    assertThat(result).isEmpty()
  }

  // MARK: Multiple Modules

  func test_parse_MultipleTopLevelModules_Success() throws {
    let text = """
    extern module MyModule "path/to/def/module.modulemap"
    extern module AnotherModule "another/path/to/def/module.modulemap"
    """
    let result = try Parser.parse(text)
    assertThat(result)
      .hasCount(2)
      .firstItem {
        $0.isA(ExternModuleDeclaration.self) {
          $0.key(\.moduleID) { $0.isEqualTo("MyModule") }
            .key(\.definitionPath) { $0.isEqualTo("path/to/def/module.modulemap") }
        }
      }
      .lastItem {
        $0.isA(ExternModuleDeclaration.self) {
          $0.key(\.moduleID) { $0.isEqualTo("AnotherModule") }
            .key(\.definitionPath) { $0.isEqualTo("another/path/to/def/module.modulemap") }
        }
      }
  }
}

@testable import ModuleMap
import Truth
import XCTest

class ParserTests: XCTestCase {
  func test_parse_EmptyString_Success() throws {
    let result = try Parser.parse("")
    assertThat(result).isEmpty()
  }

  func test_parse_ForExternModule_Success() throws {
    let text = """
    extern module MyModule "path/to/def/module.modulemap"
    """
    let result = try Parser.parse(text)
    assertThat(result)
      .hasCount(1)
      .firstItem {
        $0.isA(ExternModuleDeclaration.self) {
          $0
            .key(\.moduleID) { $0.isEqualTo("MyModule") }
            .key(\.definitionPath) { $0.isEqualTo("path/to/def/module.modulemap") }
        }
      }
  }

  func test_parse_ForExternModule_MissingModuleToken_Failure() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ForExternModule_MissingModuleIDToken_Failure() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ForExternModule_MissingPathToken_Failure() throws {
    fail("IMPLEMENT ME!")
  }
}

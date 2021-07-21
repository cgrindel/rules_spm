@testable import ModuleMap
import Truth
import XCTest

class ParserTests: XCTestCase {
  // MARK: Empty String

  func test_parse_EmptyString_Success() throws {
    let result = try Parser.parse("")
    assertThat(result).isEmpty()
  }

  // MARK: Extern Module

  func test_parse_ForExternModule_Success() throws {
    let text = """
    extern module MyModule "path/to/def/module.modulemap"
    """
    let result = try Parser.parse(text)
    assertThat(result)
      .hasCount(1)
      .firstItem {
        $0.isA(ExternModuleDeclaration.self) {
          $0.key(\.moduleID) { $0.isEqualTo("MyModule") }
            .key(\.definitionPath) { $0.isEqualTo("path/to/def/module.modulemap") }
        }
      }
  }

  func test_parse_ForExternModule_MissingModuleToken_Failure() throws {
    let text = """
    extern MyModule "path/to/def/module.modulemap"
    """
    assertThat { try Parser.parse(text) }.doesThrow(
      ParserError.unexpectedToken(
        .identifier("MyModule"),
        "Expected the module token while parsing an extern module."
      )
    )
  }

  func test_parse_ForExternModule_MissingModuleIDToken_Failure() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ForExternModule_MissingPathToken_Failure() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ForExternModule_PrematureEOT() throws {
    fail("IMPLEMENT ME!")
  }

  // MARK: Multiple Modules

  func test_parse_MultipleTopLevelModules_Success() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ModulesWithSubmodules_Success() throws {
    fail("IMPLEMENT ME!")
  }
}

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
    let text = """
    extern module "path/to/def/module.modulemap"
    """
    assertThat { try Parser.parse(text) }.doesThrow(
      ParserError.unexpectedToken(
        .stringLiteral("path/to/def/module.modulemap"),
        "Expected the module id token while parsing an extern module."
      )
    )
  }

  func test_parse_ForExternModule_MissingPathToken_Failure() throws {
    let text = """
    extern module MyModule foo
    """
    assertThat { try Parser.parse(text) }.doesThrow(
      ParserError.unexpectedToken(
        .identifier("foo"),
        "Expected a string literal token for the path while parsing an extern module."
      )
    )
  }

  func test_parse_ForExternModule_PrematureEOT() throws {
    var text = """
    extern
    """
    assertThat { try Parser.parse(text) }.doesThrow(
      ParserError.endOfTokens("Looking for the module token while parsing an extern module.")
    )

    text = """
    extern module
    """
    assertThat { try Parser.parse(text) }.doesThrow(
      ParserError.endOfTokens("Looking for the module id token while parsing an extern module.")
    )

    text = """
    extern module MyModule
    """
    assertThat { try Parser.parse(text) }.doesThrow(
      ParserError
        .endOfTokens("Looking for the module definition path token while parsing an extern module.")
    )
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

  func test_parse_ModulesWithSubmodules_Success() throws {
    fail("IMPLEMENT ME!")
  }
}

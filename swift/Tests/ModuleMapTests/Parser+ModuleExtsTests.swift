@testable import ModuleMap
import Truth
import XCTest

class ParserModuleExtsTests: XCTestCase {
  func test_parse_ForModule_WithoutQualifiersAttributesAndMembers_Success() throws {
    let text = """
    module MyModule {}
    """
    let result = try Parser.parse(text)
    assertThat(result)
      .hasCount(1)
      .firstItem {
        $0.isA(ModuleDeclaration.self) {
          $0.key(\.moduleID) { $0.isEqualTo("MyModule") }
        }
      }
  }

  func test_parse_ForModule_WithoutQualifiers_Success() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ForModule_WithQualifiers_Success() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ForModule_WithAttributes_Success() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ForModule_WithoutAttributes_Success() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ForModule_WithUnexpectedQualifier_Failure() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ForModule_WithMissingModuleID_Failure() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ForModule_WithMalformedAttribute_Failure() throws {
    fail("IMPLEMENT ME!")
  }
}

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
            .key(\.framework) { $0.isFalse() }
            .key(\.explicit) { $0.isFalse() }
            .key(\.attributes) { $0.isEmpty() }
            .key(\.members) { $0.isEmpty() }
        }
      }
  }

  func test_parse_ForModule_WithQualifiers_Success() throws {
    let text = """
    framework module MyModule {}
    """
    let result = try Parser.parse(text)
    assertThat(result)
      .hasCount(1)
      .firstItem {
        $0.isA(ModuleDeclaration.self) {
          $0.key(\.moduleID) { $0.isEqualTo("MyModule") }
            .key(\.framework) { $0.isTrue() }
            .key(\.explicit) { $0.isFalse() }
            .key(\.attributes) { $0.isEmpty() }
            .key(\.members) { $0.isEmpty() }
        }
      }
  }

  func test_parse_ForModule_WithAttributes_Success() throws {
    let text = """
    module MyModule [system] [extern_c] {}
    """
    let result = try Parser.parse(text)
    assertThat(result)
      .hasCount(1)
      .firstItem {
        $0.isA(ModuleDeclaration.self) {
          $0.key(\.moduleID) { $0.isEqualTo("MyModule") }
            .key(\.framework) { $0.isFalse() }
            .key(\.explicit) { $0.isFalse() }
            .key(\.attributes) { $0.isEqualTo(["system", "extern_c"]) }
            .key(\.members) { $0.isEmpty() }
        }
      }
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

  // MARK: Submodules

  func test_parse_ForModule_WithSubmodule_Success() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ForModule_WithExplicitSubmodule_Success() throws {
    // let text = """
    // module foo {
    //   explicit module complex {
    //     header "complex.h"
    //     export *
    //   }
    // }
    // """
    fail("IMPLEMENT ME!")
  }
}

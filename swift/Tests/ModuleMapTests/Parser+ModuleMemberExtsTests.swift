@testable import ModuleMap
import Truth
import XCTest

class ParserModuleMemberExtsTests: XCTestCase {
  // MARK: Requires Declaration

  func test_parse_ForModule_WithRequiresDeclOneFeature_Success() throws {
    let text = """
    module MyModule {
        requires c99
    }
    """
    let result = try Parser.parse(text)
    assertThat(result)
      .hasCount(1)
      .firstItem {
        $0.isA(ModuleDeclaration.self) {
          $0.key(\.moduleID) { $0.isEqualTo("MyModule") }
            .key(\.members) {
              $0.hasCount(1)
                .firstItem {
                  $0.isA(RequiresDeclaration.self) { $0.isEqualTo(.with {
                    $0.features = [.with { $0.name = "c99" }]
                  }) }
                }
            }
        }
      }
  }

  func test_parse_ForModule_WithRequiresDeclMultiFeature_Success() throws {
    fail("IMPLEMENT ME!")
    // let text = """
    // module MyModule {
    //     requires c99 !win32 tls
    // }
    // """
  }

  func test_parse_ForModule_WithRequiresDeclNoFeatures_Failure() throws {
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

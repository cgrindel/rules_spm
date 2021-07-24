@testable import ModuleMap
import Truth
import XCTest

class ParserRequiresDeclarationExtsTests: XCTestCase {
  func test_parse_ForModule_WithRequiresDeclOneFeature_Success() throws {
    try do_parse_ForModule_ModuleMember_test(
      expectedType: RequiresDeclaration.self,
      text: """
      module MyModule {
          requires c99
      }
      """
    ) {
      $0.isEqualTo(.with {
        $0.features = [.with { $0.name = "c99" }]
      })
    }
  }

  func test_parse_ForModule_WithRequiresDeclMultiFeature_Success() throws {
    try do_parse_ForModule_ModuleMember_test(
      expectedType: RequiresDeclaration.self,
      text: """
      module MyModule {
          requires c99, !win32, tls
      }
      """
    ) {
      $0.isEqualTo(.with {
        $0.features = [
          .init(name: "c99"),
          .init(name: "win32", compatible: false),
          .init(name: "tls"),
        ]
      })
    }
  }

  func test_parse_ForModule_WithRequiresDeclNoFeatures_Failure() throws {
    let text = """
    module MyModule {
        requires
    }
    """
    assertThat { try Parser.parse(text) }.doesThrow(
      ParserError.invalidRequiresDeclaration(
        "No features were found for requires declaration in MyModule module."
      )
    )
  }
}

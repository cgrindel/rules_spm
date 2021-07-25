@testable import ModuleMap
import Truth
import XCTest

class ParserLinkDeclarationExtsTests: XCTestCase {
  func test_parse_ForModule_WithLinkDeclNoFramework_Success() throws {
    try do_parse_ForModule_ModuleMember_test(
      expectedType: LinkDeclaration.self,
      text: """
      module MyModule {
          link "LibName"
      }
      """
    ) {
      $0.isEqualTo(.with {
        $0.name = "LibName"
      })
    }
  }

  func test_parse_ForModule_WithLinkDeclAsFramework_Success() throws {
    try do_parse_ForModule_ModuleMember_test(
      expectedType: LinkDeclaration.self,
      text: """
      module MyModule {
          link framework "LibName"
      }
      """
    ) {
      $0.isEqualTo(.with {
        $0.name = "LibName"
        $0.framework = true
      })
    }
  }
}

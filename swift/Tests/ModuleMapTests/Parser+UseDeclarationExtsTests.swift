@testable import ModuleMap
import Truth
import XCTest

class ParserUseDeclarationExtsTests: XCTestCase {
  func test_parse_ForModule_WithUseDecl_Expectation() throws {
    try do_parse_ForModule_ModuleMember_test(
      expectedType: UseDeclaration.self,
      text: """
      module MyModule {
          use AnotherModule
      }
      """
    ) {
      $0.isEqualTo(.with {
        $0.moduleID = "AnotherModule"
      })
    }
  }
}

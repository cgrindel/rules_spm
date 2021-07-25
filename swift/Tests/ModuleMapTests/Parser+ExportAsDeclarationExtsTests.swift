@testable import ModuleMap
import Truth
import XCTest

class ParserExportAsDeclarationExtsTests: XCTestCase {
  func test_parse_ForModule_WithExportAs() throws {
    try do_parse_ForModule_ModuleMember_test(
      expectedType: ExportAsDeclaration.self,
      text: """
      module MyModule {
          export_as Foo
      }
      """
    ) {
      $0.isEqualTo(.with {
        $0.identifier = "Foo"
      })
    }
  }
}

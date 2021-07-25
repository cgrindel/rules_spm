@testable import ModuleMap
import Truth
import XCTest

class ParserExportDeclarationExtsTests: XCTestCase {
  func test_parse_ForModule_WithExportDeclWildcard_Success() throws {
    try do_parse_ForModule_ModuleMember_test(
      expectedType: ExportDeclaration.self,
      text: """
      module MyModule {
          export *
      }
      """
    ) {
      $0.isEqualTo(.with {
        $0.wildcard = true
      })
    }
  }

  func test_parse_ForModule_WithExportDeclIdentifiers_Success() throws {
    try do_parse_ForModule_ModuleMember_test(
      expectedType: ExportDeclaration.self,
      text: """
      module MyModule {
          export foo.bar
      }
      """
    ) {
      $0.isEqualTo(.with {
        $0.identifiers = ["foo", "bar"]
      })
    }
  }

  func test_parse_ForModule_WithExportDeclIdentifiersAndWildcard_Success() throws {
    try do_parse_ForModule_ModuleMember_test(
      expectedType: ExportDeclaration.self,
      text: """
      module MyModule {
          export foo.bar.*
      }
      """
    ) {
      $0.isEqualTo(.with {
        $0.identifiers = ["foo", "bar"]
        $0.wildcard = true
      })
    }
  }
}

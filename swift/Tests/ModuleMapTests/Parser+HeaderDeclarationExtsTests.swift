@testable import ModuleMap
import Truth
import XCTest

class ParserHeaderDeclarationExtsTests: XCTestCase {
  func test_parse_ForModule_WithSingleHeaderDeclNoQualifiers_Success() throws {
    try do_parse_ForModule_ModuleMember_test(
      expectedType: HeaderDeclaration.self,
      text: """
      module MyModule {
          header "path/to/header.h"
      }
      """
    ) {
      $0.isEqualTo(.with {
        $0.type = .single(.init())
        $0.path = "path/to/header.h"
      })
    }
  }

  func test_parse_ForModule_WithSingleHeaderDeclNoQualifiersWithAttribs_Success() throws {
    try do_parse_ForModule_ModuleMember_test(
      expectedType: HeaderDeclaration.self,
      text: """
      module MyModule {
          header "path/to/header.h" { size 1234 mtime 5678 }
      }
      """
    ) {
      $0.isEqualTo(.with {
        $0.type = .single(.init())
        $0.path = "path/to/header.h"
        $0.size = 1234
        $0.mtime = 5678
      })
    }
  }

  func test_parse_ForModule_WithSingleHeaderDeclAsPrivate_Success() throws {
    try do_parse_ForModule_ModuleMember_test(
      expectedType: HeaderDeclaration.self,
      text: """
      module MyModule {
          private header "path/to/header.h"
      }
      """
    ) {
      $0.isEqualTo(.with {
        $0.type = .single(.with { $0.privateHeader = true })
        $0.path = "path/to/header.h"
      })
    }
  }

  func test_parse_ForModule_WithSingleHeaderDeclAsTextual_Success() throws {
    try do_parse_ForModule_ModuleMember_test(
      expectedType: HeaderDeclaration.self,
      text: """
      module MyModule {
          textual header "path/to/header.h"
      }
      """
    ) {
      $0.isEqualTo(.with {
        $0.type = .single(.with { $0.textual = true })
        $0.path = "path/to/header.h"
      })
    }
  }

  func test_parse_ForModule_WithUmbrellaHeader_Success() throws {
    try do_parse_ForModule_ModuleMember_test(
      expectedType: HeaderDeclaration.self,
      text: """
      module MyModule {
          umbrella header "path/to/header.h"
      }
      """
    ) {
      $0.isEqualTo(.with {
        $0.type = .umbrella
        $0.path = "path/to/header.h"
      })
    }
  }

  func test_parse_ForModule_WithExcludeHeader_Success() throws {
    try do_parse_ForModule_ModuleMember_test(
      expectedType: HeaderDeclaration.self,
      text: """
      module MyModule {
          exclude header "path/to/header.h"
      }
      """
    ) {
      $0.isEqualTo(.with {
        $0.type = .exclude
        $0.path = "path/to/header.h"
      })
    }
  }
}

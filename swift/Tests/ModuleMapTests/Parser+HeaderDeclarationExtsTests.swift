@testable import ModuleMap
import Truth
import XCTest

class ParserHeaderDeclarationExtsTests: XCTestCase {
  func do_parse_ForModule_Header_test(
    _ text: String,
    file: StaticString = #file, line: UInt = #line,
    subjectConsumer: (Subject<HeaderDeclaration>) -> Void
  ) throws {
    let result = try Parser.parse(text)
    assertThat(result)
      .hasCount(1)
      .firstItem {
        $0.isA(ModuleDeclaration.self, file: file, line: line) {
          $0.key(file: file, line: line, \.moduleID) {
            $0.isEqualTo("MyModule", file: file, line: line)
          }
          .key(file: file, line: line, \.members) {
            $0.hasCount(1, file: file, line: line)
              .firstItem { $0.isA(HeaderDeclaration.self, file: file, line: line, subjectConsumer) }
          }
        }
      }
  }

  func test_parse_ForModule_WithSingleHeaderDeclNoQualifiers_Success() throws {
    try do_parse_ForModule_Header_test("""
    module MyModule {
        header "path/to/header.h"
    }
    """) {
      $0.isEqualTo(.with {
        $0.type = .single(.init())
        $0.path = "path/to/header.h"
      })
    }
    // let text = """
    // module MyModule {
    //     header "path/to/header.h"
    // }
    // """
    // let result = try Parser.parse(text)
    // assertThat(result)
    //   .hasCount(1)
    //   .firstItem {
    //     $0.isA(ModuleDeclaration.self) {
    //       $0.key(\.moduleID) { $0.isEqualTo("MyModule") }
    //         .key(\.members) {
    //           $0.hasCount(1)
    //             .firstItem {
    //               $0.isA(HeaderDeclaration.self) { $0.isEqualTo(.with {
    //                 $0.type = .single(.init())
    //                 $0.path = "path/to/header.h"
    //               }) }
    //             }
    //         }
    //     }
    //   }
  }

  func test_parse_ForModule_WithSingleHeaderDeclNoQualifiersWithAttribs_Success() throws {
    try do_parse_ForModule_Header_test("""
    module MyModule {
        header "path/to/header.h" { size 1234 mtime 5678 }
    }
    """) {
      $0.isEqualTo(.with {
        $0.type = .single(.init())
        $0.path = "path/to/header.h"
        $0.size = 1234
        $0.mtime = 5678
      })
    }
    // let text = """
    // module MyModule {
    //     header "path/to/header.h" { size 1234 mtime 5678 }
    // }
    // """
    // let result = try Parser.parse(text)
    // assertThat(result)
    //   .hasCount(1)
    //   .firstItem {
    //     $0.isA(ModuleDeclaration.self) {
    //       $0.key(\.moduleID) { $0.isEqualTo("MyModule") }
    //         .key(\.members) {
    //           $0.hasCount(1)
    //             .firstItem {
    //               $0.isA(HeaderDeclaration.self) { $0.isEqualTo(.with {
    //                 $0.type = .single(.init())
    //                 $0.path = "path/to/header.h"
    //                 $0.size = 1234
    //                 $0.mtime = 5678
    //               }) }
    //             }
    //         }
    //     }
    //   }
  }

  func test_parse_ForModule_WithSingleHeaderDeclAsPrivate_Success() throws {
    try do_parse_ForModule_Header_test("""
    module MyModule {
        private header "path/to/header.h"
    }
    """) {
      $0.isEqualTo(.with {
        $0.type = .single(.with { $0.privateHeader = true })
        $0.path = "path/to/header.h"
      })
    }
    // let text = """
    // module MyModule {
    //     private header "path/to/header.h"
    // }
    // """
    // let result = try Parser.parse(text)
    // assertThat(result)
    //   .hasCount(1)
    //   .firstItem {
    //     $0.isA(ModuleDeclaration.self) {
    //       $0.key(\.moduleID) { $0.isEqualTo("MyModule") }
    //         .key(\.members) {
    //           $0.hasCount(1)
    //             .firstItem {
    //               $0.isA(HeaderDeclaration.self) { $0.isEqualTo(.with {
    //                 $0.type = .single(.with { $0.privateHeader = true })
    //                 $0.path = "path/to/header.h"
    //               }) }
    //             }
    //         }
    //     }
    //   }
  }

  func test_parse_ForModule_WithSingleHeaderDeclAsTextual_Success() throws {
    fail("IMPLEMENT ME!")
    // let text = """
    // module MyModule {
    //     textual header "path/to/header.h"
    // }
    // """
    // let result = try Parser.parse(text)
    // assertThat(result)
    //   .hasCount(1)
    //   .firstItem {
    //     $0.isA(ModuleDeclaration.self) {
    //       $0.key(\.moduleID) { $0.isEqualTo("MyModule") }
    //         .key(\.members) {
    //           $0.hasCount(1)
    //             .firstItem {
    //               $0.isA(HeaderDeclaration.self) { $0.isEqualTo(.with {
    //                 $0.type = .single(.with { $0.privateHeader = true })
    //                 $0.path = "path/to/header.h"
    //               }) }
    //             }
    //         }
    //     }
    //   }
  }

  func test_parse_ForModule_WithUmbrellaHeader_Success() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ForModule_WithExcludeHeader_Success() throws {
    fail("IMPLEMENT ME!")
  }
}

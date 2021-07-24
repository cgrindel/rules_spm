import ModuleMap
import Truth
import XCTest

public extension XCTestCase {
  func do_parse_ForModule_ModuleMember_test<MM: ModuleMember>(
    expectedType _: MM.Type,
    file: StaticString = #file,
    line: UInt = #line,
    text: String,
    subjectConsumer: (Subject<MM>) -> Void
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
              .firstItem {
                $0.isA(MM.self, file: file, line: line, subjectConsumer)
              }
          }
        }
      }
  }
}

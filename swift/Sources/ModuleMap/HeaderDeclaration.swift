import StructUtils

/// Spec: https://clang.llvm.org/docs/Modules.html#header-declaration
struct HeaderDeclaration: Withable, Equatable, ModuleMember {
  /// Attributes that are specific to a single header file declaration.
  struct SingleQualifiers: Equatable {
    var privateHeader = false
    var textual = false
  }

  /// Specifies how the header declaration should be interpretted.
  enum DeclarationType: Equatable {
    case single(SingleQualifiers)
    case umbrella
    case exclude
  }

  /// Type of declaration
  var type: DeclarationType = .single(.init())
  /// Path to the header file.
  var path = ""

  // Attributes
  var size: Int?
  var mtime: Int?
}

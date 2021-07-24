import StructUtils

/// Spec: https://clang.llvm.org/docs/Modules.html#umbrella-directory-declaration
struct UmbrellaDirectoryDeclaration: Withable, Equatable, ModuleMember {
  /// Path to the directory with the headers to be included.
  var path = ""
}

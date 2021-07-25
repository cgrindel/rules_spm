import StructUtils

/// Spec: https://clang.llvm.org/docs/Modules.html#re-export-declaration
struct ExportAsDeclaration: Withable, Equatable, ModuleMember {
  var identifier = ""
}

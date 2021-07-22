import StructUtils

/// Spec: https://clang.llvm.org/docs/Modules.html#requires-declaration
struct RequiresDeclaration: Withable {
  struct Feature: Withable {
    var name = ""
    var compatible = true

    public init() {}
  }

  var features = [Feature]()

  public init() {}
}

extension RequiresDeclaration: ModuleMember {}

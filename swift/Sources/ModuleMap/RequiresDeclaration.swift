import StructUtils

/// Spec: https://clang.llvm.org/docs/Modules.html#requires-declaration
struct RequiresDeclaration: Withable, Equatable {
  struct Feature: Withable, Equatable {
    var name = ""
    var compatible = true

    public init() {}
  }

  var features = [Feature]()

  public init() {}
}

extension RequiresDeclaration: ModuleMember {}

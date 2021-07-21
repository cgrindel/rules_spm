public struct ModuleDeclaration: ModuleDeclarationProtocol {
  public var moduleID = ""

  // Qualifiers
  public var explicit = false
  public var framework = false

  // Attributes
  public var attributes = [String]()
  // public var system = false
  // public var externC = false
  // public var noUndeclaredIncludes = false

  // Module members
  // public var members = [ModuleMember]()
}

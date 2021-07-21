public struct ModuleDeclaration: ModuleDeclarationProtocol {
  public var moduleID = ""

  // Qualifiers
  public var explicit = false
  public var framework = false

  // Attributes
  public var attributes = [String]()

  // Module members
  public var members = [ModuleMember]()
}

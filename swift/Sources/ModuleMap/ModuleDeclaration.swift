public struct ModuleDeclaration {
  var moduleID = ""

  // Qualifiers
  var explicit = false
  var framework = false

  // Attributes
  var system = false
  var externC = false
  var noUndeclaredIncludes = false

  // Module members
  // var members = [ModuleMember]()
}

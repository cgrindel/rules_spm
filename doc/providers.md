<!-- Generated with Stardoc, Do Not Edit! -->
# `providers` API


<a id="#providers.clang_module"></a>

## providers.clang_module

<pre>
providers.clang_module(<a href="#providers.clang_module-module_name">module_name</a>, <a href="#providers.clang_module-o_files">o_files</a>, <a href="#providers.clang_module-hdrs">hdrs</a>, <a href="#providers.clang_module-modulemap">modulemap</a>, <a href="#providers.clang_module-all_outputs">all_outputs</a>)
</pre>

Creates a value representing the Clang module that is built from a package.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="providers.clang_module-module_name"></a>module_name |  Name of the Swift module.   |  none |
| <a id="providers.clang_module-o_files"></a>o_files |  The Mach-O files that are built by SPM.   |  <code>[]</code> |
| <a id="providers.clang_module-hdrs"></a>hdrs |  The header files.   |  <code>[]</code> |
| <a id="providers.clang_module-modulemap"></a>modulemap |  A modulemap struct.   |  <code>None</code> |
| <a id="providers.clang_module-all_outputs"></a>all_outputs |  All of the output files that are declared for the module.   |  <code>[]</code> |

**RETURNS**

A struct which provides info about a clang module build by SPM.


<a id="#providers.copy_info"></a>

## providers.copy_info

<pre>
providers.copy_info(<a href="#providers.copy_info-src">src</a>, <a href="#providers.copy_info-dest">dest</a>)
</pre>

Creates a value describing a copy operation.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="providers.copy_info-src"></a>src |  The source file.   |  none |
| <a id="providers.copy_info-dest"></a>dest |  The destination file.   |  none |

**RETURNS**

A struct describing a copy operation performed during the SPM build.


<a id="#providers.swift_binary"></a>

## providers.swift_binary

<pre>
providers.swift_binary(<a href="#providers.swift_binary-name">name</a>, <a href="#providers.swift_binary-executable">executable</a>, <a href="#providers.swift_binary-all_outputs">all_outputs</a>)
</pre>

Creates a value representing a Swift binary that is built from a package.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="providers.swift_binary-name"></a>name |  Name of the Swift binary.   |  none |
| <a id="providers.swift_binary-executable"></a>executable |  The executable.   |  <code>None</code> |
| <a id="providers.swift_binary-all_outputs"></a>all_outputs |  All of the output files that are declared for the module.   |  <code>[]</code> |

**RETURNS**

A struct which provides info about a Swift binary built by SPM.


<a id="#providers.swift_module"></a>

## providers.swift_module

<pre>
providers.swift_module(<a href="#providers.swift_module-module_name">module_name</a>, <a href="#providers.swift_module-o_files">o_files</a>, <a href="#providers.swift_module-swiftdoc">swiftdoc</a>, <a href="#providers.swift_module-swiftmodule">swiftmodule</a>, <a href="#providers.swift_module-swiftsourceinfo">swiftsourceinfo</a>, <a href="#providers.swift_module-executable">executable</a>,
                       <a href="#providers.swift_module-all_outputs">all_outputs</a>)
</pre>

Creates a value representing the Swift module that is built from a package.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="providers.swift_module-module_name"></a>module_name |  Name of the Swift module.   |  none |
| <a id="providers.swift_module-o_files"></a>o_files |  The Mach-O files that are built by SPM.   |  <code>[]</code> |
| <a id="providers.swift_module-swiftdoc"></a>swiftdoc |  The .swiftdoc file that is built by SPM.   |  <code>None</code> |
| <a id="providers.swift_module-swiftmodule"></a>swiftmodule |  The .swiftmodule file that is built by SPM.   |  <code>None</code> |
| <a id="providers.swift_module-swiftsourceinfo"></a>swiftsourceinfo |  The .swiftsourceinfo file that is built by SPM.   |  <code>None</code> |
| <a id="providers.swift_module-executable"></a>executable |  The executable if the target is executable.   |  <code>None</code> |
| <a id="providers.swift_module-all_outputs"></a>all_outputs |  All of the output files that are declared for the module.   |  <code>[]</code> |

**RETURNS**

A struct which provides info about a Swift module built by SPM.


<a id="#providers.system_library_module"></a>

## providers.system_library_module

<pre>
providers.system_library_module(<a href="#providers.system_library_module-module_name">module_name</a>, <a href="#providers.system_library_module-c_files">c_files</a>, <a href="#providers.system_library_module-hdrs">hdrs</a>, <a href="#providers.system_library_module-modulemap">modulemap</a>, <a href="#providers.system_library_module-all_outputs">all_outputs</a>)
</pre>

Creates a value representing the system library module that is built from a package.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="providers.system_library_module-module_name"></a>module_name |  Name of the Swift module.   |  none |
| <a id="providers.system_library_module-c_files"></a>c_files |  The C source files that are part of the system library definition.   |  <code>[]</code> |
| <a id="providers.system_library_module-hdrs"></a>hdrs |  The header files.   |  <code>[]</code> |
| <a id="providers.system_library_module-modulemap"></a>modulemap |  The module.modulemap file for the system library module.   |  <code>None</code> |
| <a id="providers.system_library_module-all_outputs"></a>all_outputs |  All of the output files that are declared for the module.   |  <code>[]</code> |

**RETURNS**

A struct which provides info about a system library module.



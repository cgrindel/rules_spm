<!-- Generated with Stardoc, Do Not Edit! -->
# `bazel_build_declarations` API


<a id="#bazel_build_declarations.swift_library"></a>

## bazel_build_declarations.swift_library

<pre>
bazel_build_declarations.swift_library(<a href="#bazel_build_declarations.swift_library-pkg_name">pkg_name</a>, <a href="#bazel_build_declarations.swift_library-target">target</a>, <a href="#bazel_build_declarations.swift_library-target_deps">target_deps</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="bazel_build_declarations.swift_library-pkg_name"></a>pkg_name |  <p align="center"> - </p>   |  none |
| <a id="bazel_build_declarations.swift_library-target"></a>target |  <p align="center"> - </p>   |  none |
| <a id="bazel_build_declarations.swift_library-target_deps"></a>target_deps |  <p align="center"> - </p>   |  none |


<a id="#bazel_build_declarations.swift_binary"></a>

## bazel_build_declarations.swift_binary

<pre>
bazel_build_declarations.swift_binary(<a href="#bazel_build_declarations.swift_binary-pkg_name">pkg_name</a>, <a href="#bazel_build_declarations.swift_binary-product">product</a>, <a href="#bazel_build_declarations.swift_binary-target">target</a>, <a href="#bazel_build_declarations.swift_binary-target_deps">target_deps</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="bazel_build_declarations.swift_binary-pkg_name"></a>pkg_name |  <p align="center"> - </p>   |  none |
| <a id="bazel_build_declarations.swift_binary-product"></a>product |  <p align="center"> - </p>   |  none |
| <a id="bazel_build_declarations.swift_binary-target"></a>target |  <p align="center"> - </p>   |  none |
| <a id="bazel_build_declarations.swift_binary-target_deps"></a>target_deps |  <p align="center"> - </p>   |  none |


<a id="#bazel_build_declarations.clang_library"></a>

## bazel_build_declarations.clang_library

<pre>
bazel_build_declarations.clang_library(<a href="#bazel_build_declarations.clang_library-repository_ctx">repository_ctx</a>, <a href="#bazel_build_declarations.clang_library-pkg_name">pkg_name</a>, <a href="#bazel_build_declarations.clang_library-target">target</a>, <a href="#bazel_build_declarations.clang_library-target_deps">target_deps</a>)
</pre>

Generates a build declaration for clang libraries and system libraries.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="bazel_build_declarations.clang_library-repository_ctx"></a>repository_ctx |  An instance of <code>repository_ctx</code>.   |  none |
| <a id="bazel_build_declarations.clang_library-pkg_name"></a>pkg_name |  The name of the package as a <code>string</code>.   |  none |
| <a id="bazel_build_declarations.clang_library-target"></a>target |  The target <code>dict</code>.   |  none |
| <a id="bazel_build_declarations.clang_library-target_deps"></a>target_deps |  The dependencies for the target as a <code>list</code> of target references.   |  none |

**RETURNS**

A build declaration `struct` as returned by `build_declarations.create`.



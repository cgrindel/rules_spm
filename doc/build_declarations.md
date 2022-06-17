<!-- Generated with Stardoc, Do Not Edit! -->
# `build_declarations` API


<a id="#build_declarations.target"></a>

## build_declarations.target

<pre>
build_declarations.target(<a href="#build_declarations.target-type">type</a>, <a href="#build_declarations.target-name">name</a>, <a href="#build_declarations.target-declaration">declaration</a>)
</pre>

Create a target `struct`.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="build_declarations.target-type"></a>type |  A <code>string</code> specifying the rule/macro type.   |  none |
| <a id="build_declarations.target-name"></a>name |  A <code>string</code> representing the target name.   |  none |
| <a id="build_declarations.target-declaration"></a>declaration |  The Starlark code for the declaration as a <code>string</code>.   |  none |

**RETURNS**

A `struct` that represents a target declaration in a build file.


<a id="#build_declarations.load_statement"></a>

## build_declarations.load_statement

<pre>
build_declarations.load_statement(<a href="#build_declarations.load_statement-location">location</a>, <a href="#build_declarations.load_statement-symbols">symbols</a>)
</pre>

Create a load statement `struct`.

The list of symbols will be sorted and uniquified.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="build_declarations.load_statement-location"></a>location |  A <code>string</code> representing the location of a Starlark file.   |  none |
| <a id="build_declarations.load_statement-symbols"></a>symbols |  A <code>sequence</code> of symbols to be loaded from the location.   |  none |

**RETURNS**

A `struct` that includes the location and the cleaned up symbols.


<a id="#build_declarations.create"></a>

## build_declarations.create

<pre>
build_declarations.create(<a href="#build_declarations.create-load_statements">load_statements</a>, <a href="#build_declarations.create-targets">targets</a>)
</pre>

Create a `struct` that represents the parts of a Bazel build file.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="build_declarations.create-load_statements"></a>load_statements |  A <code>list</code> of load statement <code>struct</code> values as returned by <code>build_declarations.load_statement</code>.   |  <code>[]</code> |
| <a id="build_declarations.create-targets"></a>targets |  A <code>list</code> of target <code>struct</code> values as returned by <code>build_declarations.target</code>.   |  <code>[]</code> |

**RETURNS**

A `struct` representing parts of a Bazel  build file.


<a id="#build_declarations.merge"></a>

## build_declarations.merge

<pre>
build_declarations.merge(<a href="#build_declarations.merge-build_decls">build_decls</a>)
</pre>

Merge build file `struct` values into a single value.

The load statements will be sorted and deduped. The targets will be sorted
by type and name.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="build_declarations.merge-build_decls"></a>build_decls |  A <code>sequence</code> of build file declaration <code>struct</code> values as returned by <code>build_declarations.create</code>.   |  none |

**RETURNS**

A merged build file declaration `struct`.


<a id="#build_declarations.generate_build_file_content"></a>

## build_declarations.generate_build_file_content

<pre>
build_declarations.generate_build_file_content(<a href="#build_declarations.generate_build_file_content-build_decl">build_decl</a>)
</pre>

Generate Bazel build file content from a build file declaration `struct`.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="build_declarations.generate_build_file_content-build_decl"></a>build_decl |  A build file declaration <code>struct</code> as returned by <code>build_declarations.create</code>.   |  none |

**RETURNS**

A `string` containing valid Starlark code that can be used as Bazel
  build file content.


<a id="#build_declarations.write_build_file"></a>

## build_declarations.write_build_file

<pre>
build_declarations.write_build_file(<a href="#build_declarations.write_build_file-repository_ctx">repository_ctx</a>, <a href="#build_declarations.write_build_file-path">path</a>, <a href="#build_declarations.write_build_file-build_decl">build_decl</a>)
</pre>

Write a Bazel build file from a build declaration.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="build_declarations.write_build_file-repository_ctx"></a>repository_ctx |  A Bazel <code>repository_ctx</code> instance.   |  none |
| <a id="build_declarations.write_build_file-path"></a>path |  The path where to write the build file content as a <code>string</code>.   |  none |
| <a id="build_declarations.write_build_file-build_decl"></a>build_decl |  A build declaration <code>struct</code> as returned by <code>build_declarations.create</code>.   |  none |


<a id="#build_declarations.bazel_list_str"></a>

## build_declarations.bazel_list_str

<pre>
build_declarations.bazel_list_str(<a href="#build_declarations.bazel_list_str-values">values</a>, <a href="#build_declarations.bazel_list_str-double_quote_values">double_quote_values</a>, <a href="#build_declarations.bazel_list_str-indent">indent</a>)
</pre>

Create a `string` of values that is suitable to be inserted in a Starlark list.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="build_declarations.bazel_list_str-values"></a>values |  A <code>sequence</code> of <code>string</code> values.   |  none |
| <a id="build_declarations.bazel_list_str-double_quote_values"></a>double_quote_values |  A <code>bool</code> indicating whether to add double quotes.   |  <code>True</code> |
| <a id="build_declarations.bazel_list_str-indent"></a>indent |  A <code>string</code> representing the characters to prefix for each value.   |  <code>"        "</code> |

**RETURNS**

A `string` value suitable to be inserted between square brackets ([])
  as Starlark list values.


<a id="#build_declarations.bazel_deps_str"></a>

## build_declarations.bazel_deps_str

<pre>
build_declarations.bazel_deps_str(<a href="#build_declarations.bazel_deps_str-pkg_name">pkg_name</a>, <a href="#build_declarations.bazel_deps_str-target_deps">target_deps</a>)
</pre>

Create deps list string suitable for injection into a module template.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="build_declarations.bazel_deps_str-pkg_name"></a>pkg_name |  The name of the Swift package as a <code>string</code>.   |  none |
| <a id="build_declarations.bazel_deps_str-target_deps"></a>target_deps |  A <code>list</code> of the target's dependencies as target references (<code>references.create_target_ref()</code>).   |  none |

**RETURNS**

A `string` value.


<a id="#build_declarations.quote_str"></a>

## build_declarations.quote_str

<pre>
build_declarations.quote_str(<a href="#build_declarations.quote_str-value">value</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="build_declarations.quote_str-value"></a>value |  <p align="center"> - </p>   |  none |



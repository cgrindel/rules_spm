<!-- Generated with Stardoc, Do Not Edit! -->
# `clang_files` API


<a id="clang_files.is_hdr"></a>

## clang_files.is_hdr

<pre>
clang_files.is_hdr(<a href="#clang_files.is_hdr-path">path</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="clang_files.is_hdr-path"></a>path |  <p align="center"> - </p>   |  none |


<a id="clang_files.is_include_hdr"></a>

## clang_files.is_include_hdr

<pre>
clang_files.is_include_hdr(<a href="#clang_files.is_include_hdr-path">path</a>, <a href="#clang_files.is_include_hdr-public_includes">public_includes</a>)
</pre>

Determines whether the path is a public header.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="clang_files.is_include_hdr-path"></a>path |  A path <code>string</code> value.   |  none |
| <a id="clang_files.is_include_hdr-public_includes"></a>public_includes |  Optional. A <code>sequence</code> of path <code>string</code> values that are used to identify public header files.   |  <code>None</code> |

**RETURNS**

A `bool` indicating whether the path is a public header.


<a id="clang_files.is_public_modulemap"></a>

## clang_files.is_public_modulemap

<pre>
clang_files.is_public_modulemap(<a href="#clang_files.is_public_modulemap-path">path</a>)
</pre>

Determines whether the specified path is to a public `module.modulemap` file.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="clang_files.is_public_modulemap-path"></a>path |  A path <code>string</code>.   |  none |

**RETURNS**

A `bool` indicating whether the path is a public `module.modulemap`
  file.


<a id="clang_files.collect_files"></a>

## clang_files.collect_files

<pre>
clang_files.collect_files(<a href="#clang_files.collect_files-repository_ctx">repository_ctx</a>, <a href="#clang_files.collect_files-root_paths">root_paths</a>, <a href="#clang_files.collect_files-public_includes">public_includes</a>, <a href="#clang_files.collect_files-remove_prefix">remove_prefix</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="clang_files.collect_files-repository_ctx"></a>repository_ctx |  <p align="center"> - </p>   |  none |
| <a id="clang_files.collect_files-root_paths"></a>root_paths |  <p align="center"> - </p>   |  none |
| <a id="clang_files.collect_files-public_includes"></a>public_includes |  <p align="center"> - </p>   |  <code>None</code> |
| <a id="clang_files.collect_files-remove_prefix"></a>remove_prefix |  <p align="center"> - </p>   |  <code>None</code> |


<a id="clang_files.get_hdr_paths_from_modulemap"></a>

## clang_files.get_hdr_paths_from_modulemap

<pre>
clang_files.get_hdr_paths_from_modulemap(<a href="#clang_files.get_hdr_paths_from_modulemap-repository_ctx">repository_ctx</a>, <a href="#clang_files.get_hdr_paths_from_modulemap-modulemap_path">modulemap_path</a>)
</pre>

Retrieves the list of headers declared in the specified modulemap file.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="clang_files.get_hdr_paths_from_modulemap-repository_ctx"></a>repository_ctx |  A <code>repository_ctx</code> instance.   |  none |
| <a id="clang_files.get_hdr_paths_from_modulemap-modulemap_path"></a>modulemap_path |  A path <code>string</code> to the <code>module.modulemap</code> file.   |  none |

**RETURNS**

A `list` of path `string` values.



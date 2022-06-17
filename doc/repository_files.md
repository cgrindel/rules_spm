<!-- Generated with Stardoc, Do Not Edit! -->
# `repository_files` API


<a id="#repository_files.list_files_under"></a>

## repository_files.list_files_under

<pre>
repository_files.list_files_under(<a href="#repository_files.list_files_under-repository_ctx">repository_ctx</a>, <a href="#repository_files.list_files_under-path">path</a>)
</pre>

Retrieves the list of files under the specified path.

This function returns paths for all of the files under the specified path.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="repository_files.list_files_under-repository_ctx"></a>repository_ctx |  A <code>repository_ctx</code> instance.   |  none |
| <a id="repository_files.list_files_under-path"></a>path |  A path <code>string</code> value.   |  none |

**RETURNS**

A `list` of path `string` values.


<a id="#repository_files.list_directories_under"></a>

## repository_files.list_directories_under

<pre>
repository_files.list_directories_under(<a href="#repository_files.list_directories_under-repository_ctx">repository_ctx</a>, <a href="#repository_files.list_directories_under-path">path</a>, <a href="#repository_files.list_directories_under-max_depth">max_depth</a>)
</pre>

Retrieves the list of directories under the specified path.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="repository_files.list_directories_under-repository_ctx"></a>repository_ctx |  A <code>repository_ctx</code> instance.   |  none |
| <a id="repository_files.list_directories_under-path"></a>path |  A path <code>string</code> value.   |  none |
| <a id="repository_files.list_directories_under-max_depth"></a>max_depth |  Optional. The depth for the directory search.   |  <code>None</code> |

**RETURNS**

A `list` of path `string` values.


<a id="#repository_files.find_and_delete_files"></a>

## repository_files.find_and_delete_files

<pre>
repository_files.find_and_delete_files(<a href="#repository_files.find_and_delete_files-repository_ctx">repository_ctx</a>, <a href="#repository_files.find_and_delete_files-path">path</a>, <a href="#repository_files.find_and_delete_files-name">name</a>)
</pre>

Finds files with the specified name under the specified path and deletes them.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="repository_files.find_and_delete_files-repository_ctx"></a>repository_ctx |  A <code>repository_ctx</code> instance.   |  none |
| <a id="repository_files.find_and_delete_files-path"></a>path |  A path <code>string</code> value.   |  none |
| <a id="repository_files.find_and_delete_files-name"></a>name |  A file basename as a <code>string</code>.   |  none |


<a id="#repository_files.copy_directory"></a>

## repository_files.copy_directory

<pre>
repository_files.copy_directory(<a href="#repository_files.copy_directory-repository_ctx">repository_ctx</a>, <a href="#repository_files.copy_directory-src">src</a>, <a href="#repository_files.copy_directory-dest">dest</a>)
</pre>

Copy a directory.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="repository_files.copy_directory-repository_ctx"></a>repository_ctx |  An instance of <code>repository_ctx</code>.   |  none |
| <a id="repository_files.copy_directory-src"></a>src |  The path to the direcotry to copy as a <code>string</code>.   |  none |
| <a id="repository_files.copy_directory-dest"></a>dest |  The path where the directory will be copied as a <code>string</code>.   |  none |



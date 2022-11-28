<!-- Generated with Stardoc, Do Not Edit! -->
# `resolved_packages` API


<a id="resolved_packages.state"></a>

## resolved_packages.state

<pre>
resolved_packages.state(<a href="#resolved_packages.state-revision">revision</a>, <a href="#resolved_packages.state-version">version</a>, <a href="#resolved_packages.state-branch">branch</a>)
</pre>

Create a state `struct`

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="resolved_packages.state-revision"></a>revision |  A UUID <code>string</code>.   |  none |
| <a id="resolved_packages.state-version"></a>version |  A semver <code>string</code>.   |  none |
| <a id="resolved_packages.state-branch"></a>branch |  Optional. A branch name as a <code>string</code>.   |  <code>None</code> |

**RETURNS**

A `struct` value.


<a id="resolved_packages.create"></a>

## resolved_packages.create

<pre>
resolved_packages.create(<a href="#resolved_packages.create-name">name</a>, <a href="#resolved_packages.create-url">url</a>, <a href="#resolved_packages.create-state">state</a>)
</pre>

Create a resolved package `struct`.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="resolved_packages.create-name"></a>name |  The name of the package as a <code>string</code>.   |  none |
| <a id="resolved_packages.create-url"></a>url |  The URL for the package as a <code>string</code>.   |  none |
| <a id="resolved_packages.create-state"></a>state |  A state <code>struct</code> as created by 'resolved_packages.state'.   |  none |

**RETURNS**

A `struct` value.


<a id="resolved_packages.read"></a>

## resolved_packages.read

<pre>
resolved_packages.read(<a href="#resolved_packages.read-repository_ctx">repository_ctx</a>, <a href="#resolved_packages.read-path">path</a>)
</pre>

Read the specified `Package.resolved` file and return a `dict` of resolved package `struct` values.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="resolved_packages.read-repository_ctx"></a>repository_ctx |  A <code>repository_ctx</code> instance.   |  none |
| <a id="resolved_packages.read-path"></a>path |  Optional. The path to the file as a <code>string</code>.   |  <code>"Package.resolved"</code> |

**RETURNS**

A `dict` where the key is the package name and the value is a resolved
  package `struct`.


<a id="resolved_packages.parse_json"></a>

## resolved_packages.parse_json

<pre>
resolved_packages.parse_json(<a href="#resolved_packages.parse_json-json_str">json_str</a>)
</pre>

Parse the JSON `string` returning a `dict` where the key is the name and the value is a resolved package `struct`.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="resolved_packages.parse_json-json_str"></a>json_str |  A JSON <code>string</code> from a <code>Package.resolved</code> file.   |  none |

**RETURNS**

A `dict` where the key is the package name and the value is a resolved
  package `struct`.



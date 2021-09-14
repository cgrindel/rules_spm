<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#packages.create_name"></a>

## packages.create_name

<pre>
packages.create_name(<a href="#packages.create_name-url">url</a>)
</pre>

Create a package name (i.e. repository name) from the provided URL.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="packages.create_name-url"></a>url |  A URL <code>string</code>.   |  none |


<a id="#packages.create"></a>

## packages.create

<pre>
packages.create(<a href="#packages.create-url">url</a>, <a href="#packages.create-path">path</a>, <a href="#packages.create-name">name</a>, <a href="#packages.create-from_version">from_version</a>, <a href="#packages.create-revision">revision</a>, <a href="#packages.create-products">products</a>)
</pre>

Create a Swift package dependency struct.

See the Swift Package Manager documentation for information on the various
requirement specifications.

https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html#package-dependency


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="packages.create-url"></a>url |  A <code>string</code> representing the URL for the package repository.   |  <code>None</code> |
| <a id="packages.create-path"></a>path |  A local path <code>string</code> to the package repository.   |  <code>None</code> |
| <a id="packages.create-name"></a>name |  Optional. The name (<code>string</code>) to be used for the package in Package.swift.   |  <code>None</code> |
| <a id="packages.create-from_version"></a>from_version |  Optional. A <code>string</code> representing a valid "from" SPM version.   |  <code>None</code> |
| <a id="packages.create-revision"></a>revision |  Optional. A commit hash (<code>string</code>).   |  <code>None</code> |
| <a id="packages.create-products"></a>products |  A <code>list</code> of <code>string</code> values representing the names of the products to be used.   |  <code>[]</code> |


<a id="#packages.copy"></a>

## packages.copy

<pre>
packages.copy(<a href="#packages.copy-pkg">pkg</a>, <a href="#packages.copy-url">url</a>, <a href="#packages.copy-path">path</a>, <a href="#packages.copy-name">name</a>, <a href="#packages.copy-from_version">from_version</a>, <a href="#packages.copy-revision">revision</a>, <a href="#packages.copy-products">products</a>)
</pre>

Create a copy of the provided package replacing any of the argument values that are not None.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="packages.copy-pkg"></a>pkg |  A <code>struct</code> representing a Swift package.   |  none |
| <a id="packages.copy-url"></a>url |  Optional. A <code>string</code> representing the URL for the package repository.   |  <code>None</code> |
| <a id="packages.copy-path"></a>path |  Optional. A local path <code>string</code> to the package repository.   |  <code>None</code> |
| <a id="packages.copy-name"></a>name |  Optional. The name (<code>string</code>) to be used for the package in Package.swift.   |  <code>None</code> |
| <a id="packages.copy-from_version"></a>from_version |  Optional. A <code>string</code> representing a valid "from" SPM version.   |  <code>None</code> |
| <a id="packages.copy-revision"></a>revision |  Optional. A commit hash (<code>string</code>).   |  <code>None</code> |
| <a id="packages.copy-products"></a>products |  Optional. jA <code>list</code> of <code>string</code> values representing the names of the products to be used.   |  <code>None</code> |


<a id="#packages.pkg_json"></a>

## packages.pkg_json

<pre>
packages.pkg_json(<a href="#packages.pkg_json-url">url</a>, <a href="#packages.pkg_json-path">path</a>, <a href="#packages.pkg_json-name">name</a>, <a href="#packages.pkg_json-from_version">from_version</a>, <a href="#packages.pkg_json-revision">revision</a>, <a href="#packages.pkg_json-products">products</a>)
</pre>

Returns a JSON string describing a Swift package.

See the Swift Package Manager documentation for information on the various
requirement specifications.

https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html#package-dependency


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="packages.pkg_json-url"></a>url |  A <code>string</code> representing the URL for the package repository.   |  <code>None</code> |
| <a id="packages.pkg_json-path"></a>path |  A local path <code>string</code> to the package repository.   |  <code>None</code> |
| <a id="packages.pkg_json-name"></a>name |  Optional. The name (<code>string</code>) to be used for the package in Package.swift.   |  <code>None</code> |
| <a id="packages.pkg_json-from_version"></a>from_version |  Optional. A <code>string</code> representing a valid "from" SPM version.   |  <code>None</code> |
| <a id="packages.pkg_json-revision"></a>revision |  Optional. A commit hash (<code>string</code>).   |  <code>None</code> |
| <a id="packages.pkg_json-products"></a>products |  A <code>list</code> of <code>string</code> values representing the names of the products to be used.   |  <code>[]</code> |


<a id="#packages.from_json"></a>

## packages.from_json

<pre>
packages.from_json(<a href="#packages.from_json-json_str">json_str</a>)
</pre>

Creates a package struct(s) as described in the provided JSON string.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="packages.from_json-json_str"></a>json_str |  A JSON <code>string</code> that describes a package as declared in the <code>dependencies</code> attribute for a <code>spm_repositories</code> rule.   |  none |


<a id="#packages.get_pkg"></a>

## packages.get_pkg

<pre>
packages.get_pkg(<a href="#packages.get_pkg-pkgs">pkgs</a>, <a href="#packages.get_pkg-pkg_name">pkg_name</a>)
</pre>

Returns the package declaration from a list of package declarations.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="packages.get_pkg-pkgs"></a>pkgs |  A <code>list</code> of package declarations (<code>struct</code>) as created by <code>packages.create()</code>, <code>packages.pkg_json()</code> or <code>spm_pkg()</code>.   |  none |
| <a id="packages.get_pkg-pkg_name"></a>pkg_name |  A <code>string</code> representing the name of the Swift package.   |  none |


<a id="#packages.get_product_refs"></a>

## packages.get_product_refs

<pre>
packages.get_product_refs(<a href="#packages.get_product_refs-pkgs">pkgs</a>)
</pre>

Returns a list of product references as declared in the specified packages list.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="packages.get_product_refs-pkgs"></a>pkgs |  A <code>list</code> of package declarations (<code>struct</code>) as created by <code>packages.create()</code>, <code>packages.pkg_json()</code> or <code>spm_pkg()</code>.   |  none |



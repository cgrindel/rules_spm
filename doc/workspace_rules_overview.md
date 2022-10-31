<!-- Generated with Stardoc, Do Not Edit! -->
# Workspace Rules

The rules and functions described below are used in your WORKSPACE file to
confgure `rules_spm` and to declare the Swift packages that are dependencies
of your project.

On this page:

  * [spm_repositories](#spm_repositories)
  * [spm_pkg](#spm_pkg)


<a id="#spm_repositories"></a>

## spm_repositories

<pre>
spm_repositories(<a href="#spm_repositories-name">name</a>, <a href="#spm_repositories-build_mode">build_mode</a>, <a href="#spm_repositories-dependencies">dependencies</a>, <a href="#spm_repositories-env">env</a>, <a href="#spm_repositories-platforms">platforms</a>, <a href="#spm_repositories-repo_mapping">repo_mapping</a>, <a href="#spm_repositories-swift_version">swift_version</a>)
</pre>

Used to fetch and prepare external Swift package manager packages for the build.


**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="spm_repositories-name"></a>name |  A unique name for this repository.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="spm_repositories-build_mode"></a>build_mode |  Experimental. This functionality is not fully baked. Please do not rely on this.<br><br>Specifies how <code>rules_spm</code> will build the Swift packages.<br><br>  <code>spm</code>: Build the packages with Swift Package Manager and generate Bazel targets           that import the results.   <code>bazel</code>: Generate Bazel targets that build the packages.   | String | optional | "spm" |
| <a id="spm_repositories-dependencies"></a>dependencies |  List of JSON strings specifying the SPM packages to load.   | List of strings | required |  |
| <a id="spm_repositories-env"></a>env |  Environment variables that will be passed to the execution environments for this repository rule. (e.g. SPM version check, SPM dependency resolution, SPM package description generation)   | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional | {} |
| <a id="spm_repositories-platforms"></a>platforms |  The platforms to declare in the placeholder/uber Swift package. (e.g. .macOS(.v10_15))   | List of strings | optional | [] |
| <a id="spm_repositories-repo_mapping"></a>repo_mapping |  A dictionary from local repository name to global repository name. This allows controls over workspace dependency resolution for dependencies of this repository.&lt;p&gt;For example, an entry <code>"@foo": "@bar"</code> declares that, for any time this repository depends on <code>@foo</code> (such as a dependency on <code>@foo//some:target</code>, it should actually resolve that dependency within globally-declared <code>@bar</code> (<code>@bar//some:target</code>).   | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | required |  |
| <a id="spm_repositories-swift_version"></a>swift_version |  The version of Swift that will be declared in the placeholder/uber Swift package.   | String | optional | "5.3" |


<a id="#spm_pkg"></a>

## spm_pkg

<pre>
spm_pkg(<a href="#spm_pkg-url">url</a>, <a href="#spm_pkg-path">path</a>, <a href="#spm_pkg-name">name</a>, <a href="#spm_pkg-exact_version">exact_version</a>, <a href="#spm_pkg-from_version">from_version</a>, <a href="#spm_pkg-revision">revision</a>, <a href="#spm_pkg-products">products</a>)
</pre>

Returns a JSON string describing a Swift package.

See the Swift Package Manager documentation for information on the various
requirement specifications.

https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html#package-dependency


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="spm_pkg-url"></a>url |  A <code>string</code> representing the URL for the package repository.   |  <code>None</code> |
| <a id="spm_pkg-path"></a>path |  A local path <code>string</code> to the package repository.   |  <code>None</code> |
| <a id="spm_pkg-name"></a>name |  Optional. The name (<code>string</code>) to be used for the package in Package.swift.   |  <code>None</code> |
| <a id="spm_pkg-exact_version"></a>exact_version |  Optional. A <code>string</code> representing a valid "exact" SPM version.   |  <code>None</code> |
| <a id="spm_pkg-from_version"></a>from_version |  Optional. A <code>string</code> representing a valid "from" SPM version.   |  <code>None</code> |
| <a id="spm_pkg-revision"></a>revision |  Optional. A commit hash (<code>string</code>).   |  <code>None</code> |
| <a id="spm_pkg-products"></a>products |  A <code>list</code> of <code>string</code> values representing the names of the products to be used.   |  <code>[]</code> |

**RETURNS**

A JSON `string` representing a Swift package.



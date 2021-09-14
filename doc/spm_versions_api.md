<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#spm_archive"></a>

## spm_archive

<pre>
spm_archive(<a href="#spm_archive-name">name</a>, <a href="#spm_archive-o_files">o_files</a>)
</pre>

Combines object files (.o) into an archive file (.a).


**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="spm_archive-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="spm_archive-o_files"></a>o_files |  The object files to be combined into the clang archive using the ar tool.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |


<a id="#spm_filegroup"></a>

## spm_filegroup

<pre>
spm_filegroup(<a href="#spm_filegroup-name">name</a>, <a href="#spm_filegroup-file_type">file_type</a>, <a href="#spm_filegroup-module_name">module_name</a>, <a href="#spm_filegroup-package_name">package_name</a>, <a href="#spm_filegroup-packages">packages</a>)
</pre>

Exposes the specified type of file(s) from a rule that outputs an SPMPackagesInfo (e.g.  spm_package).

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="spm_filegroup-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="spm_filegroup-file_type"></a>file_type |  The type of file to expose about the module.   | String | required |  |
| <a id="spm_filegroup-module_name"></a>module_name |  The name of the module in the SPM package to select for file exposition.   | String | required |  |
| <a id="spm_filegroup-package_name"></a>package_name |  The name of the package that exports this module. If no value provided, it will be derived from the Bazel package name.   | String | optional | "" |
| <a id="spm_filegroup-packages"></a>packages |  A target that outputs an SPMPackagesInfo (e.g. spm_pacakge).   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |


<a id="#spm_package"></a>

## spm_package

<pre>
spm_package(<a href="#spm_package-name">name</a>, <a href="#spm_package-clang_module_headers">clang_module_headers</a>, <a href="#spm_package-configuration">configuration</a>, <a href="#spm_package-dependencies_json">dependencies_json</a>, <a href="#spm_package-package_descriptions_json">package_descriptions_json</a>,
            <a href="#spm_package-package_path">package_path</a>, <a href="#spm_package-srcs">srcs</a>)
</pre>

Builds the specified Swift package.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="spm_package-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="spm_package-clang_module_headers"></a>clang_module_headers |  A <code>dict</code> where the keys are target names and the values are public header paths.   | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> List of strings</a> | optional | {} |
| <a id="spm_package-configuration"></a>configuration |  The configuration to use when executing swift build (e.g. debug, release).   | String | optional | "release" |
| <a id="spm_package-dependencies_json"></a>dependencies_json |  "JSON string describing the dependencies to expose (e.g. see dependencies in spm_repositories)   | String | required |  |
| <a id="spm_package-package_descriptions_json"></a>package_descriptions_json |  JSON string which describes the package (i.e. swift package describe --type json).   | String | required |  |
| <a id="spm_package-package_path"></a>package_path |  Directory which contains the Package.swift (i.e. swift build --package-path VALUE).   | String | optional | "" |
| <a id="spm_package-srcs"></a>srcs |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | required |  |


<a id="#spm_repositories"></a>

## spm_repositories

<pre>
spm_repositories(<a href="#spm_repositories-name">name</a>, <a href="#spm_repositories-dependencies">dependencies</a>, <a href="#spm_repositories-platforms">platforms</a>, <a href="#spm_repositories-repo_mapping">repo_mapping</a>, <a href="#spm_repositories-swift_version">swift_version</a>)
</pre>

Used to fetch and prepare external Swift package manager packages for the build.


**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="spm_repositories-name"></a>name |  A unique name for this repository.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="spm_repositories-dependencies"></a>dependencies |  List of JSON strings specifying the SPM packages to load.   | List of strings | required |  |
| <a id="spm_repositories-platforms"></a>platforms |  The platforms to declare in the placeholder/uber Swift package. (e.g. .macOS(.v10_15))   | List of strings | optional | [] |
| <a id="spm_repositories-repo_mapping"></a>repo_mapping |  A dictionary from local repository name to global repository name. This allows controls over workspace dependency resolution for dependencies of this repository.&lt;p&gt;For example, an entry <code>"@foo": "@bar"</code> declares that, for any time this repository depends on <code>@foo</code> (such as a dependency on <code>@foo//some:target</code>, it should actually resolve that dependency within globally-declared <code>@bar</code> (<code>@bar//some:target</code>).   | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | required |  |
| <a id="spm_repositories-swift_version"></a>swift_version |  The version of Swift that will be declared in the placeholder/uber Swift package.   | String | optional | "5.3" |


<a id="#spm_swift_binary"></a>

## spm_swift_binary

<pre>
spm_swift_binary(<a href="#spm_swift_binary-name">name</a>, <a href="#spm_swift_binary-module_name">module_name</a>, <a href="#spm_swift_binary-package_name">package_name</a>, <a href="#spm_swift_binary-packages">packages</a>)
</pre>

Exposes a Swift binary from a Swift package.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="spm_swift_binary-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="spm_swift_binary-module_name"></a>module_name |  The name of the executable module in the SPM package. If no value is provided, it will be derived from the name attribute.   | String | optional | "" |
| <a id="spm_swift_binary-package_name"></a>package_name |  The name of the package that exports this module. If no value  provided, it will be derived from the Bazel package name.   | String | optional | "" |
| <a id="spm_swift_binary-packages"></a>packages |  A target that outputs an SPMPackagesInfo (e.g. spm_pacakge).   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |


<a id="#SPMBuildInfo"></a>

## SPMBuildInfo

<pre>
SPMBuildInfo(<a href="#SPMBuildInfo-build_tool">build_tool</a>, <a href="#SPMBuildInfo-sdk_name">sdk_name</a>, <a href="#SPMBuildInfo-target_triple">target_triple</a>, <a href="#SPMBuildInfo-spm_platform_info">spm_platform_info</a>, <a href="#SPMBuildInfo-swift_executable">swift_executable</a>)
</pre>

Information about how to invoke the Swift package manager.

**FIELDS**


| Name  | Description |
| :------------- | :------------- |
| <a id="SPMBuildInfo-build_tool"></a>build_tool |  The executable that will be used to build the Swift package.    |
| <a id="SPMBuildInfo-sdk_name"></a>sdk_name |  A string representing the name of the SDK    |
| <a id="SPMBuildInfo-target_triple"></a>target_triple |  A string representing the target platform as a triple.    |
| <a id="SPMBuildInfo-spm_platform_info"></a>spm_platform_info |  An <code>SpmPlatformInfo</code> describing the target platform.    |
| <a id="SPMBuildInfo-swift_executable"></a>swift_executable |  The path for the <code>swift</code> executable.    |


<a id="#SPMPackageInfo"></a>

## SPMPackageInfo

<pre>
SPMPackageInfo(<a href="#SPMPackageInfo-name">name</a>, <a href="#SPMPackageInfo-swift_modules">swift_modules</a>, <a href="#SPMPackageInfo-clang_modules">clang_modules</a>, <a href="#SPMPackageInfo-system_library_modules">system_library_modules</a>)
</pre>

Describes the information about an SPM package.

**FIELDS**


| Name  | Description |
| :------------- | :------------- |
| <a id="SPMPackageInfo-name"></a>name |  Name of the Swift package.    |
| <a id="SPMPackageInfo-swift_modules"></a>swift_modules |  A <code>list</code> of values returned from <code>providers.swift_module</code>.    |
| <a id="SPMPackageInfo-clang_modules"></a>clang_modules |  A <code>list</code> of values returned from <code>providers.clang_module</code>.    |
| <a id="SPMPackageInfo-system_library_modules"></a>system_library_modules |  <code>List</code> of values returned from <code>providers.system_library_module</code>.    |


<a id="#SPMPackagesInfo"></a>

## SPMPackagesInfo

<pre>
SPMPackagesInfo(<a href="#SPMPackagesInfo-packages">packages</a>)
</pre>

Provides information about the dependent SPM packages.

**FIELDS**


| Name  | Description |
| :------------- | :------------- |
| <a id="SPMPackagesInfo-packages"></a>packages |  A <code>list</code> of SPMPackageInfo representing the dependent packages.    |


<a id="#SPMPlatformInfo"></a>

## SPMPlatformInfo

<pre>
SPMPlatformInfo(<a href="#SPMPlatformInfo-os">os</a>, <a href="#SPMPlatformInfo-arch">arch</a>, <a href="#SPMPlatformInfo-vendor">vendor</a>, <a href="#SPMPlatformInfo-abi">abi</a>)
</pre>

SPM designations for the architecture, OS and vendor.

**FIELDS**


| Name  | Description |
| :------------- | :------------- |
| <a id="SPMPlatformInfo-os"></a>os |  The OS designation as understood by SPM.    |
| <a id="SPMPlatformInfo-arch"></a>arch |  The architecture designation as understood by SPM.    |
| <a id="SPMPlatformInfo-vendor"></a>vendor |  The vendor designation as understood by SPM.    |
| <a id="SPMPlatformInfo-abi"></a>abi |  The abi destination as understood by SPM.    |


<a id="#package_descriptions.parse_json"></a>

## package_descriptions.parse_json

<pre>
package_descriptions.parse_json(<a href="#package_descriptions.parse_json-json_str">json_str</a>)
</pre>

Parses the JSON string and returns a dict representing the JSON structure.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.parse_json-json_str"></a>json_str |  <p align="center"> - </p>   |  none |


<a id="#package_descriptions.get"></a>

## package_descriptions.get

<pre>
package_descriptions.get(<a href="#package_descriptions.get-repository_ctx">repository_ctx</a>, <a href="#package_descriptions.get-working_directory">working_directory</a>)
</pre>

Returns a dict representing the merge of a package's description and it's dump (dump-package) information.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.get-repository_ctx"></a>repository_ctx |  A <code>repository_ctx</code>.   |  none |
| <a id="package_descriptions.get-working_directory"></a>working_directory |  A <code>string</code> specifying the directory for the SPM package.   |  <code>""</code> |


<a id="#package_descriptions.is_library_product"></a>

## package_descriptions.is_library_product

<pre>
package_descriptions.is_library_product(<a href="#package_descriptions.is_library_product-product">product</a>)
</pre>

Returns a boolean indicating whether the specified product dictionary is a library product.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.is_library_product-product"></a>product |  A <code>dict</code> representing a product from package description JSON.   |  none |


<a id="#package_descriptions.library_products"></a>

## package_descriptions.library_products

<pre>
package_descriptions.library_products(<a href="#package_descriptions.library_products-pkg_desc">pkg_desc</a>)
</pre>

Returns the library products defined in the provided package description.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.library_products-pkg_desc"></a>pkg_desc |  A <code>dict</code> representing a package description.   |  none |


<a id="#package_descriptions.is_library_target"></a>

## package_descriptions.is_library_target

<pre>
package_descriptions.is_library_target(<a href="#package_descriptions.is_library_target-target">target</a>)
</pre>

Returns True if the specified target is a library target. Otherwise False.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.is_library_target-target"></a>target |  A target from the package description.   |  none |


<a id="#package_descriptions.is_executable_target"></a>

## package_descriptions.is_executable_target

<pre>
package_descriptions.is_executable_target(<a href="#package_descriptions.is_executable_target-target">target</a>)
</pre>

Returns True if the specified target is an executable target. Otherwise False.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.is_executable_target-target"></a>target |  A target from the package description.   |  none |


<a id="#package_descriptions.is_system_target"></a>

## package_descriptions.is_system_target

<pre>
package_descriptions.is_system_target(<a href="#package_descriptions.is_system_target-target">target</a>)
</pre>

Returns True if the specified target is a library target. Otherwise False.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.is_system_target-target"></a>target |  A target from the package description.   |  none |


<a id="#package_descriptions.library_targets"></a>

## package_descriptions.library_targets

<pre>
package_descriptions.library_targets(<a href="#package_descriptions.library_targets-pkg_desc">pkg_desc</a>)
</pre>

Returns a list of the library targets in the package.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.library_targets-pkg_desc"></a>pkg_desc |  The dict returned from the <code>parse_package_descrition_json</code>.   |  none |


<a id="#package_descriptions.is_system_library_target"></a>

## package_descriptions.is_system_library_target

<pre>
package_descriptions.is_system_library_target(<a href="#package_descriptions.is_system_library_target-target">target</a>)
</pre>

Returns True if the specified target is a clang module. Otherwise, False.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.is_system_library_target-target"></a>target |  A target from the package description.   |  none |


<a id="#package_descriptions.is_clang_target"></a>

## package_descriptions.is_clang_target

<pre>
package_descriptions.is_clang_target(<a href="#package_descriptions.is_clang_target-target">target</a>)
</pre>

Returns True if the specified target is a clang module. Otherwise, False.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.is_clang_target-target"></a>target |  A target from the package description.   |  none |


<a id="#package_descriptions.is_swift_target"></a>

## package_descriptions.is_swift_target

<pre>
package_descriptions.is_swift_target(<a href="#package_descriptions.is_swift_target-target">target</a>)
</pre>

Returns True if the specified target is a swift module. Otherwise, False.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.is_swift_target-target"></a>target |  A target from the package description.   |  none |


<a id="#package_descriptions.get_target"></a>

## package_descriptions.get_target

<pre>
package_descriptions.get_target(<a href="#package_descriptions.get_target-pkg_desc">pkg_desc</a>, <a href="#package_descriptions.get_target-name">name</a>, <a href="#package_descriptions.get_target-fail_if_not_found">fail_if_not_found</a>)
</pre>

Returns the target with the specified name from a package description.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.get_target-pkg_desc"></a>pkg_desc |  A <code>dict</code> representing a package description.   |  none |
| <a id="package_descriptions.get_target-name"></a>name |  A <code>string</code> represneting the name of the desired target.   |  none |
| <a id="package_descriptions.get_target-fail_if_not_found"></a>fail_if_not_found |  <p align="center"> - </p>   |  <code>True</code> |


<a id="#package_descriptions.dependency_name"></a>

## package_descriptions.dependency_name

<pre>
package_descriptions.dependency_name(<a href="#package_descriptions.dependency_name-pkg_dep">pkg_dep</a>)
</pre>

Returns the name for the package dependency. 

If a name was provided that value is returned. Otherwise, the repository
name is returned.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.dependency_name-pkg_dep"></a>pkg_dep |  A <code>dict</code> representing a package dependency as defined in a package description JSON.   |  none |


<a id="#package_descriptions.dependency_repository_name"></a>

## package_descriptions.dependency_repository_name

<pre>
package_descriptions.dependency_repository_name(<a href="#package_descriptions.dependency_repository_name-pkg_dep">pkg_dep</a>)
</pre>

Returns the repository name from the provided dependency `dict`.

Example:

URL: https://github.com/swift-server/async-http-client.git
Repository Name: async-http-client


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.dependency_repository_name-pkg_dep"></a>pkg_dep |  A <code>dict</code> representing a package dependency as defined in a package description JSON.   |  none |


<a id="#package_descriptions.transitive_dependencies"></a>

## package_descriptions.transitive_dependencies

<pre>
package_descriptions.transitive_dependencies(<a href="#package_descriptions.transitive_dependencies-pkg_descs_dict">pkg_descs_dict</a>, <a href="#package_descriptions.transitive_dependencies-product_refs">product_refs</a>)
</pre>

Returns all of the targets that are a transitive dependency for the specified products.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.transitive_dependencies-pkg_descs_dict"></a>pkg_descs_dict |  A <code>dict</code> where the keys are the package names and the values are package description <code>struct</code> values as returned by <code>package_descriptions.get()</code>.   |  none |
| <a id="package_descriptions.transitive_dependencies-product_refs"></a>product_refs |  A <code>list</code> of reference <code>string</code> values as created by <code>references.create_product_ref()</code>.   |  none |


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


<a id="#platforms.spm_os"></a>

## platforms.spm_os

<pre>
platforms.spm_os(<a href="#platforms.spm_os-swift_os">swift_os</a>)
</pre>

Maps the Bazel OS value to a suitable SPM OS value.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="platforms.spm_os-swift_os"></a>swift_os |  <p align="center"> - </p>   |  none |


<a id="#platforms.spm_arch"></a>

## platforms.spm_arch

<pre>
platforms.spm_arch(<a href="#platforms.spm_arch-swift_cpu">swift_cpu</a>)
</pre>

Maps the Bazel architeture value to a suitable SPM architecture value.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="platforms.spm_arch-swift_cpu"></a>swift_cpu |  <p align="center"> - </p>   |  none |


<a id="#platforms.spm_vendor"></a>

## platforms.spm_vendor

<pre>
platforms.spm_vendor(<a href="#platforms.spm_vendor-swift_os">swift_os</a>)
</pre>

Maps the Bazel OS value to the corresponding SPM vendor value.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="platforms.spm_vendor-swift_os"></a>swift_os |  <p align="center"> - </p>   |  none |


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
| <a id="providers.clang_module-modulemap"></a>modulemap |  <p align="center"> - </p>   |  <code>None</code> |
| <a id="providers.clang_module-all_outputs"></a>all_outputs |  All of the output files that are declared for the module.   |  <code>[]</code> |


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


<a id="#references.create"></a>

## references.create

<pre>
references.create(<a href="#references.create-ref_type">ref_type</a>, <a href="#references.create-pkg_name">pkg_name</a>, <a href="#references.create-name">name</a>)
</pre>

Creates a reference for the specified type.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="references.create-ref_type"></a>ref_type |  A <code>string</code> value. Must be one of the values in <code>reference_types</code>.   |  none |
| <a id="references.create-pkg_name"></a>pkg_name |  The package name as a <code>string</code>.   |  none |
| <a id="references.create-name"></a>name |  The name of the item as a <code>string</code>.   |  none |


<a id="#references.split"></a>

## references.split

<pre>
references.split(<a href="#references.split-ref_str">ref_str</a>)
</pre>

Splits a reference string into its parts.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="references.split-ref_str"></a>ref_str |  A valid reference <code>string</code>.   |  none |


<a id="#references.create_target_ref"></a>

## references.create_target_ref

<pre>
references.create_target_ref(<a href="#references.create_target_ref-pkg_name">pkg_name</a>, <a href="#references.create_target_ref-by_name_values">by_name_values</a>)
</pre>

Create a target reference from dependency values found in dump-package JSON values.

Example byName ref:
`{ "byName": [ "Logging", null ] }`


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="references.create_target_ref-pkg_name"></a>pkg_name |  The package name as a <code>string</code>.   |  none |
| <a id="references.create_target_ref-by_name_values"></a>by_name_values |  A <code>list</code> of <code>string</code> values where the first item is the module name.   |  none |


<a id="#references.create_product_ref"></a>

## references.create_product_ref

<pre>
references.create_product_ref(<a href="#references.create_product_ref-product_values">product_values</a>)
</pre>

Create a product reference from dependency values found in dump-package JSON values.

Example product ref:
`{ "product": [ "NIO", "swift-nio", null ] }`


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="references.create_product_ref-product_values"></a>product_values |  A <code>list</code> of <code>string</code> values where the first item is the module name and the second is the package name.   |  none |


<a id="#references.is_target_ref"></a>

## references.is_target_ref

<pre>
references.is_target_ref(<a href="#references.is_target_ref-ref_str">ref_str</a>, <a href="#references.is_target_ref-for_pkg">for_pkg</a>)
</pre>

Returns a boolean indicating whether the reference string is a target reference.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="references.is_target_ref-ref_str"></a>ref_str |  A valid reference <code>string</code>.   |  none |
| <a id="references.is_target_ref-for_pkg"></a>for_pkg |  Optional. A package name as a <code>string</code> value to include in the check.   |  <code>None</code> |


<a id="#repository_utils.is_macos"></a>

## repository_utils.is_macos

<pre>
repository_utils.is_macos(<a href="#repository_utils.is_macos-repository_ctx">repository_ctx</a>)
</pre>

Determines if the host is running MacOS.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="repository_utils.is_macos-repository_ctx"></a>repository_ctx |  A <code>repository_ctx</code> instance.   |  none |


<a id="#spm_clang_library"></a>

## spm_clang_library

<pre>
spm_clang_library(<a href="#spm_clang_library-name">name</a>, <a href="#spm_clang_library-packages">packages</a>, <a href="#spm_clang_library-deps">deps</a>, <a href="#spm_clang_library-visibility">visibility</a>)
</pre>

Exposes a clang module as defined in a dependent Swift package.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="spm_clang_library-name"></a>name |  The Bazel target name.   |  none |
| <a id="spm_clang_library-packages"></a>packages |  A target that outputs an SPMPackagesInfo provider (e.g. <code>spm_package</code>).   |  none |
| <a id="spm_clang_library-deps"></a>deps |  Dependencies appropriate for the <code>objc_library</code> which defines the target.   |  <code>None</code> |
| <a id="spm_clang_library-visibility"></a>visibility |  Target visibility.   |  <code>None</code> |


<a id="#spm_common.create_clang_hdrs_key"></a>

## spm_common.create_clang_hdrs_key

<pre>
spm_common.create_clang_hdrs_key(<a href="#spm_common.create_clang_hdrs_key-pkg_name">pkg_name</a>, <a href="#spm_common.create_clang_hdrs_key-target_name">target_name</a>)
</pre>

Returns a key that is used for clang headers dictionaries.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="spm_common.create_clang_hdrs_key-pkg_name"></a>pkg_name |  A <code>string</code> that is the name of the Swift package.   |  none |
| <a id="spm_common.create_clang_hdrs_key-target_name"></a>target_name |  A <code>string</code> that is the name of the target.   |  none |


<a id="#spm_common.split_clang_hdrs_key"></a>

## spm_common.split_clang_hdrs_key

<pre>
spm_common.split_clang_hdrs_key(<a href="#spm_common.split_clang_hdrs_key-key">key</a>)
</pre>

Returns the package name and the target name from a clang headers dictionary key.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="spm_common.split_clang_hdrs_key-key"></a>key |  A <code>string</code> representing a clange headers key.   |  none |


<a id="#spm_package_info_utils.get"></a>

## spm_package_info_utils.get

<pre>
spm_package_info_utils.get(<a href="#spm_package_info_utils.get-pkg_infos">pkg_infos</a>, <a href="#spm_package_info_utils.get-pkg_name">pkg_name</a>)
</pre>

Returns the `SPMPackageInfo` with the specified name from the list of `SPMPackageInfo` values.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="spm_package_info_utils.get-pkg_infos"></a>pkg_infos |  A <code>list</code> of <code>SPMPackageInfo</code> values.   |  none |
| <a id="spm_package_info_utils.get-pkg_name"></a>pkg_name |  A <code>string</code> representing the name of the desired <code>SPMPackageInfo</code>.   |  none |


<a id="#spm_package_info_utils.get_module_info"></a>

## spm_package_info_utils.get_module_info

<pre>
spm_package_info_utils.get_module_info(<a href="#spm_package_info_utils.get_module_info-pkg_info">pkg_info</a>, <a href="#spm_package_info_utils.get_module_info-module_name">module_name</a>)
</pre>

Returns the module information with the specified module name.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="spm_package_info_utils.get_module_info-pkg_info"></a>pkg_info |  An <code>SPMPackageInfo</code> value.   |  none |
| <a id="spm_package_info_utils.get_module_info-module_name"></a>module_name |  The module name <code>string</code>.   |  none |


<a id="#spm_pkg"></a>

## spm_pkg

<pre>
spm_pkg(<a href="#spm_pkg-url">url</a>, <a href="#spm_pkg-path">path</a>, <a href="#spm_pkg-name">name</a>, <a href="#spm_pkg-from_version">from_version</a>, <a href="#spm_pkg-revision">revision</a>, <a href="#spm_pkg-products">products</a>)
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
| <a id="spm_pkg-from_version"></a>from_version |  Optional. A <code>string</code> representing a valid "from" SPM version.   |  <code>None</code> |
| <a id="spm_pkg-revision"></a>revision |  Optional. A commit hash (<code>string</code>).   |  <code>None</code> |
| <a id="spm_pkg-products"></a>products |  A <code>list</code> of <code>string</code> values representing the names of the products to be used.   |  <code>[]</code> |


<a id="#spm_rules_dependencies"></a>

## spm_rules_dependencies

<pre>
spm_rules_dependencies()
</pre>

Loads the dependencies for `rules_spm`.



<a id="#spm_swift_library"></a>

## spm_swift_library

<pre>
spm_swift_library(<a href="#spm_swift_library-name">name</a>, <a href="#spm_swift_library-packages">packages</a>, <a href="#spm_swift_library-deps">deps</a>, <a href="#spm_swift_library-visibility">visibility</a>)
</pre>

Exposes a Swift module as defined in a Swift package.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="spm_swift_library-name"></a>name |  The Bazel target name.   |  none |
| <a id="spm_swift_library-packages"></a>packages |  A target that outputs an SPMPackagesInfo provider (e.g. <code>spm_package</code>).   |  none |
| <a id="spm_swift_library-deps"></a>deps |  Dependencies appropriate for the <code>swift_import</code> which defines the target.   |  <code>None</code> |
| <a id="spm_swift_library-visibility"></a>visibility |  Target visibility.   |  <code>None</code> |


<a id="#spm_system_library"></a>

## spm_system_library

<pre>
spm_system_library(<a href="#spm_system_library-name">name</a>, <a href="#spm_system_library-packages">packages</a>, <a href="#spm_system_library-deps">deps</a>, <a href="#spm_system_library-visibility">visibility</a>)
</pre>

Exposes a system library module as defined in a Swift package.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="spm_system_library-name"></a>name |  The Bazel target name.   |  none |
| <a id="spm_system_library-packages"></a>packages |  A target that outputs an SPMPackagesInfo provider (e.g. <code>spm_package</code>).   |  none |
| <a id="spm_system_library-deps"></a>deps |  Dependencies appropriate for the <code>swift_c_module</code> which defines the target.   |  <code>None</code> |
| <a id="spm_system_library-visibility"></a>visibility |  Target visibility.   |  <code>None</code> |


<a id="#spm_versions.extract"></a>

## spm_versions.extract

<pre>
spm_versions.extract(<a href="#spm_versions.extract-version">version</a>)
</pre>

From a raw version string, extract the semantic version number.

Input: `Swift Package Manager - Swift 5.4.0`
Output: `5.4.0`


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="spm_versions.extract-version"></a>version |  A <code>string</code> which has the semantic version embedded at the end.   |  none |


<a id="#spm_versions.get"></a>

## spm_versions.get

<pre>
spm_versions.get(<a href="#spm_versions.get-repository_ctx">repository_ctx</a>)
</pre>

Returns the semantic version for Swit Package Manager.

This is equivalent to running `swift package --version` and returning
the semantic version.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="spm_versions.get-repository_ctx"></a>repository_ctx |  A <code>repository_ctx</code> instance.   |  none |



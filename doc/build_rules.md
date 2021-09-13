<!-- Generated with Stardoc, Do Not Edit! -->
# Build Rules

The rules described below are used to build Swift
packages and make their outputs available as Bazel targets. Most
clients will not use these rules directly. They are an implementation
detail for [the workspace rules](doc/workspace_rules.md).

On this page:

  * [spm_archive](#spm_archive)
  * [spm_clang_library](#spm_clang_library)
  * [spm_filegroup](#spm_filegroup)
  * [spm_package](#spm_package)
  * [spm_swift_binary](#spm_swift_binary)
  * [spm_swift_library](#spm_swift_library)
  * [spm_system_library](#spm_system_library)

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



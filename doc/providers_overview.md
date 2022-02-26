<!-- Generated with Stardoc, Do Not Edit! -->
# Providers

The providers described below are used by [the build rules](/doc/build_rules_overview.md) to
facilitate the build and exposition of the Swift packages.

On this page:

  * [SPMPackageInfo](#SPMPackageInfo)
  * [SPMPackagesInfo](#SPMPackagesInfo)
  * [SPMPlatformInfo](#SPMPlatformInfo)
  * [SPMToolchainInfo](#SPMToolchainInfo)


<a id="#SPMPackageInfo"></a>

## SPMPackageInfo

<pre>
SPMPackageInfo(<a href="#SPMPackageInfo-clang_modules">clang_modules</a>, <a href="#SPMPackageInfo-name">name</a>, <a href="#SPMPackageInfo-swift_binaries">swift_binaries</a>, <a href="#SPMPackageInfo-swift_modules">swift_modules</a>, <a href="#SPMPackageInfo-system_library_modules">system_library_modules</a>)
</pre>

Describes the information about an SPM package.

**FIELDS**


| Name  | Description |
| :------------- | :------------- |
| <a id="SPMPackageInfo-clang_modules"></a>clang_modules |  A <code>list</code> of values returned from <code>providers.clang_module</code>.    |
| <a id="SPMPackageInfo-name"></a>name |  Name of the Swift package.    |
| <a id="SPMPackageInfo-swift_binaries"></a>swift_binaries |  A <code>list</code> of values returned from <code>providers.swift_binary</code>.    |
| <a id="SPMPackageInfo-swift_modules"></a>swift_modules |  A <code>list</code> of values returned from <code>providers.swift_module</code>.    |
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
SPMPlatformInfo(<a href="#SPMPlatformInfo-abi">abi</a>, <a href="#SPMPlatformInfo-arch">arch</a>, <a href="#SPMPlatformInfo-os">os</a>, <a href="#SPMPlatformInfo-vendor">vendor</a>)
</pre>

SPM designations for the architecture, OS and vendor.

**FIELDS**


| Name  | Description |
| :------------- | :------------- |
| <a id="SPMPlatformInfo-abi"></a>abi |  The abi destination as understood by SPM.    |
| <a id="SPMPlatformInfo-arch"></a>arch |  The architecture designation as understood by SPM.    |
| <a id="SPMPlatformInfo-os"></a>os |  The OS designation as understood by SPM.    |
| <a id="SPMPlatformInfo-vendor"></a>vendor |  The vendor designation as understood by SPM.    |


<a id="#SPMToolchainInfo"></a>

## SPMToolchainInfo

<pre>
SPMToolchainInfo(<a href="#SPMToolchainInfo-spm_configuration">spm_configuration</a>, <a href="#SPMToolchainInfo-spm_platform_info">spm_platform_info</a>, <a href="#SPMToolchainInfo-target_triple">target_triple</a>, <a href="#SPMToolchainInfo-tool_configs">tool_configs</a>)
</pre>

Information about how to invoke tools like the Swift package manager.

**FIELDS**


| Name  | Description |
| :------------- | :------------- |
| <a id="SPMToolchainInfo-spm_configuration"></a>spm_configuration |  The SPM build configuration as a <code>string</code>. Values: <code>release</code> or <code>debug</code>    |
| <a id="SPMToolchainInfo-spm_platform_info"></a>spm_platform_info |  An <code>SpmPlatformInfo</code> describing the target platform.    |
| <a id="SPMToolchainInfo-target_triple"></a>target_triple |  A string representing the target platform as a triple.    |
| <a id="SPMToolchainInfo-tool_configs"></a>tool_configs |  A <code>dict</code> of configuration structs where the key is an action name (<code>action_names</code>) and the value is a <code>struct</code> as returned by <code>actions.tool_config()</code>.    |



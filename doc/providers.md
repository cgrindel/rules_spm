<!-- Generated with Stardoc, Do Not Edit! -->
# Providers

The providers described below are used by [the build rules](/doc/build_rules.md) to
facilitate the build and exposition of the Swift packages.

On this page:

  * [SPMBuildInfo](#SPMBuildInfo)
  * [SPMPackageInfo](#SPMPackageInfo)
  * [SPMPackagesInfo](#SPMPackagesInfo)
  * [SPMPlatformInfo](#SPMPlatformInfo)

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



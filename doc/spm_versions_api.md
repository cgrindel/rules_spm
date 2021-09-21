<!-- Generated with Stardoc, Do Not Edit! -->
# `spm_versions` API

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
spm_versions.get(<a href="#spm_versions.get-repository_ctx">repository_ctx</a>, <a href="#spm_versions.get-env">env</a>)
</pre>

Returns the semantic version for Swit Package Manager.

This is equivalent to running `swift package --version` and returning
the semantic version.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="spm_versions.get-repository_ctx"></a>repository_ctx |  A <code>repository_ctx</code> instance.   |  none |
| <a id="spm_versions.get-env"></a>env |  A <code>dict</code> of environment variables that are used in the evaluation of the SPM version.   |  <code>{}</code> |



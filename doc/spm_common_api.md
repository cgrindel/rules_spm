<!-- Generated with Stardoc: http://skydoc.bazel.build -->

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



<!-- Generated with Stardoc, Do Not Edit! -->
# `references` API

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



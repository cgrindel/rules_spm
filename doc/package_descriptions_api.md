<!-- Generated with Stardoc, Do Not Edit! -->
# `package_descriptions` API

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
package_descriptions.get(<a href="#package_descriptions.get-repository_ctx">repository_ctx</a>, <a href="#package_descriptions.get-env">env</a>, <a href="#package_descriptions.get-working_directory">working_directory</a>)
</pre>

Returns a dict representing the merge of a package's description and it's dump (dump-package) information.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.get-repository_ctx"></a>repository_ctx |  A <code>repository_ctx</code>.   |  none |
| <a id="package_descriptions.get-env"></a>env |  A <code>dict</code> of environment variables that will be included in the command execution.   |  <code>{}</code> |
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


<a id="#package_descriptions.is_executable_product"></a>

## package_descriptions.is_executable_product

<pre>
package_descriptions.is_executable_product(<a href="#package_descriptions.is_executable_product-product">product</a>)
</pre>

Returns a boolean indicating whether the specified product dictionary is an executable product.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.is_executable_product-product"></a>product |  A <code>dict</code> representing a product from package description JSON.   |  none |


<a id="#package_descriptions.get_product"></a>

## package_descriptions.get_product

<pre>
package_descriptions.get_product(<a href="#package_descriptions.get_product-pkg_desc">pkg_desc</a>, <a href="#package_descriptions.get_product-product_name">product_name</a>, <a href="#package_descriptions.get_product-fail_if_not_found">fail_if_not_found</a>)
</pre>

Returns the product with the specified product name.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_descriptions.get_product-pkg_desc"></a>pkg_desc |  A <code>dict</code> representing a package description.   |  none |
| <a id="package_descriptions.get_product-product_name"></a>product_name |  The product name as a <code>string</code>.   |  none |
| <a id="package_descriptions.get_product-fail_if_not_found"></a>fail_if_not_found |  <p align="center"> - </p>   |  <code>True</code> |



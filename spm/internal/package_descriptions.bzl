"""\
Logic for parsing and retrieving information from package description 
JSON as generated by `swift package describe --type json`.\
"""

load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//lib:sets.bzl", "sets")
load(":packages.bzl", "packages")
load(":references.bzl", ref_types = "reference_types", refs = "references")

# MARK: - Package Description JSON Retrieval

def _parse_json(json_str):
    """Parses the JSON string and returns a dict representing the JSON structure.

    Args:
        json: JSON string.

    Returns:
        A dict which contains the information from the JSON string.
    """
    return json.decode(json_str)

def _retrieve_package_dump(repository_ctx, working_directory = ""):
    """Returns a dict representing the package dump for an SPM package.

    Args:
        repository_ctx: A `repository_ctx`.
        working_directory: A `string` specifying the directory for the SPM package.

    Returns:
        A `dict` representing an SPM package dump.
    """
    describe_result = repository_ctx.execute(
        ["swift", "package", "dump-package"],
        working_directory = working_directory,
    )
    return _parse_json(describe_result.stdout)

def _retrieve_package_description(repository_ctx, working_directory = ""):
    """Returns a dict representing the package description for an SPM package.

    Args:
        repository_ctx: A `repository_ctx`.
        working_directory: A `string` specifying the directory for the SPM package.

    Returns:
        A `dict` representing an SPM package description.
    """
    describe_result = repository_ctx.execute(
        ["swift", "package", "describe", "--type", "json"],
        working_directory = working_directory,
    )
    return _parse_json(describe_result.stdout)

def _get_package_description(repository_ctx, working_directory = ""):
    """Returns a dict representing the merge of a package's description and 
    it's dump (dump-package) information.

    Args:
        repository_ctx: A `repository_ctx`.
        working_directory: A `string` specifying the directory for the SPM package.

    Returns:
        A `dict` representing information gathered from an SPM package
        description and it's dump data.
    """
    pkg_desc = _retrieve_package_description(repository_ctx, working_directory = working_directory)
    pkg_dump = _retrieve_package_dump(repository_ctx, working_directory = working_directory)

    # Collect the dump targets by name
    dump_targets_dict = {}
    for dump_target in pkg_dump["targets"]:
        dump_targets_dict[dump_target["name"]] = dump_target

    # Merge dump target dependencies into the package description dict. After
    # the merge a target will have a "target_dependencies" key and a
    # "dependencies" key.  The "target_dependencies" value is a list of target
    # names from the package that are dependencies for the target. The
    # "dependencies" value is a list of dict values which has a "product" key
    # or a "target" key. The "product" value is a list where the first item is
    # the target name and the second is the package name. The "target" value is
    # a list where the first item is the target name.
    #
    # Example:
    #    {
    #      "target" : [
    #        "CURLParser",
    #        null
    #      ]
    #    },
    #    {
    #      "product" : [
    #        "ConsoleKit",
    #        "console-kit",
    #        null
    #      ]
    #    },
    for target in pkg_desc["targets"]:
        target_name = target["name"]
        dump_target = dump_targets_dict.get(target_name)
        if dump_target == None:
            continue
        target["dependencies"] = dump_target["dependencies"]

    return pkg_desc

# MARK: - Product Functions

def _is_library_product(product):
    """Returns a boolean indicating whether the specified product dictionary
    is a library product.

    Args:
        product: A `dict` representing a product from package description
                 JSON.

    Returns:
        A `bool` indicating whether the product is a library.
    """
    return "library" in product["type"]

def _library_products(pkg_desc):
    """Returns the library products defined in the provided package 
    description.

    Args:
        pkg_desc: A `dict` representing a package description.

    Returns:
        A `list` of product `dict` values as defined in a package description.
    """
    return [p for p in pkg_desc["products"] if _is_library_product(p)]

def _find_in_list_of_dicts(items, key, value, item_type = None):
    for item in items:
        if item[key] == value:
            return item

    if item_type == None:
        item_type = "item"
    err_msg_tpl = "Failed to find %s with %s equal to %s."
    fail(err_msg_tpl % (item_type, key, value))

def _get_product(pkg_desc, product_name):
    return _find_in_list_of_dicts(pkg_desc["products"], "name", product_name)

# MARK: - Target Functions

def _is_library_target(target):
    """Returns True if the specified target is a library target. Otherwise False.

    Args:
        target: A target from the package description.

    Returns:
        A boolean indicating whether the target is a library target.
    """
    return target["type"] == "library"

def _library_targets(pkg_desc):
    """Returns a list of the library targets in the package.

    Args:
        pkg_desc: The dict returned from the `parse_package_descrition_json`.

    Returns:
        A list of the library targets in the package.
    """
    targets = pkg_desc["targets"]
    return [t for t in targets if _is_library_target(t)]

def _is_clang_target(target):
    """Returns True if the specified target is a clang module. Otherwise, False.

    Args:
        target: A target from the package description.

    Returns:
        A boolean indicating whether the target is a clang module.
    """
    return target["module_type"] == module_types.clang

def _is_swift_target(target):
    """Returns True if the specified target is a swift module. Otherwise, False.

    Args:
        target: A target from the package description.

    Returns:
        A boolean indicating whether the target is a swift module.
    """
    return target["module_type"] == module_types.swift

def _get_target(pkg_desc, name):
    """Returns the target with the specified name from a package description.

    Args:
        pkg_desc: A `dict` representing a package description.
        name: A `string` represneting the name of the desired target.

    Returns:
        A `dict` representing a target as represented in a package description.
    """
    for t in pkg_desc["targets"]:
        if t["name"] == name:
            return t
    fail("Could not find target %s in package %s." % (name, pkg_desc["name"]))

# MARK: - Package Dependency Functions

def _dependency_repository_name(pkg_dep):
    """Returns the repository name from the provided dependency `dict`.

    Example:

    URL: https://github.com/swift-server/async-http-client.git
    Repository Name: async-http-client

    Args:
        pkg_dep: A `dict` representing a package dependency as defined in
                 a package description JSON.

    Returns:
        The repository name for the package dependency.
    """
    url = pkg_dep["url"]
    return packages.create_name(url)

def _dependency_name(pkg_dep):
    """Returns the name for the package dependency. 

    If a name was provided that value is returned. Otherwise, the repository
    name is returned.

    Args:
        pkg_dep: A `dict` representing a package dependency as defined in
                 a package description JSON.

    Returns:
        The name of the package dependency as a `string`.
    """
    name = pkg_dep.get("name", default = "")
    if name != "":
        return name
    return _dependency_repository_name(pkg_dep)

# MARK: - Transitive Dependency Functions

def _gather_deps_for_target(pkg_descs_dict, target_ref):
    """Returns the dependencies for the specified target.

    Args:
        pkg_descs_dict: A `dict` where the keys are the package names and the
                        values are package description `struct` values as
                        returned by `package_descriptions.get()`.
        target_ref: A reference `string` as created by
                    `references.create_target_ref()`.

    Returns:
        A `tuple` where the first item is a list of product reference `string`
        values and the second item is a list of target reference `string`
        values.
    """
    ref_type, pkg_name, target_name = refs.split(target_ref)
    pkg_desc = pkg_descs_dict[pkg_name]
    target = _get_target(pkg_desc, target_name)

    product_refs = []
    target_refs = []
    for dep in target["dependencies"]:
        product_values = dep.get("product")
        if product_values != None:
            product_refs.append(refs.create_product_ref(product_values))
            continue
        by_name_values = dep.get("byName")
        if by_name_values != None:
            target_refs.append(refs.create_target_ref(pkg_name, by_name_values))
            continue
        target_values = dep.get("target")
        if target_values != None:
            target_refs.append(refs.create_target_ref(pkg_name, target_values))
            continue
        fail("Unrecognized dependency type. %s" % (dep))

    return product_refs, target_refs

def _get_product_target_refs(pkg_descs_dict, product_ref):
    """Returns the target refernces that are directly associated with the 
    specified product.

    Args:
        pkg_descs_dict: A `dict` where the keys are the package names and the
                        values are package description `struct` values as
                        returned by `package_descriptions.get()`.
        product_ref: A reference `string` as created by
                     `references.create_product_ref()`.

    Returns:
        A `list` of target reference `string` values.
    """
    ref_typ, pkg_name, product_name = refs.split(product_ref)
    pkg_desc = pkg_descs_dict[pkg_name]
    product = _get_product(pkg_desc, product_name)
    return [refs.create(ref_types.target, pkg_name, t) for t in product["targets"]]

def _transitive_dependencies(pkg_descs_dict, product_refs):
    """Returns all of the targets that are a transitive dependency for the 
    specified products.

    Args:
        pkg_descs_dict: A `dict` where the keys are the package names and the
                        values are package description `struct` values as
                        returned by `package_descriptions.get()`.
        product_refs: A `list` of reference `string` values as created by
                      `references.create_product_ref()`.

    Returns:
        A `dict` where the keys are target reference values and the
        values are a `list` of target references.
    """

    # Key: target_ref, Value: List of (target_ref|product_ref)
    target_deps_dict = {}

    # Key: product_ref, Value: List of (target_ref)
    product_deps_dict = {}

    # Attempt to resolve all of the dependencies to target references
    product_refs_to_eval = product_refs
    target_refs_to_eval = sets.make()
    finished_eval = False
    for iteration in range(100):
        # Collect the targets that are referenced by the products
        for product_ref in product_refs_to_eval:
            prd_target_refs = _get_product_target_refs(pkg_descs_dict, product_ref)
            product_deps_dict[product_ref] = prd_target_refs
            for target_ref in prd_target_refs:
                if target_deps_dict.get(target_ref) == None:
                    sets.insert(target_refs_to_eval, target_ref)

        # Eval targets
        new_prds_to_eval = sets.make()
        new_trgts_to_eval = sets.make()
        for target_ref in sets.to_list(target_refs_to_eval):
            # If we have already resolved this target, don't do it again.
            if target_deps_dict.get(target_ref) != None:
                continue
            dep_prd_refs, dep_trgt_refs = _gather_deps_for_target(pkg_descs_dict, target_ref)
            target_deps_dict[target_ref] = dep_trgt_refs + dep_prd_refs
            for product_ref in dep_prd_refs:
                # If we have not resolved the product_ref, add it to the list for evaluation
                if product_deps_dict.get(product_ref) == None:
                    sets.insert(new_prds_to_eval, product_ref)
            for target_ref in dep_trgt_refs:
                if target_deps_dict.get(target_ref) == None:
                    sets.insert(new_trgts_to_eval, target_ref)

        if sets.length(new_prds_to_eval) == 0 and sets.length(new_trgts_to_eval) == 0:
            finished_eval = True
            break
        product_refs_to_eval = sets.to_list(new_prds_to_eval)
        target_refs_to_eval = new_trgts_to_eval

    # Make sure that dependency resolution completed without "timing out".
    if not finished_eval:
        fail("Evaluation of the dependencies did not complete.")

    # Now replace all of the product_refs with their corresponding target refs.
    resolved_targets_dict = {}
    for target_ref in target_deps_dict:
        resolved_deps = []
        for ref in target_deps_dict[target_ref]:
            if refs.is_target_ref(ref):
                resolved_deps.append(ref)
            else:
                resolved_deps.extend(product_deps_dict[ref])
        resolved_targets_dict[target_ref] = sorted(resolved_deps)

    return resolved_targets_dict

# MARK: - Namespace

module_types = struct(
    swift = "SwiftTarget",
    clang = "ClangTarget",
)

package_descriptions = struct(
    parse_json = _parse_json,
    get = _get_package_description,
    # Library Functions
    is_library_product = _is_library_product,
    library_products = _library_products,
    # Target Functions
    is_library_target = _is_library_target,
    library_targets = _library_targets,
    is_clang_target = _is_clang_target,
    is_swift_target = _is_swift_target,
    get_target = _get_target,
    # Dependency Functions
    dependency_name = _dependency_name,
    dependency_repository_name = _dependency_repository_name,
    # Transitive Dependency Functions
    transitive_dependencies = _transitive_dependencies,
    # Constants
    root_pkg_name = "_root",
)

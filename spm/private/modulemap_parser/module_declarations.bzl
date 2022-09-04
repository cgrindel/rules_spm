"""Module for managing module declarations"""

load(":declarations.bzl", "declarations")
load(":errors.bzl", "errors")

# def _get_module(collect_result):
#     if len(collect_result.declarations) != 1:
#         return None, errors.new(
#             "Expect a single module declaration but found {decl_count}.".format(
#                 decl_count = len(collect_result.declarations),
#             ),
#         )
#     return collect_result.declarations[0]

def _is_a_module(decl):
    return decl.decl_type == declarations.types.module

def _get_member(root_module_decl, path):
    if root_module_decl == None:
        return None, errors.new("The `root_module_decl` was `None`. path: {}".format(path))
    if root_module_decl.decl_type != declarations.typs.module:
        return None, errors.new("The `root_module_decl` is not a module. {}".format(root_module_decl))
    if path == []:
        return None, errors.new("The `path` cannot be empty.")

    member = None
    cur_module = root_module_decl
    for idx in path:
        if cur_module == None:
            return None, errors.new("Invalid path. root_module_decl: {}, path: {}".format(
                root_module_decl,
                path,
            ))
        member = cur_module.members[idx]
        cur_module = member if _is_a_module(member) else None
    return member

# def _replace_member(root_module_decl, path, member):
#     if root_module_decl.decl_type != declarations.typs.module:
#         return None, errors.new("The `root_module_decl` is not a module. {}".format(root_module_decl))

#     return new_root_module_decl

module_declarations = struct(
    is_a_module = _is_a_module,
    get_member = _get_member,
)

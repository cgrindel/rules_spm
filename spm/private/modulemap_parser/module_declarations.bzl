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
    return decl.decl_type in [
        declarations.types.module,
        declarations.types.inferred_submodule,
    ]

def _check_root_module_and_path(root_module_decl, path):
    if root_module_decl == None:
        return errors.new("The `root_module_decl` was `None`. path: {}".format(path))
    if not _is_a_module(root_module_decl):
        return errors.new("The `root_module_decl` is not a module. {}".format(root_module_decl))
    if path == []:
        return errors.new("The `path` cannot be empty.")
    return None

def _get_member(root_module_decl, path):
    err = _check_root_module_and_path(root_module_decl, path)
    if err != None:
        return None, err

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
    return member, None

def _replace_member(root_module_decl, path, member):
    err = _check_root_module_and_path(root_module_decl, path)
    if err != None:
        return None, err
    if member == None:
        return None, errors.new("The `member` argument was `None`.")

    # Collect the parent modules
    parent_modules = [root_module_decl]
    for idx in range(len(path[:-1])):
        member, err = _get_member(root_module_decl, path[:idx])
        if err != None:
            return None, err
        if not _is_a_module(member):
            return None, errors.new("Expected a module. {}".format(member))
        parent_modules.append(member)

    # DEBUG BEGIN
    print("*** CHUCK path: ", path)
    # DEBUG END

    # for cnt in range(1, len(parent_modules) + 1):
    #     cur_idx = -cnt

    new_member = member
    for offset in range(-1, -(len(parent_modules) + 1), -1):
        parent_module = parent_modules[offset]
        member_idx = path[offset]

        new_members = list(parent_module.members)

        # DEBUG BEGIN
        print("*** CHUCK offset: ", offset)
        print("*** CHUCK member_idx: ", member_idx)
        print("*** CHUCK parent_module: ", parent_module)
        print("*** CHUCK parent_module.members: ")
        print("*** CHUCK new_members: ")
        for idx, item in enumerate(new_members):
            print("*** CHUCK", idx, ":", item)

        # DEBUG END
        new_members.pop(member_idx)
        new_members.insert(member_idx, new_member)
        new_member, err = declarations.copy_module(
            parent_module,
            members = new_members,
        )

    return new_member, None

module_declarations = struct(
    is_a_module = _is_a_module,
    get_member = _get_member,
    replace_member = _replace_member,
)

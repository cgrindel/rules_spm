"""Module for retrieving and manipulating repository file information."""

def _list_files_under(repository_ctx, path):
    """Retrieves the list of files under the specified path.

    This function returns paths for all of the files under the specified path.

    Args:
        repository_ctx: A `repository_ctx` instance.
        path: A path `string` value.

    Returns:
        A `list` of path `string` values.
    """
    exec_result = repository_ctx.execute(
        ["find", path],
        quiet = True,
    )
    if exec_result.return_code != 0:
        fail("Failed to list files in %s. stderr:\n%s" % (path, exec_result.stderr))
    paths = exec_result.stdout.splitlines()
    return paths

def _list_directories_under(repository_ctx, path, max_depth = None):
    """Retrieves the list of directories under the specified path.

    Args:
        repository_ctx: A `repository_ctx` instance.
        path: A path `string` value.
        max_depth: Optional. The depth for the directory search.

    Returns:
        A `list` of path `string` values.
    """
    find_args = ["find", path, "-type", "d"]
    if max_depth != None:
        find_args.extend(["-maxdepth", "%d" % (max_depth)])
    exec_result = repository_ctx.execute(find_args, quiet = True)
    if exec_result.return_code != 0:
        fail("Failed to list directories under %s. stderr:\n%s" % (path, exec_result.stderr))
    paths = exec_result.stdout.splitlines()
    return [p for p in paths if p != path]

def _find_and_delete_files(repository_ctx, path, name):
    """Finds files with the specified name under the specified path and deletes them.

    Args:
        repository_ctx: A `repository_ctx` instance.
        path: A path `string` value.
        name: A file basename as a `string`.
    """
    find_args = ["find", path, "-type", "f", "-name", name]
    rm_args = ["-delete"]
    all_args = find_args + rm_args
    exec_result = repository_ctx.execute(all_args, quiet = True)
    if exec_result.return_code != 0:
        fail("Failed to remove files named {name} under {path}. stderr:\n{stderr}".format(
            name = name,
            path = path,
            stderr = exec_result.stderr,
        ))

# TODO: Add doc comment for _copy_directory.

def _copy_directory(repository_ctx, src_path, dest_path):
    # Copy the sources from the checkout directory
    repository_ctx.execute(
        [
            "cp",
            "-R",
            "-f",
            src_path,
            dest_path,
        ],
    )

repository_files = struct(
    list_files_under = _list_files_under,
    list_directories_under = _list_directories_under,
    find_and_delete_files = _find_and_delete_files,
    copy_directory = _copy_directory,
)

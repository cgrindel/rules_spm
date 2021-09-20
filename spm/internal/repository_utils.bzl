def _is_macos(repository_ctx):
    """Determines if the host is running MacOS.

    Args:
        repository_ctx: A `repository_ctx` instance.

    Returns:
        A `bool` indicating whether the host is running MacOS.
    """
    os_name = repository_ctx.os.name.lower()
    return os_name.startswith("mac os")

def _execute_spm_command(repository_ctx, arguments, err_msg_tpl = None, env = {}):
    exec_args = []
    if _is_macos(repository_ctx):
        exec_args.append("xcrun")
    exec_args.extend(arguments)
    exec_result = repository_ctx.execute(exec_args, environment = env)
    if exec_result.return_code != 0:
        if err_msg_tpl == None:
            err_msg_tpl = """\
Failed to execute SPM command. args: {exec_args}\n{stderr}.\
"""
        fail(err_msg_tpl.format(exec_args = exec_args, stderr = exec_result.stderr))
    return exec_result.stdout

repository_utils = struct(
    is_macos = _is_macos,
    exec_spm_command = _execute_spm_command,
)

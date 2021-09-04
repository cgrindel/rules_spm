def _is_macos(repository_ctx):
    """Determines if the host is running MacOS.
    
    Args:
        repository_ctx: A `repository_ctx` instance.
    
    Returns:
        A `bool` indicating whether the host is running MacOS.
    """
    os_name = repository_ctx.os.name.lower()
    return os_name.startswith("mac os")

repository_utils = struct(
    is_macos = _is_macos,
)

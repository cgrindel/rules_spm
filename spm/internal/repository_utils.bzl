def _is_macos(repository_ctx):
    """Determines if the host is running MacOS.
    
    Args:
        repository_ctx: A `repository_ctx` instance.
    
    Returns:
        A `bool` indicating whether the host is running MacOS.
    """
    os_name = repository_ctx.os.name.lower()
    return os_name.startswith("mac os")

def _repo_host(resolve_packages = None):
    """Creates a `struct` that contains functions for interacting with the 
    repository host.
    
    Args:
        resolve_packages: A `function` used to resolve and download the SPM
                          packages.
    
    Returns:
      A `struct` which has functions for interacting with the repository host.
    """
    return struct(
        resolve_packages = resolve_packages,
    )

repository_utils = struct(
    is_macos = _is_macos,
    repo_host = _repo_host,
)

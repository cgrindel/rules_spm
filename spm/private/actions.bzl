"""Definition for actions module."""

def _tool_config(
        executable,
        additional_tools = [],
        args = [],
        env = {},
        execution_requirements = {}):
    return struct(
        executable = executable,
        additional_tools = additional_tools,
        args = args,
        env = env,
        execution_requirements = execution_requirements,
    )

action_names = struct(
    BUILD = "SPMBuild",
)

actions = struct(
    tool_config = _tool_config,
)

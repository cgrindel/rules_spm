def _spm_repository_info_impl(ctx):
    return [
        platform_common.TemplateVariableInfo({
            "SPM_REPOS_NAME": ctx.attr.repos_name,
        }),
    ]

# spm_repository_info = rule(
spm_repository_info = repository_rule(
    implementation = _spm_repository_info_impl,
    attrs = {
        "repos_name": attr.string(),
    },
)

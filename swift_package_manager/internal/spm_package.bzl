# TODO: Update this to use a toolchain to execute "swift build".
# https://docs.bazel.build/versions/main/toolchains.html

def _spm_package_impl(ctx):
    build_output_dir = ctx.actions.declare_directory("spm_build_output")

    # outputs = jj
    ctx.actions.run_shell(
        inputs = ctx.files.srcs,
        outputs = [build_output_dir],
        arguments = [ctx.attr.configuration, build_output_dir.path],
        command = """
        # DEBUG BEGIN
        echo "pwd: $(pwd)"
        echo "configuration: $1"
        echo "build_output_dir: $2"
        set -x
        # DEBUG END
        # pushd external/apple_swift_log
        swift build \
            --verbose \
            --manifest-cache=none \
            --disable-sandbox \
            --package-path external/apple_swift_log \
            --configuration $1 \
            --build-path "$2"
        # popd
        tree -la "$2"
        echo "Find Swift  files"
        find -L . -name "*.swift"
        echo "Find Mach-O files"
        find -L . -name "*.o"
        """,
        progress_message = "Building the Swift package using SPM.",
    )

    return [DefaultInfo(files = depset([build_output_dir]))]

_attrs = {
    "srcs": attr.label_list(
        allow_files = True,
        mandatory = True,
    ),
    "configuration": attr.string(
        default = "release",
        values = ["release", "debug"],
        doc = "The configuration to use when executing swift build (e.g. debug, release).",
    ),
}

spm_package = rule(
    implementation = _spm_package_impl,
    attrs = _attrs,
    doc = "Builds the specified Swift package.",
)

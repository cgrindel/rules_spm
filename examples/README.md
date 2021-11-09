# Examples and Integration Tests for `rules_spm`

## Examples

_GH092: Add list of examples with short descriptions._

## Integration Tests

The integration tests for the `rules_spm` repository execute against the example workspaces. Due to
their size and, in some cases, environment changes, the integration tests are declared with the
`manual` tag. This means that they will not be selected when `bazel test //...` is executed. To run
the integration tests, you need to either execute an individual test or a predefined test suite.

### Execute a Single Test

To execute a single integration test, specify the target on the Bazel command line.

```sh
# Execute the default integration test for the simple workspace
$ bazel test //examples:simple_test
```

### Execute One of the Predefined Test Suites

The following are the names for the integration test suites defined in this repository:

- `no_sudo_integration_tests`: All of the integration tests that do not require root access to the
  system.
- `sudo_integration_tests`: All of the integration tests that do require root access to the system.
- `all_integration_tests`: All of the integration tests defined in the repository.

To execute the integration tests for a test suite, specify the target for the test suite on the
Bazel command line.

```sh
# Execute all of the integration tests
$ bazel test //examples:all_integration_tests
```

### Integration Tests That Require Root Access

Several of the integration tests require root access. Typically, this is to change the default Xcode
version to ensure that certain parameters and/or environment variables select the correct version.
While these tests can be executed using the `sudo` command, this is not recommended. Behind the
scenes, this will intersperse files owned by the root user with ones owned by you. When you go to
execute `bazel test //...` on the `rules_spm` repository, permission errors will occur.

To execute these tests, you have two choices:

1. Configure `NOPASSWD` for the user. This will allow `sudo` to be executed without a password. It
   can be convenient, but it can also be risky.
2. Set up a utility that sends along the password for the `sudo` user using the `SUDO_ASKPASS`
   environment variable. The integration tests are configured to pass along `SUDO_ASKPASS` from your
   environment to the integration test. If the environment variable is detected the `sudo` command 
   is configured to execute the utility referenced by the `SUDO_ASKPASS` environment variable. 

#### Set Up Askpass Utility for macOS

The following describes how to set up an askpass utility on macOS.

Create the following script in your PATH (e.g. `/usr/local/bin/askpass.sh`) and make it executable.

```sh
#!/usr/bin/env zsh

set -euo pipefail

pw="$(osascript -e 'Tell application "System Events" to display dialog "Password:" default answer "" with hidden answer' -e 'text returned of result' 2>/dev/null)"
echo "${pw}"
```

Test the utility by executing it from the command line. You should be prompted with a basic,
password dialog. Enter some random text and press enter. You should see the text that you entered
printed to the terminal.

Now that we are sure that the utility works, we need to set up the environment variable. Update your
`.zshrc` to set the `SUDO_ASKPASS` environment variable.

```sh
# Set the SUDO_ASKPASS env variable if the askpass utility exists.
askpass=/usr/local/bin/askpass.sh
[[ -f "${askpass}" ]] && export SUDO_ASKPASS="${askpass}"
```

Open a new terminal window or source your `~/.zshrc` in an existing terminal window to set the
environment variable. To test that the utility, execute the following:

```sh
$ sudo -A echo "Hello"
```

You will be prompted for your password. Enter your real password and hit enter. You should see
`Hello` print to the terminal window.

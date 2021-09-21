<!-- Generated with Stardoc, Do Not Edit! -->
# `repository_utils` API

<a id="#repository_utils.is_macos"></a>

## repository_utils.is_macos

<pre>
repository_utils.is_macos(<a href="#repository_utils.is_macos-repository_ctx">repository_ctx</a>)
</pre>

Determines if the host is running MacOS.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="repository_utils.is_macos-repository_ctx"></a>repository_ctx |  A <code>repository_ctx</code> instance.   |  none |


<a id="#repository_utils.exec_spm_command"></a>

## repository_utils.exec_spm_command

<pre>
repository_utils.exec_spm_command(<a href="#repository_utils.exec_spm_command-repository_ctx">repository_ctx</a>, <a href="#repository_utils.exec_spm_command-arguments">arguments</a>, <a href="#repository_utils.exec_spm_command-env">env</a>, <a href="#repository_utils.exec_spm_command-working_directory">working_directory</a>, <a href="#repository_utils.exec_spm_command-err_msg_tpl">err_msg_tpl</a>)
</pre>

Executes a Swift package manager command and returns the stdout.

If the command returns a non-zero return code, this function will fail.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="repository_utils.exec_spm_command-repository_ctx"></a>repository_ctx |  A <code>repository_ctx</code> instance.   |  none |
| <a id="repository_utils.exec_spm_command-arguments"></a>arguments |  A <code>list</code> of arguments which will be executed.   |  none |
| <a id="repository_utils.exec_spm_command-env"></a>env |  A <code>dict</code> of environment variables that will be included in the command execution.   |  <code>{}</code> |
| <a id="repository_utils.exec_spm_command-working_directory"></a>working_directory |  Working directory for command execution. Can be relative to the repository root or absolute.   |  <code>""</code> |
| <a id="repository_utils.exec_spm_command-err_msg_tpl"></a>err_msg_tpl |  Optional. A <code>string</code> template which will be formatted with the <code>exec_args</code> and <code>stderr</code> values.   |  <code>None</code> |



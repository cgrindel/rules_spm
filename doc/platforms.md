<!-- Generated with Stardoc, Do Not Edit! -->
# `platforms` API


<a id="#platforms.spm_os"></a>

## platforms.spm_os

<pre>
platforms.spm_os(<a href="#platforms.spm_os-swift_os">swift_os</a>)
</pre>

Maps the Swift OS value to a suitable SPM OS value.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="platforms.spm_os-swift_os"></a>swift_os |  A <code>string</code> representing the Swift OS value.   |  none |

**RETURNS**

A `string` representing the SPM OS value.


<a id="#platforms.spm_arch"></a>

## platforms.spm_arch

<pre>
platforms.spm_arch(<a href="#platforms.spm_arch-swift_cpu">swift_cpu</a>)
</pre>

Maps the Bazel architeture value to a suitable SPM architecture value.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="platforms.spm_arch-swift_cpu"></a>swift_cpu |  A <code>string</code> representing the Swift CPU.   |  none |

**RETURNS**

A `string` representing the SPM architecture value.


<a id="#platforms.spm_vendor"></a>

## platforms.spm_vendor

<pre>
platforms.spm_vendor(<a href="#platforms.spm_vendor-swift_os">swift_os</a>)
</pre>

Maps the Swift OS value to the corresponding SPM vendor value.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="platforms.spm_vendor-swift_os"></a>swift_os |  A <code>string</code> representing the Swift OS value.   |  none |

**RETURNS**

A `string` representing the SPM vendor value.



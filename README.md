# Hardening Playbook

## Abstract

An opinionated minimal-compromises guide to configuring a maximally secure
server for high stakes use cases where privacy and security are favored over
compatibility, cost, or effeciency.

This intends to be largely a showcase of the work of others and act as a
starting point for researching this space.

## Threat Profile

* Target protects:
  * Automated air/ground transportation
  * Nuclear weapons
  * Electric grid
  * Medical implants
  * Dive computers
  * Secrets that could end any entity
  * Access to unlimited financial gain
  * Human lives
* Attacker has
  * No ethics
  * unlimited funding
  * decades of patience
  * Knowledge deeper than yours of every component
  * 0-days of any currently known class
* Attacker can
  * compromise any single point in the supply chain
  * compromise any single system
  * compromise any single individual
* Attacker wants
  * Theft (cryptocurrency, bank accounts, stock tips, blackmail, databases)
  * Sabotage (to a company or country for any reason)
  * Chaos (May not be rational)

## Design

* Favor security and privacy over efficiency
* Every system:
  * is treated as a single purpose immutable appliance
  * replaced not updated
* Every component must be:
  * auditable by anyone
  * reproducible deterministically by anyone
  * audited by multiple reputable third parties.
  * fail on any unathorized physical tampering attempt
  * handle cryptographic operations in constant time
  * maintain secret keys physically separate from networks
  * have the bare minimum resources to complete its intended function

## Implementation

### Kernel

#### Overview

While Linux is certianly not designed for out-of-the-box high security it is
the most portable for the widest range of use cases and has the largest number
of deployments so advice in this section will assume it.

If your application does not require a Linux kernel it is suggested the reader
is encouraged to carefully consider security-focused Operating System projects
like OpenBSD, FreeBSD, FreeRTOS, or seL4.

Some of these features don't ship with any published binary kernels for any
major distribution so it is assumed the reader will compile their own kernel
with a hardened toolchain following the advice in the Toolchain section of this
document.

#### Recommendations

##### GCC Options

###### Kernel Address Space Layout Randomization (-fPIE -pie)
###### RElocation Read-Only ELF Hardening (-Wl,-z,relro)
###### Stack Canaries (-fstack-protector-all)
###### Stack Clash Protection  (-fstack-clash-protction)
###### Stack Shellcode Execution (-z execstack)
###### Glibc Hardening (-DFORTIFY_SOURCE=2)
###### Glibc++ Hardening (-Wp, -D_GLIBCXX_ASSERTIONS)

##### Config Flags

###### CONFIG_GCC_PLUGINS=y
* Intention:
  * Allow usage of static analysis plugins in GCC at kernel compile time
* Resources:
  * Writeup: [Kernel building with GCC Plugins][1]

[1]: https://lwn.net/Articles/691102/

###### CONFIG_GCC_PLUGIN_STACKLEAK=y
* Intention:
  * limit exfiltration of recycled stack memory
  * stack poisoning mitigation
  * runtime stack overflow detection
* Resources:
  * Talk: [STACKLEAK: A Long Way to the Linux Kernel Mainline - A. Popov][1]
  * Writeup: [How STACKLEAK improves Linux Security - A. Popov][2]
  * Patch: [#9778761](https://patchwork.kernel.org/patch/9778761/)

[1]: https://www.youtube.com/watch?v=5wIniiWSgUc
[2]: https://a13xp0p0v.github.io/2018/11/04/stackleak.html

###### CONFIG_GCC_PLUGIN_STRUCTLEAK=y
* Platforms: x86_64, arm64
* Intention:
  * Force all structure initialization before usage by other functions
* Resources:
  * Writeup:
  * Patch:

###### CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL=y
* Platforms: x86_64, arm64
* Intention:
  *
* Resources:
  * Writeup:
  * Patch:

###### CONFIG_GCC_PLUGIN_LATENT_ENTROPY=y
* Platforms: x86_64, arm64
* Intention:
  * Gather additional entropy at boot time as some systems have bad sources
* Resources:
  * Writeup:
  * Patch:

###### CONFIG_GCC_PLUGIN_RANDSTRUCT=y
* Platforms: x86_64, arm64
* Intention:
  * 
* Resources:
  * Writeup:
  * Patch:

###### CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
* Platforms: x86_64, arm64
* Intention:
  * 
* Resources:
  * Writeup:
  * Patch:

###### CONFIG_RANDOMIZE_BASE=y
* Platforms: x86_64, arm64
* Intention:
  * 
* Resources:
  * Writeup:
  * Patch:

###### CONFIG_RANDOMIZE_MEMORY=y
* Platforms: x86_64
* Intention:
  * 
* Resources:
  * Writeup:
  * Patch:

###### CONFIG_LEGACY_VSYSCALL_NONE=y
* Platforms: x86_64
* Intention:
  * Remove vsyscall entirely avoiding it as a fixed-position ROP target.
* Resources:
  * Writeup: [On vsyscalls and the vDSO][1]
  * Patch:

[1]: https://lwn.net/Articles/446528/

###### CONFIG_PAGE_TABLE_ISOLATION=y
* Platforms: x86_64
* Intention:
  * 
* Resources:
  * Writeup:
  * Patch:

###### CONFIG_IA32_EMULATION=n
* Platforms: x86_64
* Intention:
  * Disable 32 bit program emulation and all related attack classes.
* Resources:
  * Writeup:
  * Patch:

###### CONFIG_X86_X32=n
* Platforms: x86_64
* Intention:
  * 
* Resources:
  * Writeup:
  * Patch:

###### CONFIG_MODIFY_LDT_SYSCALL=n
* Platforms: x86_64
* Intention:
  * 
* Resources:
  * Writeup:
  * Patch:

###### CONFIG_ARM64_SW_TTBR0_PAN=y
* Platforms: arm64
* Intention:
  * 
* Resources:
  * Writeup:
  * Patch:

###### CONFIG_UNMAP_KERNEL_AT_EL0=y
* Platforms: arm64
* Intention:
  * Kernel Page Table Isolation
  * Remove an entire class of cache timing side-channels.
* Resources:
  * Writeup:
  * Patch:

##### Boot Options

###### slub_debug=P
* Platforms: x86_64, arm64
* Intention:
  * 
* Resources:
  * Writeup:
  * Patch:

###### page_poison=1
* Platforms: x86_64, arm64
* Intention:
  * 
* Resources:
  * Writeup:
  * Patch:

###### slab_nomerge
* Platforms: x86_64, arm64
* Intention:
  * 
* Resources:
  * Writeup:
  * Patch:

###### pti=on
* Platforms: x86_64, arm64
* Intention:
  * 
* Resources:
  * Writeup:
  * Patch:

#### Background
* [Fedora Hardening Flags](https://fedoraproject.org/wiki/Changes/HardeningFlags28)
* [Debian Hardening](https://wiki.debian.org/Hardening)
* [RedHat: Recommended GCC Compler Flags](https://developers.redhat.com/blog/2018/03/21/compiler-and-linker-flags-gcc/)
* [Debian Security Checklist](https://hardenedlinux.github.io/system-security/2015/06/09/debian-security-chklist.html)
* [System Down - HN discussion](https://news.ycombinator.com/item?id=18873530)
* [Why OpenBSD is Important To Me - HN Discussion](https://news.ycombinator.com/item?id=11660003)
* [Differences Between ASLR KASLR and KARL](http://www.daniloaz.com/en/differences-between-aslr-kaslr-and-karl/)

### Userspace

#### Recommendations
##### System Call Filtering

### Compiler
#### Recommendations
#### Background

### Application

#### Recommendations

##### Code Signing
##### Release Management

##### Memory Management
* Favor memory safe languages designed for security: Go, Rust, Zig
* Consider a Hardened Memory allocator (hardened_malloc)

##### Third Party Dependencies
* Signed reproducible builds must be possible
* Code must be signed with a well-known key of author and ideally reviewer(s)
* Consider reviews by any distribution channel maintainers
* Always assume force pushes and tag clobbers: pin hashes
* Assume upstreams will dissipear without warning: mirror everything yourself

#### Background
* OpenBSD coding practices

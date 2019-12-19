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

### Code Review (WIP)

#### Overview
#### Recommendations

* Decentralized
* Multisig
* Coding practices

### Dependency Management (WIP)
#### Overview
#### Recommendations

* review practices
* Signed reproducible builds must be possible
* Code must be signed with a well-known key of author and ideally reviewer(s)
* Consider reviews by any distribution channel maintainers
* Always assume force pushes and tag clobbers: pin hashes
* Assume upstreams will vanish without warning: mirror everything yourself

#### Background

### Release Management (WIP)
#### Overview
#### Recommendations

* Reproducible builds
* Signing

#### Background

### Static Application Security Testing (WIP)

#### Overview

Static analysis analyzes source code or compiled binaries for security flaws.
A critical part of a security focused software development is using tools
to help catch common human errors before code hits production.

Memory bugs are most common and where possible one should favor memory safe
languages designed for security: Rust, Go, OCaml, Zig

#### Recommendations

##### Language Agnostic

* Google CodeSearchDiggity
* Graudit
* LGTM
* SonarQube
* VisualCodeGrepper

##### Bash
* shellcheck

##### Node.js
* synode

##### C/C++
* BOON
* CQual
* xg++
* Eau Claire tool
* MOPS
* Split
* Flawfinder
* PreFast

##### C#
* Puma Scan
* .Net Security Guard

##### Python
* Bandit

##### Ruby
* Brakeman
* Codesake Dawn

##### Java
* SpotBugs
* PMD

##### PHP
* progpilot
* RIPS
* pgpcs-security-audit

#### Background

* https://www.owasp.org/index.php/Source_Code_Analysis_Tools

### Sandboxing (WIP)

#### Overview
#### Recommendations

##### SELinux
##### Apparmor
##### Seccomp
##### cgroups
##### namespacing

### Filesystem (WIP)

Everything on unix is a file, and as such filesystem mount options and
permissions are one of the most effective ways to restrict what can or can't
be done in a given directory.

Everything should be either a read-only filesystem like quashfs or a tmpfs.
Never allow writes to root filesystem.

This is all managed via /etc/fstab

#### Overview

#### Recommendations

##### Mount options

###### Restrict /proc so users can only see their own processes
* Usage: ```proc /proc proc defaults,hidepid=2 0 0```

###### Disable suid binaries in /dev
* Usage: ```udev /dev devtmpfs defaults,nosuid,noexec,noatime 0 0```

###### Force mode 0666 in /dev/pts
* Usage: ```devpts /dev/pts devpts defaults,newinstance,ptmxmode=0666 0 0```

###### Use tmpfs for /dev/shm and restrict suid, exec, and dev
* Usage: ```tmpfs /dev/shm tmpfs defaults,nodev,nosuid,noexec 0 0```

###### Use tmpfs for /tmp and disable devices, suid binaries, and exec
* Usage: ```tmpfs /tmp tmpfs nodev,nosuid,noexec,size=2G 0 0```

###### Bind /var/tmp to /tmp and restrict suid, exec, and dev
* Usage: ```/tmp /var/tmp none rw,noexec,nosuid,nodev,bind 0 0```

##### Encryption

* luks
* luks + sgx

##### Resources

* Cold boot attacks

### Toolchain

#### Overview

#### Recommendations

##### GCC/Binutils Options

###### Indirect Branching
* Usage: ```-mindirect-branch=thunk-extern```
* Intention:
  * Speculative execution is incompatible with call/return thunks
  * Convert indirect calls and jumps to call and return thunks
  * Used in Spectre v2 attack mitigations to prevent CPU branch speculation
* Notes:
  * thunk: create one thunk section per input file
  * thunk-inline: create one per indirect branch or function return
  * thunk-extern: one thunk section for entire program in separate object file
* Resources:
  * https://en.wikipedia.org/wiki/Indirect_branch
  * https://www.phoronix.com/scan.php?page=article&item=gcc8-mindirect-thunk&num=1
  * https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.14.15&id=3a72bd4b60da338e66922e4f9eded174b3ad147d
  * https://patchwork.ozlabs.org/patch/856627/

###### Stack Canaries
* Usage: ```-fstack-protector-strong```
* Intention:
  * Plant random "canary" integers just before stack return pointers
  * Buffer overflows hijacking return pointer will normally modify canary
  * Ensure canary is still present before a routine uses a pointer on stack
* Resources:
  * https://outflux.net/blog/archives/2014/01/27/fstack-protector-strong/
  * https://en.wikipedia.org/wiki/Buffer_overflow_protection#Canaries

###### Position Independent Executables (PIE)
* Usage:
  * Statically compiled: ```-static-pie```
  * Allow linking PICs: ```-fPIE -pie```
* Intention:
  * Only allow PIC libraries to be linked into executables
  * When used in with ASLR, all program memory is allocated randomly together
  * Increase difficulty of using exploits that assume a specific memory layout
* Resources:
  * http://www.openbsd.org/papers/nycbsdcon08-pie/
  * https://mropert.github.io/2018/02/02/pic_pie_sanitizers/

###### Position Independant Code (PIC)
* Usage: ```-fpic -shared```
* Intention:
  * Use in conjunction with PIE
  * Compile shared libraries without text relocations
  * Allow shared libraries to be safely linked into a PIE
* Resources:
  * https://flameeyes.blog/2016/01/16/textrels-text-relocations-and-their-impact-on-hardening-techniques/
  * https://access.redhat.com/blogs/766093/posts/1975793
  * http://www.productive-cpp.com/hardening-cpp-programs-executable-space-protection-address-space-layout-randomization-aslr/

###### Stack Clash Protection
* Usage: ```-fstack-clash-protection```
* Intention:
  * Mitigate attacks that rely on colliding neighboring memory regions
  * Defeats most historical stack clashing exploits
* Resources:
  * https://blog.qualys.com/securitylabs/2017/06/19/the-stack-clash
  * https://gcc.gnu.org/ml/gcc-patches/2017-07/msg01112.html

###### Data Execution Prevention (DEP)
* Usage: ```-Wl,-z,noexecstack -Wl,-z,noexecheap```
* Intention:
  * Buffer overflows tend to put code in programs stack and jump to it
  * If all writable addresses are non-executable, the attack is prevented
  * Don't mark memory as executable when it is not required
  * ELF headers are marked with PT_GNU_STACK and PT_GNU_HEAP
  * Set stacks/heaps to be executable only if segment flag calls for it
* Resources:
  * https://www.airs.com/blog/archives/518
  * https://linux.die.net/man/8/execstack

###### Source Fortification
* Usage: ```-DFORTIFY_SOURCE=2```
* Intention:
  * Many programs rely on functions that are not aware of buffer-length
  * Buffer overflow exploits often take advantage of these functions
  * Examples include strncpy, strcpy, memcpy, memset
  * Fail compilation if these are used in obviously unsafe way.
  * Compile with buffer-length aware checks for added run-time detection
  * Kill execution if buffer overflow check fires
* Resources:
  * https://github.com/intel/safestringlib/wiki/FORTIFY-SOURCE-and-Safe-String-Library
  * https://idea.popcount.org/2013-08-15-fortify_source/

###### Run-time bounds checking for C++ strings/containers
* Usage: ```-Wp, -D_GLIBCXX_ASSERTIONS```
* Intention:
  * Turn on cheap range checks for C++ arrays, vectors, and strings
  * Add Null pointer checks when dereferencing smart pointers
* Resources:
  * https://gcc.gnu.org/onlinedocs/libstdc++/manual/using_macros.html

###### Hardening Quality Control
* Usage: ```-plugin=annobin```
* Intention:
  * Include extra metadata in binary files to assist static analysis tools
  * Can be used by scripts to verify hardening options or ABI conflicts
* Resources:
  * https://fedoraproject.org/wiki/Changes/Annobin
  * https://fedoraproject.org/wiki/Toolchain/Watermark
  * https://developers.redhat.com/blog/2018/02/20/annobin-storing-information-binaries/

###### Zero Caller Saved Registers
* Usage: ```-mzero-caller-saved-regs=all```
* Notes:
  * Requires GCC patch
* Intention:
  * Clear caller-saved general registers on function return
  * Make ROP, COP, and JOP attacks harder
* Resources:
  * https://github.com/clearlinux-pkgs/gcc/blob/master/zero-regs-gcc8.patch

###### Control-Flow Enforcement Technology (CET)
* Usage: ```-mcet -fcf-protection=full```
* Notes:
  * Can only be used -future- Intel CPUs
* Intention:
  * Leverage a read-only "shadow stack" preventing injection of special entries
  * Check for valid target addresses of control-flow transfers
  * Prevent diverting flow of control to an unexpected target
  * Intel claims this will replace retpolines to stop Spectre v2 attacks
* Resources:
  * https://lwn.net/Articles/758245/
  * https://ai.google/research/pubs/pub42808
  * https://clang.llvm.org/docs/ControlFlowIntegrity.html
  * https://clearlinux.org/blogs/gnu-compiler-collection-8-gcc-8-transitioning-new-compiler

###### Format Security
* Usage: ```-Werror=format-security```
* Intention:
  * Error on poorly defined format functions that can be exploited
  * Expect string literal and format arguments for sprintf/scanf and similar
* Resources:
  * https://fedoraproject.org/wiki/Format-Security-FAQ
  * https://security.stackexchange.com/questions/45308/is-there-a-way-to-evade-wformat-security

###### Reject missing function prototypes
* Usage: ```-Werror=implicit-function-declaration```
* Intention:
  * Undeclared functions can be interpreted by compilers in unexpected ways
  * Ensure undeclared functions break builds so they can be addressed
* Intention:
  * https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
  * https://bugzilla.mozilla.org/show_bug.cgi?id=335275
  * https://devzone.nordicsemi.com/f/nordic-q-a/25277/implicit-declaration-of-function

###### Reject undefined symbols
* Usage: ```-Wl,-z,defs```
* Intention:
  * Many attacks rely on taking control of undefined symbols
  * Disallow undefined symbols when creating object files
* Resources:
  * https://bugzilla.mozilla.org/show_bug.cgi?id=333640
  * https://linux.die.net/man/1/ld

###### RElocation Read-Only ELF Hardening
* Usage: ```-Wl,-z,relro,-z,now```
* Intention:
  * Lazy binding loads libraries into memory when first accessed
  * A reference is left in the Global Offset Table in a known location
  * Having a well known memory addreseses makes an attackers job easier
  * Make shared libraries read-only after dynamic relocations are applied
  * Limit ability of attacker to overwrite GOT entries to shared functions
  * Disable lazy binding and force "now" binding
* Note:
  * Will result in slower application startup
* Resources:
  * https://www.airs.com/blog/archives/189
  * http://blog.siphos.be/2011/07/high-level-explanation-on-some-binary-executable-security/

##### C/POSIX Standard Library Implementation

###### musl
* Notes:
  * Small binaries (~13k hello world vs ~600k with glibc)
  * Small .a/.so footprint (~1MB vs ~10MB for glibc)
  * Small codebase designed to be easy to audit
  * Supported by security focused Linux distros (linuxkit, gentoo, alpine)
  * Low-memory or resource exhaustion conditions are never fatal
  * Wider support for microcontrollers and embedded targets than glibc
  * Rapid termination on security violation to limit attacks on error codepaths
  * Can build itself with ASLR to catching internal stack-smashing
  * Double-Free protection (as possible)
  * Moderate heap-overflow detection
  * Use PIE together with static-linking
  * Limited machine-specific code minimizing chances of minority arch breakage
  * Limit buggy translations via forced literal strings without format strings
  * Block all LD_* for suid/sgid binaries limiting runtime behavior overrides
  * Non-use of arbitrary-size VLA/alloca, minimal dynamic allocation
  * Avoid subtle race condition and async-signal safety issues found in glibc
  * Attempts to remove all undefined behavior. Less code == less bugs
  * Safe, fully-standards-conforming UTF-8 (source of many security bugs)
  * Consistent results even under transient errors without silent fallbacks
  * Lazy/Late allocations that would abort on failure are unsupported
* Resources:
  * https://wiki.musl-libc.org/functional-differences-from-glibc.html
  * https://wiki.gentoo.org/wiki/Project:Hardened_musl
  * https://www.openwall.com/lists/musl/2016/02/11/4

#### Background

* http://www.etalabs.net/compare_libcs.html
* https://gcc.gnu.org/onlinedocs/gcc/Code-Gen-Options.html
* https://www.owasp.org/index.php/C-Based_Toolchain_Hardening#GCC.2FBinutils
* http://www.trapkit.de/tools/checksec.html

### Kernel

#### Overview

While Linux is certianly not designed for out-of-the-box high security it is
the most portable for the widest range of use cases and has the largest number
of deployments so advice in this section will assume it.

If your application does not require a Linux kernel it is suggested the reader
carefully consider security-focused alternatives like OpenBSD, FreeBSD,
FreeRTOS, or seL4.

Some of these features don't ship with any published binary kernels for any
major distribution so it is assumed the reader will compile their own kernel
with a hardened toolchain following the advice in the Toolchain section of this
document.

#### Recommendations

##### Boot Options (WIP)

###### slub_debug=FZP
* Platforms: x86_64, arm64
* Intention:
  * Enable sanity checks (F), Redzoning (Z), and Poisoning (P)
  * Set slub debugging to poison mode
* Resources:
  * [Kernel.org: Short users guide for SLUB][1]
  * [][2]

[1]: https://www.kernel.org/doc/Documentation/vm/slub.txt
[2]:

###### page_poison=1
* Platforms: x86_64, arm64
* Intention:
  *
* Resources:
  * [][1]
  * [][2]

[1]:
[2]:

###### slab_nomerge
* Platforms: x86_64, arm64
* Intention:
  *
* Resources:
  * [][1]
  * [][2]

[1]:
[2]:

###### pti=on
* Platforms: x86_64, arm64
* Intention:
  *
* Resources:
  * [][1]
  * [][2]

[1]:
[2]:

##### Sysctl Options

###### Avoid kernel address exposures in /proc files (kallsyms, modules, etc).
* Usage: ```kernel.kptr_restrict = 1```
* Intention:
  * Attackers often seek to write to kernel writable structures
  * Hide kernel pointers normally present in /proc
  * Exploits have harder time discovering kernel addresses/symbols
* Resources:
  * https://lwn.net/Articles/420403/
  * http://bits-please.blogspot.com/2015/08/effectively-bypassing-kptrrestrict-on.html

###### Restrict Kernel Syslog Access
* Usage: ```kernel.dmesg_restrict = 1```
* Intention:
  * Kernel logs often contain sensitive information like memory addresses
  * Forbid dmesg access to binaries that lack CAP_SYS_ADMIN capability.
* Resources:
  * https://wiki.archlinux.org/index.php/security#Restricting_access_to_kernel_logs
  * https://lwn.net/Articles/414813/

###### Restrict Performance Event Access
* Usage: ```kernel.perf_event_paranoid = 3```
* Intention:
  * Access to kernel perf event interface aids adversaries in targets attacks
  * Disallow access to CPU events, kernel profiling, tracepoints etc
* Resources:
  * https://lwn.net/Articles/696216/
  * https://patchwork.kernel.org/patch/9249919/

###### Explicitly Disable Kexec
* Usage: ```kernel.kexec_load_disabled = 1```
* Intention:
  * The Kexec interface is complex, and allows replacement of kernel in memory
  * This allows fast "reboots" but is very dangerous if exploited
  * Kernel memory should be immutable in a conservative security system
  * Disable /dev/kmem and any potential kernel exploits that may use it
* Resources:
  * https://lwn.net/Articles/580269/
  * https://security.stackexchange.com/questions/139463/why-protect-the-linux-kernel-from-the-root-user

###### Avoid non-ancestor ptrace access to running processes and their credentials.
* Usage: ```kernel.yama.ptrace_scope = 3```
* Intention:
  * Deny ptrace access to any process
  * Prevent leaking sensitive memory to malware via debug interfaces
* Notes:
  * Will make debugging tools like strace and gdb unusuable
* Resources:
  * https://www.kernel.org/doc/Documentation/security/Yama.txt
  * https://linux-audit.com/protect-ptrace-processes-kernel-yama-ptrace_scope/

###### Disable User Namespaces
* Usage: ```user.max_user_namespaces = 0```
* Intention:
  * User namespaces are buggy and have been exploited many times
  * Bugs have often resulted in privesc exploits
  * Disable feature if you don't need it
* Note:
  * Container systems like docker rely heavily on user namespaces
* Resources:
  * https://lwn.net/Articles/673597/
  * https://docs.docker.com/engine/security/userns-remap/
  * https://dock.co.nz/post/linux-user-namespaces-security-concerns/

###### Disable Unprivileged eBPF
* Usage: ```kernel.unprivileged_bpf_disabled = 1```
* Intention:
  * BPF is a kernel VM that allows unprivileged users to run code in the kernel
  * This is added attack surface for most use cases, and should be disabled
* Resources:
  * https://lwn.net/Articles/660331/
  * https://kernelnewbies.org/Linux_4.4#Unprivileged_eBPF_.2B-_persistent_eBPF_programs

###### Turn on BPF JIT hardening, if the JIT is enabled.
* Usage: ```net.core.bpf_jit_harden = 2```
* Intention:
  * Use more secure but slower codepaths for BPF JIT for all users
  * Enables blinding and disables some tracing/debugging functionality
* Resources:
  * https://docs.cilium.io/en/v1.3/bpf/#hardening
  * https://lists.openwall.net/netdev/2018/05/23/84
  * https://lwn.net/Articles/723872/

##### Config Flags (WIP)

###### CONFIG_GCC_PLUGINS=y
* Intention:
  * Allow usage of static analysis plugins in GCC at kernel compile time
* Resources:
  * [Kernel building with GCC Plugins][1]
  * [Kernel.org GCC Plugin Documentation][2]

[1]: https://lwn.net/Articles/691102/
[2]: https://www.kernel.org/doc/Documentation/gcc-plugins.txt)

###### CONFIG_GCC_PLUGIN_STACKINIT=y
* Platforms: x86_64, arm64
* Intention:
  * Exploits often take advantage of uninitalized variables
  * Force unconditional initialization of all stack variables
* Resources:
  * [Patch: Introduce stackinit plugin][1]

[1]: https://patchwork.kernel.org/patch/9518595/

###### CONFIG_GCC_PLUGIN_STACKLEAK=y
* Intention:
  * limit exfiltration of recycled stack memory
  * stack poisoning mitigation
  * runtime stack overflow detection
* Resources:
  * [STACKLEAK: A Long Way to the Linux Kernel Mainline - A. Popov][1]
  * [How STACKLEAK improves Linux Security - A. Popov][2]
  * [Patch: Introduce stackleak plugin][3]

[1]: https://www.youtube.com/watch?v=5wIniiWSgUc
[2]: https://a13xp0p0v.github.io/2018/11/04/stackleak.html
[3]: https://patchwork.kernel.org/patch/9518595/

###### CONFIG_GCC_PLUGIN_STRUCTLEAK=y
* Platforms: x86_64, arm64
* Intention:
  * Force all structure initialization before usage by other functions
* Resources:
  * [Patch: Introduce structleak plugin][1]

[1]: https://lwn.net/Articles/711692/

###### CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL=y
* Platforms: x86_64, arm64
* Intention:
  * Extend CONFIG_GCC_PLUGIN_STRUCTLEAK to include pass-by-reference variables
* Resources:
  * [LKDDB: Force initialize all struct type variables passed by reference][1]

[1]: https://cateee.net/lkddb/web-lkddb/GCC_PLUGIN_STRUCTLEAK_BYREF_ALL.html

###### CONFIG_GCC_PLUGIN_LATENT_ENTROPY=y
* Platforms: x86_64, arm64
* Intention:
  * Some systems have known issues generating hardware entropy in early boot
  * insert local variable in loop counts, cases, branching, etc
  * Permuate a global variable based on value changes to marked functions
  * Use global variable to help seed early boot entropy pool
* Notes:
  * Many of the sources of entropy here are deterministic.
  * It is not advised to rely on this plugin alone. Use a TRNG where possible.
* Resources:
  * [Kernel.org: Add latent_entropy plugin][1]
  * [Cryptography ML post addressing limitations][2]

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=38addce8b600ca335dc86fa3d48c890f1c6fa1f4

###### CONFIG_GCC_PLUGIN_RANDSTRUCT=y
* Platforms: x86_64, arm64
* Intention:
  * Randomize the layout of selected structures at compile time
  * Defend against attacks rely on struct knowledge
* Resources:
  * [LWN: Randomizing structure layout][1]
  * [Openwall: RANDSTRUCT Patches][2]

[1]: https://lwn.net/Articles/722293/
[2]: https://www.openwall.com/lists/kernel-hardening/2017/04/06/14

###### CONFIG_RETPOLINE=y
* Platforms: x86_64, arm64
* Intention:
  * Infinite loops prevent CPUs from speculating the target of an indirect jump
  * Attach infinite loop to every return call as a "return trampoline"
  * Never actually execute this infinite loop
  * Mitigates kernel or cross-process memory disclosure attacks like Spectre
* Notes:
  * Use in combination with -mindirect-branch=thunk-extern in GCC8
  * Edge case: When an RSB empties, Skylake+ uses vulnerable BTB prediction
  * Also apply vendor firmware mitigations where possible
* Resources:
  * [Retpoline: a software construct for preventing branch-target-injection][1]
  * [Mitre: CVE-2017-5715][2]
  * [lkml Retpoline Discission][3]
  * [Kernel.org: Retpoline patch][4]
  * [Intel: Host Firmware Speculative Execution Side Channel Mitigation]

[1]: https://support.google.com/faqs/answer/7625886
[2]: https://cve.mitre.org/cgi-bin/cvename.cgi?name=2017-5715
[3]: https://lkml.org/lkml/2018/1/4/724
[4]: https://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git/commit/?h=spec/retpoline-415-1
[5]: https://software.intel.com/security-software-guidance/insights/host-firmware-speculative-execution-side-channel-mitigation

###### CONFIG_HARDENED_USERCOPY=y
* Platforms: x86_64, arm64
* Intention:
  * 
* Resources:
  * [LWN: Hardened Usercopy][1]
  * [][2]

[1]: https://lwn.net/Articles/695991/

###### CONFIG_CC_STACKPROTECTOR_STRONG=y
* Platforms: x86_64, arm64
* Intention:
  *
* Resources:
  * [][1]
  * [][2]

[1]:
[2]:

###### CONFIG_STRICT_KERNEL_RWX=y
* Platforms: x86_64, arm64
* Intention:
  *
* Resources:
  * [][1]
  * [][2]

[1]:
[2]:

###### CONFIG_DEBUG_RODATA=y
* Platforms: x86_64, arm64
* Intention:
  *
* Resources:
  * [][1]
  * [][2]

[1]:
[2]:


###### CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_RANDOMIZE_BASE=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_RANDOMIZE_MEMORY=y
* Platforms: x86_64
* Intention:
  *

###### CONFIG_LEGACY_VSYSCALL_NONE=y
* Platforms: x86_64
* Intention:
  * Remove vsyscall entirely avoiding it as a fixed-position ROP target.
* Resources:
  * [LWN: On vsyscalls and the vDSO][1]
  * [][2]

[1]: https://lwn.net/Articles/446528/
[2]:

###### CONFIG_PAGE_TABLE_ISOLATION=y
* Platforms: x86_64
* Intention:
  *

###### CONFIG_IA32_EMULATION=n
* Platforms: x86_64
* Intention:
  * Disable 32 bit program emulation and all related attack classes.

###### CONFIG_X86_X32=n
* Platforms: x86_64
* Intention:
  *

###### CONFIG_MODIFY_LDT_SYSCALL=n
* Platforms: x86_64
* Intention:
  *

###### CONFIG_ARM64_SW_TTBR0_PAN=y
* Platforms: arm64
* Intention:
  *

###### CONFIG_UNMAP_KERNEL_AT_EL0=y
* Platforms: arm64
* Intention:
  * Kernel Page Table Isolation
  * Remove an entire class of cache timing side-channels.

###### CONFIG_BUG=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_STRICT_KERNEL_RWX=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_DEBUG_WX=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_STRICT_DEVMEM=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_IO_STRICT_DEVMEM=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_SYN_COOKIES=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_DEBUG_CREDENTIALS=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_DEBUG_NOTIFIERS=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_DEBUG_LIST=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_DEBUG_SG=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_BUG_ON_DATA_CORRUPTION=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_SCHED_STACK_END_CHECK=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_SECCOMP=y
* Platforms: x86_64, arm64
* Intention:
  *
* Resources:
  * https://docs.docker.com/engine/security/seccomp/

###### CONFIG_SECCOMP_FILTER=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_SECURITY=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_SECURITY_YAMA=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_HARDENED_USERCOPY=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_SLAB_FREELIST_RANDOM=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_SLAB_FREELIST_HARDENED=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_SLUB_DEBUG=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_PAGE_POISONING=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_PAGE_POISONING_NO_SANITY=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_PAGE_POISONING_ZERO=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_VMAP_STACK=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_REFCOUNT_FULL=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_FORTIFY_SOURCE=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_ACPI_CUSTOM_METHOD=n
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_COMPAT_BRK=n
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_DEVKMEM=n
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_PROC_KCORE=n
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_COMPAT_VDSO=n
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_KEXEC=n
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_HIBERNATION=n
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_BINFMT_MISC=n
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_LEGACY_PTYS=n
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_SECURITY_SELINUX_DISABLE=n
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_PANIC_ON_OOPS=y
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_PANIC_TIMEOUT=-1
* Platforms: x86_64, arm64
* Intention:
  *

###### CONFIG_MODULES=n
* Platforms: x86_64, arm64
* Intention:
  *

#### Background
* [Fedora Hardening Flags](https://fedoraproject.org/wiki/Changes/HardeningFlags28)
* [Android Kernel Hardening](https://source.android.com/devices/architecture/kernel/hardening)
* [ChromeOS Kernel Configs](https://chromium.googlesource.com/chromiumos/third_party/kernel/+/80b921861fdfebef21c2841ecc71d40b9d6b5550/chromeos/config/x86_64)
* [Debian Hardening](https://wiki.debian.org/Hardening)
* [Ubuntu Compiler Flags](https://wiki.ubuntu.com/ToolChain/CompilerFlags)
* [Arch LInux Security](https://wiki.archlinux.org/index.php/security)
* [Securing Debian Howto](https://www.debian.org/doc/manuals/securing-debian-howto/index.en.html#contents)
* [RedHat: Recommended GCC Compler Flags](https://developers.redhat.com/blog/2018/03/21/compiler-and-linker-flags-gcc/)
* [Debian Security Checklist](https://hardenedlinux.github.io/system-security/2015/06/09/debian-security-chklist.html)
* [System Down - HN discussion](https://news.ycombinator.com/item?id=18873530)
* [Why OpenBSD is Important To Me - HN Discussion](https://news.ycombinator.com/item?id=11660003)
* [Differences Between ASLR KASLR and KARL](http://www.daniloaz.com/en/differences-between-aslr-kaslr-and-karl/)
* [Linuxkit Security](https://github.com/linuxkit/linuxkit/blob/master/docs/security.md)

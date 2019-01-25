# Hardening Playbook

## Threat Profile

* Target protects:
  * Automated air/ground transportation
  * Nuclear weapons
  * Electric grid
  * Medical implants
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

### Design

* Every system is treated as a single purpose immutable appliance
* Every system is replaced not updated
* Every system has only the bare minimum to run a given application
* Every component must be auditable by anyone
* Every component must be reproducible deterministically by anyone
* Every component must be audited by multiple reputable third parties.
* Every component must fail on any unathorized physical tampering attempt
* Every compoennt must handle cryptographic operations in constant time
* Every component must maintain secret keys physically separate from networks
* Every component should favor security and privacy over efficiency

## Implementation

### Hardware
#### Recommendations
#### Background

### RNG
#### Recommendations
#### Background

### BIOS
#### Recommendations
#### Background

### Bootloader
#### Recommendations
#### Background

### Kernel

#### Recommendations

##### Enable: STACKLEAK (Formerly PaX)
* TL;DR:
* Talk: https://www.youtube.com/watch?v=5wIniiWSgUc
* Writeup:
* Code:
* Usage:
  ```
    Use GCC flag: ...
  ```

#### Background
* [System Down - exploit discussion](https://news.ycombinator.com/item?id=18873530)

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

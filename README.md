# Hardening Playbook

## Threat profile

* Target protects:
  * Automated air/ground transportation
  * Nuclear weapons
  * Electric grid
  * Medical implants
  * Secrets that could end any entity
  * Access to unlimited financial gain
* Attacker has
  * No ethics
  * unlimited funding
  * decades of patience
  * Knowledge deeper than yours of every component
  * 0-days of any currently known class
* Attacker can
  * compromise any single system
  * compromise any single individual
* Attacker wants
  * Theft (cryptocurrency, bank accounts, stock tips, blackmail, databases)
  * Sabotage (to a company or country for any reason)
  * Chaos (May not be rational)

## Assumptions

* Human lives depend on Linux system hardening
  * Self driving cars
  * Trains
  * Prison security systems
  * Nuclear Power Plants
  * Heavy equipment firmware
  * Medical implant firmware
  * Political dissonants and Journalists
  * War-starting levels of digital assets in both fiat and cryptocurrency
* Anything that can't be verified is backdoored. Trust, but verify.
* At least one engineer with push access to every codebase is compromised
* Any one of every system in a given deployment can be compromised
* Always fail safe: uptime and stability be damned
* Favor security over speed and compatibility always

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

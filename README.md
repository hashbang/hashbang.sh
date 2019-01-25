# Hardening Playbook

### Threat profile
* Attacker has unlimited funding
* Attacker has decades of patience
* Attacker knows everything you do and more
* Attacker has no morals and can break any law
* Attacker can compromise any single system
* Attacker can compromise any single individual

### Assumptions

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

### Implementation

## Hardware

### Recommendations
### Background

## RNG

### Recommendations
### Background

## BIOS

### Recommendations
### Background

## Bootloader

### Recommendations
### Background

## Kernel

### Recommendations

#### Enable: STACKLEAK (Formerly PaX)
* Talk: https://www.youtube.com/watch?v=5wIniiWSgUc
* Code:
* Writeup:
* TL;DR: Use GCC flag: ``````

### Background
* [System Down - exploit discussion](https://news.ycombinator.com/item?id=18873530)

## Userspace

## Recommendations
### System Call Filtering

## Compiler

### Recommendations
### Background

## Application

### Recommendations

#### Code Signing

#### Release Management

#### Memory Management
* Favor memory safe languages designed for security (Go, Rust, Zig)
* Hardened Memory allocator (hardened_malloc)

#### Third Party Dependencies
*

### Background
* OpenBSD coding practices

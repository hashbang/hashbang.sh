---
$title: Personal HSMs
$titles:
  nav: Docs
  side: Welcome
$category: Book/Security
$order: 8
---

# Personal HSMs

Personal HSMs (Hardware Security Modules) are small hardware devices one uses
to isolate secrets like private key material and prove physical access to a
computer system in addition to traditional text credentials like a username
or a password. The larger an organization gets, or the higher the value a
given individual has access to (directly or indirectly) the higher the
motivation of a bad actor to use or buy a 0-day to compromise a laptop or
smartphone.

While adding the requirement of having to physically insert or touch a device
to a username and password may seem simple, it is something one can not do
remotely. This makes it a highly effective and simple way to greatly limit
damage and data theft from remote attackers.

## Devices

### YubiKey

<img src="/assets/images/yubikey.png" alt="Yubikey Series 5" width="320px" />

[https://www.yubico.com/store/#yubikey-5-series](https://www.yubico.com/store/#yubikey-5-series)

A YubiKey is an inexpensive personal HSM produced by Yubico and widely used by
large organizations such as the US Department of Defense, Facebook and Google.

#### Advantages

 * Many protocols: Challenge/Response, FIDO U2F, TOTP, HTOP, GPG, SSH, etc.
 * Configurable touch requirement for GPG operations
   * Critical for limiting the actions of a remote actor on your sytem
 * Form factor choices:
   * YubiKey 5 Nano, 5c Nano
     * NOT designed to be frequently removed (will damage it).
     * Can be used on mobile devices via USB OTG
   * YubiKey 5 NFC
     * Fits on keychain, portable and suited for use with many systems.
     * Sticks out of laptop which can be an issue for leave-in use cases.
     * Can be used on mobile devices via NFC

#### Disadvantages

 * Hardware design and Source code is not available for public auditing
 * Information on supply chain integrity practices are not made public.
 * Firmware can not be updated
 * Entropy source is controlled entirely by Infineon

#### GnuK FST-01

<img src="/assets/images/fst-01.jpg" alt="Gnuk" width="320px" />

[https://wiki.seeedstudio.com/wiki/FST-01](https://wiki.seeedstudio.com/wiki/FST-01)

The GnuK FST-01 is an STM23 based personal HSM solution available for all
typical GPG workflows such as SSH, code/binary/email signing, encryption, etc.

##### Advantages
 * 100% of source code and hardware design is public and auditable
 * Design is simple and you can make one at home with inexpensive tooling
 * Firmware can be updated

##### Disadvantages
 * Unusable for Second Factor Authentication (2FA) in most services.
   * No support for Challenge/Response, WebAuthN, U2F, TOTP, etc.
 * Information on supply chain integrity practices are not made public.
 * Does not support physical touch allowing a remote attacker unlimited uses
 * Entropy source is controlled entirely by ARM

#### Nitrokey / Librem Key

The Librem Key, Nitrokey, Nitrokey Pro are STM32 based personal
HSMs that boast full compatibility with all YubiKey 5 features with the
exception of physical touch while additionally being fully open software and
hardware.

<img src="/assets/images/nitrokey-pro.jpg" alt="Nitrokey Pro" width="320px" />

[https://www.nitrokey.com/](https://www.nitrokey.com)

##### Advantages
 * 100% of source code and hardware design is public and auditable
 * Information on supply chain integrity practices are public for Librem Key
 * Can do remote attestation of the integrity of another device via Chal/resp
 * Design is simple and you can make one at home with inexpensive tooling
 * Firmware can be updated
 * Has RGB LED to indicate various status messages visually
   * red can mean "error", green for "success" etc.

##### Disadvantages
 * Information on supply chain integrity practices are not made public.
 * Does not support physical touch allowing a remote attacker unlimited uses
 * Entropy source is controlled entirely by ARM

#### Ledger

Personal HSM designed for managing cryptocurrency that also has loadable app
support allowing it to be used for most common use cases.

##### Advantages
 * Most application source code is public and auditable
 * Supports Bluetooth for easier use with mobile apps
 * Most operations can be confirmed on a build-in screen
  * Designed to protect you even when the connected system is compromised

##### Disadvantages
 * Hardware design and OS are not available for public auditing.
 * Large form factor requiring carrying a USB cable for laptop/desktop use
 * Information on supply chain integrity practices are not made public.
 * Entropy source is controlled entirely by ARM

#### Trezor

Personal HSM designed for managing cryptocurrency that also has loadable app
support allowing it to be used for most common use cases.

##### Advantages
 * Hardware design and OS are available for public auditing.
 * Most operations can be confirmed on a build-in screen
  * Designed to protect you even when the connected system is compromised
 * 100% of source code and hardware design is public and auditable

##### Disadvantages
 * Large form factor requiring carrying a USB cable for mobile/laptop/desktop.
 * Information on supply chain integrity practices are not made public.
 * Entropy source is controlled entirely by ARM

#### VivoKey

<img src="/assets/images/vivokey.jpg" alt="Vivokey" width="320px" />

[https://vivokey.com/](https://vivokey.com)

The VivoKey is an NFC-only device designed to cover the bulk of use cases of
the YubiKey while also having space for general user-supplied applications such
as transit pass emulation via the Fidesmo platform. It is Paralyne-C coated and
on a flexible PCB intended for implantation and is currently in human trials.

For people who are not as into scalpels, it would of course be possible to
insert such a device into a watch band or bracelet.

##### Advantages
 * 100% of application code is public and auditable
 * Applications can be updated
 * Very unlikely to be lost

##### Disadvantages
 * Hardware design and JavaCard OS not available for public auditing.
 * Does not support physical touch allowing a remote attacker unlimited uses
 * Entropy source is controlled entirely by NXP

## Setup

### Notes

Yubikey devices are assumed as they are the most common and often the cheapest.
These steps will be mostly relevant to other devices with gpg smartcards.

If you -only- need WebAuthN support (2FA on websites) you do -not- need this
guide.

The following is mostly for power users that want to control their own keys and
use their personal hsm for encryption, decryption, code signing, screen unlock,
ssh, etc.

### Install required software

#### OSX

2FA GUI Only: https://developers.yubico.com/yubioath-desktop/Releases/

GUI + CLI Tools:
```
port install gnupg yubikey-manager yubico-piv-tool pinentry-mac
echo "pinentry-program $(which pinentry-mac)" >> $HOME/.gnupg/gpg-agent.conf
```

#### Windows

GUI Only: https://developers.yubico.com/yubioath-desktop/Releases/

GUI + CLI Tools:
```
C:\> choco install pip yubikey-personalization-tool gpg4win openssh
C:\> pip install --user yubioath-desktop
```

#### Linux

##### Arch

```
pacman -S gpg yubikey-personalization pcsc-tools pcsclite libusb-compat \
 libu2f-host swig gcc python2-pyside python2-click yubioauth-desktop
```

##### Debian

```
$ apt-get install yubikey-personalization yubikey-personalization-gui gpgv2 \
  pinentry-gtk2 swig pyside python-pip
```

##### Ubuntu

```
$ sudo add-apt-repository ppa:yubico/stable
$ sudo apt-get update
$ apt-get install yubikey-personalization yubikey-personalization-gui gpgv2 \
  pinentry-gtk2 swig pyside python-pip yubioauth-desktop
```

### Set PIN

To proceed with GPG operations you must set user/admin pin codes for your key.
It is strongly recommended these be different.

You will use the User pin day to day for things like SSH or GPG but you will
only use the Admin pin in the event you lock yourself out or to change certain
protected settings.

```
gpg2 --change-pin
> 3 # change Admin PIN
> 1 # change User PIN
```

### Set Personal Details

You can optionally set the owner details of your key. There are pros and cons
to this. Someone who finds it will know whose it is and have the ability to
return it to you. They also may have unlimited time to try to extract a key
from it.

Your choice here should depend on how confident you are in your key revocation
story and the hardware protections of your chosen HSM.

All of these are optional.

```
gpg --card-edit
> admin
> name  # your name
> url   # personal or company url
> fetch # URL to fetch public key
> login # your login
> lang  # preferred language
> sex   # your gender
```

### Set Human Interaction Flags

The following will enable security features on the Yubikey that are only
relevant to engineers/developers and are not needed for browser-only workflows.

#### Yubikey 5 Series

Require physical touch for all key operations:

```
ykman openpgp set-touch sig fixed
ykman openpgp set-touch aut fixed
ykman openpgp set-touch enc fixed
```

## Frequently Asked Questions

### Why not a smartphone app?

Smartphone apps like Google Authenticator are certainly better than nothing at
all, and great to protect personal accounts. In a larger organization however
an attacker will simply find a "low-hanging-fruit" user that has a vulnerable
smartphone, and steal codes from that at will.

### Why not SMS?

Most cell phones will blindly connect to anything that claims to be a
compatible cell phone tower, and will use any encryption methods that "tower"
says it supports. This means, in practice, that most SMS can be intercepted by
anyone. In many cases it only takes $20 in hardware and 2TB of disk space.

Even easier methods to intercept SMS may exist if you forward messages through
email, Google Voice, Google Hangouts, or a wearable device such as a Fitbit or
Pebble.

Many services offer to allow SMS as a "backup" method for a Personal HSM.
This entirely defeats the point, and such advice should be ignored.

If you would like to intercept your own SMS messages see:
[http://www.rtl-sdr.com/receiving-decoding-decrypting-gsm-signals-rtl-sdr/]

### What if I lose it?

Obviously you should try really hard not to do this, but life happens. Most
personal services allow you to print out a set of "backup codes" to put aside
as an "escape hatch". With corporate services you would simply contact a
network administrator to have your existing Personal HSM keys revoked and
new ones issued.

### What if someone steals it?

Most Personal HSMs default to a "locked" state and require a pin code to
"unlock" them until they are unplugged or manually locked again (perhaps when
you lock your computer). Much like what would happen if someone stole your ATM
card, an attacker that fails to enter the correct pin code 3 times, will
disable the device.

### What if it gets damaged?

In most cases it is possible to keep secure offline backups of the contents of
a Personal HSM at the time data is added to it. This requires considerable
additional knowledge of good cryptography practices and extra work at setup
time, but it is the best way to ensure a reliable and replaceable digital
"keychain" you can use for years to come.

It is typically not advised to keep backups of security key data around unless
it is a "master" key such as ones held by account owners or system
administrators that understand how to properly secure said backups.

In general just refer to "What if I lose it?"

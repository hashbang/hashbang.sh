#!/bin/sh -ev

# Actually rebuild the static pages
make all


# Check the OpenPGP signatures
rm -f -- index.html.data known_hosts
gpg --quiet -k 0xD2C4C74D8FAA96F5 ||
    gpg --recv-keys --keyserver keys.gnupg.net 0xD2C4C74D8FAA96F5

gpg -d -o index.html.data static/index.html
diff -q index.html.data static/index.html.plain
rm index.html.data

gpg -d -o known_hosts static/known_hosts.asc
diff -q known_hosts src/known_hosts
rm known_hosts


# Shellcheck the script
#  Ignore warning SC2029 “SSH argument is evaluated client-side”
#  Ignore warning SC2039 “In POSIX sh, 'shopt' is not supported”
#    (it is gated with `if [ -n "$BASH" ]`)

shellcheck -e SC2029,SC2039 src/hashbang.sh

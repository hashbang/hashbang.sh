#!/bin/sh -ev

# Actually rebuild the static pages
make all


# Check the OpenPGP signatures
gpg --recv-keys --keyserver keys.gnupg.net 0xD2C4C74D8FAA96F5

gpg -d -o index.html.data static/index.html
diff -q index.html.data static/index.html.plain

gpg -d -o known_hosts static/known_hosts.asc
diff -q known_hosts src/known_hosts

# Shellcheck the script
#  Do not error-out for now
#  Ignore warning SC2029 “SSH argument is evaluated client-side”
shellcheck -e SC2029 src/hashbang.sh || true

#!/bin/sh -ev

# Actually rebuild the static pages
make default

# Fetch the signing key if needed or if in the CI environment
if [ -n "$CI" ] || ! gpg --quiet -k 0xD2C4C74D8FAA96F5; then
    gpg --recv-keys --keyserver keys.gnupg.net 0xD2C4C74D8FAA96F5
fi

# Check the OpenPGP signatures
rm -f -- index.html.data known_hosts warn.sh

gpg -d -o index.html.data static/index.html
diff -q index.html.data static/index.html.plain
rm index.html.data

gpg -d -o known_hosts static/known_hosts.asc
diff -q known_hosts src/known_hosts
rm known_hosts

gpg -d -o warn.sh static/warn.sh.asc
diff -q warn.sh src/warn.sh
rm warn.sh


# Shellcheck the script
shellcheck src/hashbang.sh

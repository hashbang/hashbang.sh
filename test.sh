#!/bin/sh -ev

make all

#gpg --recv-keys --keyserver keys.gnupg.net 0xD2C4C74D8FAA96F5

gpg -d -o index.html.data static/index.html
diff -q index.html.data static/index.html.plain

gpg -d -o known_hosts static/known_hosts.asc
diff -q known_hosts src/known_hosts

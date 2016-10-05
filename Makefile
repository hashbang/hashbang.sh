all:
	sed -f src/template.sed src/template > static/index.html.plain

sign: all
	gpg --default-key 0xD2C4C74D8FAA96F5 --clearsign static/index.html.plain
	mv static/index.html.plain.asc static/index.html
	cp LICENSE static/LICENSE.txt

	gpg --default-key 0xD2C4C74D8FAA96F5 --clearsign src/known_hosts
	mv src/known_hosts.asc static/

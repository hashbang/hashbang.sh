all:
	sed -f src/template.sed src/template > static/index.html
	gpg --default-key 8FAA96F5 --clearsign static/index.html
	mv static/index.html.asc static/index.html

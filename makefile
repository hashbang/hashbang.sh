all:
	mkdir -p dist
	sed -f template.sed template > dist/index.html
	gpg --clearsign dist/index.html
	mv dist/index.html.asc dist/index.html


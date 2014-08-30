all:
	mkdir -p dist
	sed -f template.sed template > dist/index.html

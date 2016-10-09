GPG:= gpg --default-key 0xD2C4C74D8FAA96F5 --clearsign

.PHONY: sign default

default: static/index.html.plain
static/index.html.plain: $(wildcard src/template* src/hashbang.*)
	sed -f src/template.sed src/template > $@


sign: static/index.html static/known_hosts.asc static/warn.sh.asc

static/index.html: static/index.html.plain
	$(GPG) static/index.html.plain
	mv static/index.html.plain.asc static/index.html

static/%.asc: src/%
	$(GPG) $^
	mv $^.asc $@

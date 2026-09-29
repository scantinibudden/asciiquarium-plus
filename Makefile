PREFIX ?= /usr/local

.PHONY: test lint install

test:
	prove t/

lint:
	perlcritic asciiquarium

install:
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 755 asciiquarium $(DESTDIR)$(PREFIX)/bin/asciiquarium

PREFIX=/usr
MANDIR=$(PREFIX)/share/man
BINDIR=$(PREFIX)/bin

all:
	@echo "Run 'make install' for installation."
	@echo "Run 'make uninstall' for uninstallation."
	@echo "Run 'make reinstall' for installation without clobbering existing config file."

install-noconf:
	install -Dm755 create_ap $(DESTDIR)$(BINDIR)/create_ap
	[ ! -d /lib/systemd/system ] || install -Dm644 create_ap.service $(DESTDIR)$(PREFIX)/lib/systemd/system/create_ap.service
	[ ! -e /sbin/openrc-run ] || install -Dm755 create_ap.openrc $(DESTDIR)/etc/init.d/create_ap
	install -Dm644 bash_completion $(DESTDIR)$(PREFIX)/share/bash-completion/completions/create_ap
	install -Dm644 README.md $(DESTDIR)$(PREFIX)/share/doc/create_ap/README.md

install: install-noconf
	[ -e $(DESTDIR)/etc/create_ap.conf ] && echo "Existing $(DESTDIR)/etc/create_ap.conf will be renamed with .orig suffix" >&2
	install -Dm644 --backup=existing --suffix=.orig create_ap.conf $(DESTDIR)/etc/create_ap.conf

reinstall: install-noconf
	if [ -e $(DESTDIR)/etc/create_ap.conf ]; then \
	    echo "Leaving existing $(DESTDIR)/etc/create_ap.conf unchanged" >&2; \
	else \
	    install -Dm644 --backup=existing --suffix=.orig create_ap.conf $(DESTDIR)/etc/create_ap.conf; \
	fi

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/create_ap
	rm -f $(DESTDIR)/etc/create_ap.conf
	[ ! -f /lib/systemd/system/create_ap.service ] || rm -f $(DESTDIR)$(PREFIX)/lib/systemd/system/create_ap.service
	[ ! -e /sbin/openrc-run ] || rm -f $(DESTDIR)/etc/init.d/create_ap
	rm -f $(DESTDIR)$(PREFIX)/share/bash-completion/completions/create_ap
	rm -f $(DESTDIR)$(PREFIX)/share/doc/create_ap/README.md

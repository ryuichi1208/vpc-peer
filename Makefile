UCLINUX			?= 0
export UCLINUX

$(INSTALL_TARGETS): $(INSTALL_DIR) $(DESTDIR)/$(bindir)

## Install
install: $(INSTALL_TARGETS)

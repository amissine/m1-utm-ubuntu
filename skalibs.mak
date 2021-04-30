include config.mak

LINUX_HEADERS=/usr/src/linux-raspi-headers-5.4.0-1023/include
INCLUDE_DIRS := $(shell cd $(LINUX_HEADERS); for i in *; do echo $$i; done)

all: # the default goal {{{1

all: $(BUILD_DIR)/config.mak /package/prog/$(basename $(BUILD_DIR))
	@echo '- $@ built prerequisites: $^'
	cd /package/prog/skalibs/include; for i in $(INCLUDE_DIRS); \
		do sudo -E rm -f $$i; sudo -E ln -s $(LINUX_HEADERS)/$$i $$i; done; \
		sudo rm -f asm; sudo ln -s /usr/include/aarch64-linux-gnu/asm asm; \
		sudo rm -f asm-generic; sudo ln -s /usr/include/asm-generic asm-generic; \
		sudo rm -f linux; sudo ln -s /usr/include/linux linux

$(BUILD_DIR)/config.mak:
	cd $(BUILD_DIR); CC=$(CC) ./configure --enable-slashpackage --enable-tai-clock \
		--includedir=$(LINUX_HEADERS)

/package/prog/$(PACKAGE):
	cd $(BUILD_DIR); CC=$(CC) make -j $(MAKE_J)
	cd $(BUILD_DIR); CC=$(CC) sudo -E make install; sudo make update

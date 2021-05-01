include config.mak # {{{1

it: # the default goal

it: | $(BUILD_DIR) # {{{1
	cd $|; CC=$(CC) ./configure
	cd $|; CC=$(CC) make -j $(MAKE_J)
	cd $|; CC=$(CC) sudo -E make install
	cd /usr/local/bin; sudo rm -f musl-gcc; \
		sudo ln -s /usr/local/musl/bin/musl-gcc musl-gcc

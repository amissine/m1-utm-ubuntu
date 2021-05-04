include config.mak # {{{1

it: # the default goal

it: | $(BUILD_DIR) # {{{1
	cd $|; CC=$(MUSL_CC) ./configure --disable-tests
	cd $|; CC=$(MUSL_CC) make -j $(MAKE_J)
	cd $|; CC=$(MUSL_CC) sudo -E make install

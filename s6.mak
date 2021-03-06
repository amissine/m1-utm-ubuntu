PACKAGE := $(basename $(BUILD_DIR)) # {{{1
PACKAGE_NAME := $(basename $(lastword $(MAKEFILE_LIST)))

include config.mak # {{{1

it: # the default goal

it: | $(BUILD_DIR) # {{{1
	cd $|; CC=$(MUSL_CC) \
		./configure --enable-slashpackage --enable-nsss
	cd $|; CC=$(MUSL_CC) make -j $(MAKE_J)
	cd $|; CC=$(MUSL_CC) sudo -E make install
	cd /package/admin; \
		sudo rm -f $(PACKAGE_NAME); sudo ln -s $(PACKAGE) $(PACKAGE_NAME)

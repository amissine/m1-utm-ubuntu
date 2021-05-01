PACKAGE := $(basename $(BUILD_DIR)) # {{{1
PACKAGE_NAME := $(basename $(lastword $(MAKEFILE_LIST)))

include config.mak # {{{1

it: # the default goal

it: | $(BUILD_DIR) # {{{1
	cd $|; CC=$(MUSL_CC) \
		./configure --enable-slashpackage
	cd $|; CC=$(MUSL_CC) make -j $(MAKE_J)
	cd $|; CC=$(MUSL_CC) sudo -E make install
	. config.sh; lns $(PACKAGE) $(PACKAGE_NAME) /package/admin

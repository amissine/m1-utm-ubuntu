PACKAGE := $(basename $(BUILD_DIR)) # {{{1
PACKAGE_NAME := $(basename $(lastword $(MAKEFILE_LIST)))

include config.mak # {{{1

all: # the default goal

all: | $(BUILD_DIR) # {{{1
	cd $|; CC=$(CC) \
		./configure --enable-slashpackage
	cd $|; CC=$(CC) make -j $(MAKE_J)
	cd $|; CC=$(CC) sudo -E make install
	cd /package/admin; \
		sudo rm -f $(PACKAGE_NAME); sudo ln -s $(PACKAGE) $(PACKAGE_NAME)

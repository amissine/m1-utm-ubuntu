PACKAGE := $(basename $(BUILD_DIR)) # {{{1
PACKAGE_NAME := $(basename $(lastword $(MAKEFILE_LIST)))

include config.mak  # {{{1

it: # the default goal

it: | $(BUILD_DIR) # {{{1
	cd $|; CC=$(MUSL_CC) ./configure --enable-slashpackage \
		--enable-tai-clock --includedir=/usr/include
	cd $|; CC=$(MUSL_CC) make -j $(MAKE_J)
	cd $|; CC=$(MUSL_CC) sudo -E make install
	. config.sh; lns $(PACKAGE) $(PACKAGE_NAME) /package/prog; \
		lns /usr/include/linux linux /package/prog/skalibs/include; \
		lns /usr/include/asm-generic asm-generic /package/prog/skalibs/include; \
		lns /usr/include/aarch64-linux-gnu/asm asm /package/prog/skalibs/include; \
		lns /usr/local/include/tls.h tls.h /package/prog/skalibs/include; \
		lns /usr/local/lib/libcrypto.so libcrypto.so /package/prog/skalibs/library; \
		lns /usr/local/lib/libssl.so libssl.so /package/prog/skalibs/library; \
		lns /usr/local/lib/libtls.so libtls.so /package/prog/skalibs/library

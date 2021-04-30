# Install musl and libressl {{{1
#
# See also:
# https://www.gnu.org/software/make/manual/
# https://www.gnu.org/software/bash/manual/

include config.mak # {{{1

$(info - LOCAL_MACHINE $(LOCAL_MACHINE), MAKE_J $(MAKE_J))

# PACKAGES and URLs {{{1
PACKAGES := $(basename $(basename $(basename \
  $(shell cd hashes; for h in *; do echo $$h; done))))
MUSL := $(filter musl-%, $(PACKAGES))
PACKAGES := $(MUSL) $(filter-out musl-%, $(PACKAGES))

MUSL_URL := http://musl.libc.org/releases
LIBRESSL_URL := https://ftp.openbsd.org/pub/OpenBSD/LibreSSL

it: # the default goal {{{1

clean: 
	rm -rf $(PACKAGES) *.build sources

sources: # {{{2
	mkdir -p $@

# Target-specific variable URL {{{2
$(patsubst hashes/%.sha1,sources/%,$(wildcard hashes/musl*)): URL = $(MUSL_URL)
$(patsubst hashes/%.sha1,sources/%,$(wildcard hashes/libressl*)): URL = $(LIBRESSL_URL)

sources/%: hashes/%.sha1 | sources # {{{2
	rm -rf $@.tmp; mkdir -p $@.tmp
	cd $@.tmp; $(DL_CMD) $(notdir $@) $(URL)/$(notdir $@) && touch $(notdir $@)
	cd $@.tmp; sha1sum -c $(CURDIR)/hashes/$(notdir $@).sha1
	mv $@.tmp/$(notdir $@) $@ && rm -rf $@.tmp

%.build: sources/%.tar.gz # {{{2
	rm -rf $@.tmp; mkdir -p $@.tmp
	( cd $@.tmp; tar zxvf - ) < $<
	rm -rf $@
	touch $@.tmp/$(patsubst %.build,%,$@)
	mv $@.tmp/$(patsubst %.build,%,$@) $@
	rm -rf $@.tmp

# Target-specific variable PKG_NAME, can have '-' inside {{{2
%: PKG_NAME = $(subst $(SPACE),-,$(strip \
	$(filter-out %.2 %.5,$(subst -, ,$@))))

%: %.build # {{{2
	$(MAKE) -f $(PKG_NAME).mak BUILD_DIR=$<
	touch $@

it: | $(PACKAGES) # {{{2
	@echo '- $@: installed order-only prerequisites: $|'

# }}}2

# No intermediate targets to remove {{{1
.SECONDARY:

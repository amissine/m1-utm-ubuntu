# Install musl and libressl {{{1
#
# See also:
# https://www.gnu.org/software/make/manual/
# https://www.gnu.org/software/bash/manual/

include config.mak # {{{1

$(info - LOCAL_MACHINE $(LOCAL_MACHINE), MAKE_J $(MAKE_J))

MUSL_RELEASE := musl-1.2.2 # {{{2
MUSL_URL := http://musl.libc.org/releases
MUSL_GZ := $(MUSL_RELEASE).tar.gz
MUSL_ASC := $(MUSL_GZ).asc

URLS := url["musl"]="$(MUSL_URL)"; url["libressl"]="$(LIBRESSL_URL)" # {{{2

PACKAGES := $(MUSL_RELEASE) $(LIBRESSL_RELEASE) # {{{2
# }}}2

all: # the default goal {{{1

clean: 
	rm -rf $(PACKAGES) *.build sources hashes

hashes: # {{{2
	mkdir -p $@

# Target-specific variable H_PKG_NAME, can have '-' inside {{{2
hashes/%.tar.gz.asc: H_PKG_NAME = $(subst $(SPACE),-,$(strip \
	$(filter-out %.tar.gz.asc,$(subst -, ,$(notdir $@)))))

# Target-specific variable H_URL, can have '-' inside {{{2
hashes/%.tar.gz.asc: H_URL = $(shell \
  echo $(H_PKG_NAME) | awk '{ $(URLS); print url[$$1] }')

hashes/%.tar.gz.asc: | hashes # {{{2
	rm -rf $@.tmp; mkdir -p $@.tmp
	cd $@.tmp; $(DL_CMD) $(notdir $@) $(H_URL)/$(notdir $@) && touch $(notdir $@)

sources: # {{{2
	mkdir -p $@

# Target-specific variable S_PKG_NAME, can have '-' inside {{{2
sources/%.tar.gz: S_PKG_NAME = $(subst $(SPACE),-,$(strip \
	$(filter-out %.tar.gz,$(subst -, ,$(notdir $@)))))

# Target-specific variable S_URL, can have '-' inside {{{2
sources/%.tar.gz: S_URL = $(shell \
  echo $(S_PKG_NAME) | awk '{ $(URLS); print url[$$1] }')

sources/%.tar.gz: hashes/%.tar.gz.asc | sources # {{{2
	rm -rf $@.tmp; mkdir -p $@.tmp
	cd $@.tmp; $(DL_CMD) $(notdir $@) $(S_URL)/$(notdir $@) && touch $(notdir $@)
	exit 69

%.build: sources/%.tar.gz # {{{2
	rm -rf $@.tmp; mkdir -p $@.tmp
	( cd $@.tmp; tar zxvf - ) < $<
	rm -rf $@
	touch $@.tmp/$(patsubst %.build,%,$@)
	mv $@.tmp/$(patsubst %.build,%,$@) $@
	rm -rf $@.tmp

# Target-specific variable PKG_NAME, can have '-' inside {{{2
%: PKG_NAME = $(subst $(SPACE),-,$(strip \
	$(filter-out %.2,$(subst -, ,$@))))

%: %.build # {{{2
	$(MAKE) -f $(PKG_NAME).mak BUILD_DIR=$<
	touch $@

all: | $(PACKAGES) # {{{2
	@echo '- $@ installed order-only prerequisites: $|'

# }}}2

.SECONDARY: # No intermediate targets to remove {{{1

#SHELL=/bin/bash

all:	desktop
	@echo "Built '$${RPM_BUILD_ROOT}'" ;

desktop:
	@echo "Building /etc/sysconfig/desktop precursors" ; \
	mkdir -p root/etc/sysconfig ; \
	cp sources/desktop-extra root/etc/sysconfig/desktop-extra ; 


# INSTALLER - into RPM_BUILD_ROOT

install: desktop_install
	@echo "Installing eee-nologin ..." ; \
	mkdir -p $${RPM_BUILD_ROOT} ; \
	cp -R root/* $${RPM_BUILD_ROOT}/

desktop_install:
	@echo "Installing desktop-extra..." ;

# cat sources/xfce/autologin-appendto-dot-bash_profile >> $${RPM_BUILD_ROOT}/etc/skel/.bash_profile_xfce; 


# Make a tarball for distribution (good for RPM spec'ing)
tarball:
	@echo "Making tarball..." ; \
	NAME="eee-nologin" ; \
	VERSION=$$(cat ./VERSION) ; \
	echo "Version='$${VERSION}'" ; \
	RPM="$${NAME}-$${VERSION}" ; \
	echo "RPM='$${RPM}'" ; \
	cp ./$${NAME}.spec.base ./$${NAME}.spec ; \
	sed -i ./$${NAME}.spec -e 's|@@VERSION@@|'$${VERSION}'|' ; \
	TBALL=$$RPM.tar ; \
	rm -rf $$RPM $$NAME*.tar* ; \
	mkdir $$RPM ; \
	cp ./$$NAME.spec $$RPM/ ; \
	cp ./Makefile $$RPM/ ; \
	cp -R ./sources $$RPM/ ; \
	for svn in `find  $$RPM | grep "\.svn\$$"`; do rm -rf $$svn; done ; \
	tar -cvf ./$$TBALL $$RPM ; \
	gzip ./$$TBALL ; \
	rm -rf $$RPM ; \
	sync ; \
	echo ; \
	echo "Created tarball '$$TBALL.gz'" ;

# Holden Caulfield hates phonies

.PHONY: clean tarball

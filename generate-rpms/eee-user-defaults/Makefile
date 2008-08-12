#SHELL=/bin/bash

# Source files
all:	bash xfce firefox scite 
	@echo "Built '$${RPM_BUILD_ROOT}'" ;

bash:
	@echo "Building /etc/skel/.bash_profile etc" ; \
	mkdir -p root/etc/skel ; \
	cp /root/etc/skel/.bash_profile root/etc/skel/ ; \
	cat sources/xfce/autologin-appendto-dot-bash_profile >> root/etc/skel/.bash_profile

xfce:
	@echo "Building /etc/skel/.xfce etc" ; \
	cp sources/xfce/dot-xsession root/etc/skel/.xsession ; \
	cp sources/xfce/dot-xinitrc root/etc/skel/.xinitrc ; \
	chmod a+x root/etc/skel/.x{session,initrc} ; \
	tar -xzf sources/xfce/dot-config.tar.gz -C root/etc/skel/

# NB : Create beautiful XFCE settings dump with :
# tar -czf dot-config.tar.gz /home/eeedora/.config


firefox:
	@echo "Building /etc/skel/.mozilla" ; \
	tar -xzf sources/firefox/firefox.tar.gz -C root/etc/skel/

# NB : Create beautiful Firefox settings dump with :
# tar -czf firefox.tar.gz /home/eeedora/.mozilla


scite:
	@echo "Building /etc/skel/.SciTEUser.properties" ; \ 
	cat sources/scite/scite.{monospaced,filesearch,tabs} >> root/etc/skel/.SciTEUser.properties

install:
	@echo "Installing eee-user-defaults ...." ; \
	mkdir -p $${RPM_BUILD_ROOT} ; \
	cp -R root/* $${RPM_BUILD_ROOT}/

# Make a tarball for distribution (good for RPM spec'ing)
tarball:
	@echo "Making tarball..." ; \
	NAME="eee-user-defaults" ; \
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

# Set the install directory for the executable
#ifndef INSTALLDIR
#INSTALLDIR = /usr/bin
#endif

# Set flags used to compile sources
#CPPFLAGS = -Wall `pkg-config --cflags gtk+-2.0 glib-2.0`

# Set flags used to link executable
#LDFLAGS = `pkg-config --libs gtk+-2.0 glib-2.0`

# Source files


# Install executable

#install:
#	@echo "Installing eee-acpi ...." ;\
#	install $(EXECUTABLE) $(INSTALLDIR)

# Make a tarball for distribution
#	cp ./root/etc/acpi/actions/eee $$RPM/root/etc/acpi/actions/ ; 

tarball: 
	@echo "Making tarball..." ; \
 NAME=eee-acpi ; \
	VERSION=`cat ./VERSION` ; \
	echo "Version='$$VERSION'" ; \
	RPM="$$NAME-$$VERSION" ; \
	echo "RPM='$$RPM'" ; \
	cp ./$$NAME.spec.base ./$$NAME.spec ; \
	sed -i ./$$NAME.spec -e 's|@@VERSION@@|'$$VERSION'|'; \
	TBALL=$$RPM.tar ; \
	rm -rf $$RPM $$NAME*.tar* ; \
	mkdir $$RPM ; \
	cp ./$$NAME.spec $$RPM/ ; \
	mkdir -p $$RPM/root/etc/acpi/{actions,events} ; \
	cp ./root/etc/acpi/actions/eee.py $$RPM/root/etc/acpi/actions/ ; \
	cp ./root/etc/acpi/actions/{wlan.sh,camera.sh} $$RPM/root/etc/acpi/actions/ ; \
	cp ./root/etc/acpi/events/hotkeys.{conf,sh} $$RPM/root/etc/acpi/events/ ; \
	tar -cvf ./$$TBALL $$RPM ; \
	gzip ./$$TBALL ; \
	rm -rf $$RPM ; \
	sync; \
	echo ; \
	echo "Created tarball '$$TBALL.gz'"

# Holden Caulfield hates phonies

.PHONY: clean tarball

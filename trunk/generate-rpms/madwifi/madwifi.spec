#
#Gen the last kernel-devel available on the machine.
# %{!?kernel: %{expand: %%define        kernel          %(rpm -q kernel-devel --last | head -1 | awk '{print $1}' | sed s/kernel-devel-// )}}

# Force this ...
%define        kernel          %(rpm -q kernel-devel --last | head -1 | awk '{print $1}' | sed s/kernel-devel-// )

%if %(echo %{kernel} | grep -c smp)
      %{expand:%%define myksmp -smp}
%endif
#
%define       mykversion        %(echo %{kernel} | sed -e s/smp// -)
%define       mykrelver         %(echo %{mykversion} | tr -s '-' '_')

# This is silly, I know
%define       mykarch          i686

# Define based on the tar ball extract.
# Those two variable will be instanced during the tarball generation
# %define       revision	@@SVNREL@@
# %define       snapshot	@@DDAY@@
# %define       revision	3366
# %define       snapshot	ar5007
# branch is not used yet.
# %define       branch		@@BRANCH@@
# %define	myrelease	eee_1
Summary: A linux device driver for Atheros chipsets (ar5210, ar5211, ar5212).
Name: madwifi
# Version: 0.%{revision}.%{snapshot}
Version: 0.9.4
Release: eee_1
License: GPL2
Group: System Environment/Kernel
URL: http://madwifi.org
#Source0: http://snapshots.madwifi.org/%{name}-%{branch}-r%{revision}-%{snapshot}.tar.gz
# Changes accordingly to the new rule :  madwifi-ng-r<revision>-<generation date>.tar.gz
#Source0: http://snapshots.madwifi.org/madwifi-ng/%{name}-ng-r%{revision}-%{snapshot}.tar.gz

# This is obtained from : http://snapshots.madwifi.org/special/madwifi-nr-r3366+ar5007.tar.gz
# And the tarball is renamed madwifi-ng-r3366+ar5007.tar.gz to match its extracted path

# Doesn't work for 2.6.25.11
#Source0: madwifi-ng-r3366+ar5007.tar.gz

# Try to update version 
Source0:  madwifi-hal-0.10.5.6-r3835-20080801.tar.gz

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
Requires: /sbin/depmod
BuildRequires: /sbin/depmod

#Requires: %{name}-module >= %{version}
Requires: eee-%{name}-module >= %{version}
Provides: eee-%{name}

# BuildRequires:  /lib/modules/%{mykversion}/build/Makefile


%description 
This software contains a Linux kernel driver for Atheros-based
Wireless LAN devices.  The driver supports station, AP, ad-hoc, and
monitor modes of operation.  The Atheros driver depends on a
device-independent implementation of the 802.11 protocols that
originated in the BSD community (NetBSD in particular).
The driver functions as a normal network device and uses the Wireless
Extensions API.  As such normal Linux tools can and should be used
with it.  Where the wireless extensions are lacking private ioctls
have been added.
There is only one driver included here; it supports PCI, miniPCI
and Cardbus devices - USB devices are currently not supported by
this driver!  The driver can be built as a module or linked
directly into the kernel.  Note however that the net80211 layer is
device-independent; there is no reason it cannot be used with any
802.11 device (in fact on BSD systems this is the case).
There are currently 3 "programming generations" of Atheros 802.11
wireless devices (some of these have multiple hardware implementations
but otherwise appear identical to users):
5210    supports 11a only
5211    supports both 11a and 11b
5212    supports 11a, 11b, and 11g

%package module
Summary: A linux device driver for Atheros chipsets (ar5210, ar5211, ar5212).
Group: System Environment/Kernel
Release: %{myrelease}_%{mykrelver}

BuildRequires: kernel-devel = %{mykversion} 
Requires: kernel = %{mykversion}
Provides: eee-%{name}-module

%description module
This software is broken into multiple modules.  The Atheros-specific
device support is found in the ath_pci module; it should be loaded
when an Atheros wireless device is recognized.  The ath_pci module
requires an additional device specific module, ath_hal, which is
described more below.  In addition the driver requires the wlan
module which contains the 802.11 state machine, protocol support,
and other device-independent support needed by any 802.11 device.
This code is derived from work that first appeared in NetBSD and
then FreeBSD.  The wlan module may also force the loading of
additional modules for crypto support (wlan_wep, wlan_tkip, wlan_ccmp,
etc.), for MAC-based ACL support (wlan_acl), and for 802.1x
authenticator support (wlan_xauth).  The latter modules are only 
used when operating as an AP.  The crypto modules are loaded when 
keys of that type are created.

%prep 
#%setup -q 
#%setup -q -n %{name}-%{branch}-r%{revision}-%{snapshot}
#%setup -q -n %{name}-ng-r%{revision}-%{snapshot}
#ln -s madwifi-hal-0.10.5.6-r3835-20080801 %{name}-ng-r%{revision}+%{snapshot}
#%setup -q -n %{name}-ng-r%{revision}+%{snapshot}
%setup -q -n madwifi-hal-0.10.5.6-r3835-20080801
find . -name Makefile\* | xargs perl -pi -e's,/sbin/depmod,: /sbin/depmod,'

%build 
export KERNELRELEASE=%{mykversion}.%{mykarch}
export KERNELPATH=/lib/modules/%{mykversion}.%{mykarch}/build
export KERNELCONF=/lib/modules/%{mykversion}.%{mykarch}/build/.config
export KMODPATH=/lib/modules/%{mykversion}.%{mykarch}/net
export COPTS="-I /lib/modules/%{mykversion}.%{mykarch}/build/include/ $COPTS"
# export ATH_RATE=ath_rate/onoe
make 
cd tools ; make all ; cd ..

%install 
export KERNELRELEASE=%{mykversion}.%{mykarch}
export KERNELPATH=/lib/modules/%{mykversion}.%{mykarch}/build
export KERNELCONF=/lib/modules/%{mykversion}.%{mykarch}/build/.config
export KMODPATH=/lib/modules/%{mykversion}.%{mykarch}/net

rm -rf %{buildroot}

# make info
#mkdir -p  %{buildroot}/usr/local/bin
mkdir -p  %{buildroot}/usr/bin
mkdir -p  %{buildroot}/$KMODPATH
mkdir -p  %{buildroot}/usr/share/madwifi

make install DESTDIR=%{buildroot} KERNELPATH=/lib/modules/%{mykversion}.%{mykarch}/build BINDIR=/usr/bin MANDIR=/usr/share/man 
cd tools ; make install DESTDIR=%{buildroot} KERNELPATH=/lib/modules/%{mykversion}/build BINDIR=/usr/bin MANDIR=/usr/share/man  ; cd ..

%post  module
mp=%{buildroot}/etc/modprobe.conf
echo "#" >> ${mp}
echo "# Added for EeeDora setup : ath" >> ${mp}
echo "alias wifi0 ath_pci" >> ${mp}
echo "alias ath0 ath_pci" >> ${mp}
echo "options ath_pci autocreate=sta" >> ${mp}
echo "# Added after ath setup " >> ${mp}
echo "#" >> ${mp}
/sbin/depmod -ae %{mykversion}.%{mykarch}

%postun  module
/sbin/depmod -ae %{mykversion}.%{mykarch}

%clean 
rm -rf %{buildroot}

%files
%doc COPYRIGHT README INSTALL THANKS 
# %attr(0755,root,root) /usr/bin/*
# %attr(0644,root,root) /usr/local/man/*
%attr(0755,root,root) /usr/bin/*
%attr(0644,root,root) /usr/share/man/*

%files module
%defattr(-,root,root,-)
/lib/modules/%{mykversion}.%{mykarch}/net/*.*o

#
%changelog
* Wed Dec 14 2005  Patrick Pichon <Patrick.Pichon@laposte.net>
- Update accordingly to the new file name rule:  madwifi-ng-r<revision>-<generation date>.tar.gz
- 'branch' tag is not use yet. 'ng' is hardcoded as part of the file name
- Change the computation to target the latest kernel-devel env.

* Thu Nov 3 2005  Patrick Pichon <Patrick.Pichon@laposte.net>
- Incorporate the changes made on the Makefile
- Cleaning on the Description fields
- Changing the URL to the new madwifi.org's one.
- Install under /usr/share/doc/madwifi-release the INSTALL and THANKS files
- Install under /usr/share/doc/madwifi-release the docs files.

* Sun Oct 30 2005  Patrick Pichon <Patrick.Pichon@laposte.net>
- Add Man pages

* Mon Oct 24 2005  Lyonel Vincent <>
- Fix the --rebuild option.

* Mon Oct 3 2005  Lyonel Vincent <>
- Build by default on latest kernel installed

* Wed Jul 20 2005 Patrick Pichon <Patrick.Pichon@laposte.net
- target particular kernel

* Mon Oct 27 2004 Patrick Pichon <Patrick.Pichon@laposte.net>
- Handle 2.4 kernel

* Mon Sep 21 2004 Lyonel Vincent <>
- change the naming of the kernel module part.

* Mon Aug 23 2004 Patrick Pichon <Patrick.Pichon@laposte.net>
- Update WPA has been merged into HEAD

* Mon Jul 27 2004 Patrick Pichon <Patrick.Pichon@laposte.net>
- Update to handle WPA branch.

* Tue Jul 08 2004 Patrick Pichon <Patrick.Pichon@laposte.net>
- Initial Release

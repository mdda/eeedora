%{!?kernel: %define kernel %(uname -r)}

Summary: Minimal Install of atl2 kernel module
Name: atl2_eee
Version: 0.1.0.0
Release: 1
License: GPL
Group: Development/Build Tools
BuildRoot: /var/tmp/%{name}-buildroot
Source0: atl2_eee-0.1.0.0.tar.gz
#%define mykver %(echo `uname -r`)
#%define mykmoddir /lib/modules/`uname -r`/kernel/

# These includes just ensure that it gets installed 'late enough'
Requires: bash
#Requires: initscripts
#Requires: chkconfig
Requires: fedora-release
Requires: coreutils
Requires: findutils
Requires: openssh-server
Requires: which
Requires: udev
#Requires: rpm-build
Requires: tar
Requires: gzip
Requires: patch
Requires: unzip
Requires: binutils

%description

%prep
%setup -q

%build

%install
mkdir -p %{buildroot}
#mkdir ${moddir}/kernel/drivers/net/atl2
#install %{buildroot}/atl2.ko /lib/modules/$(echo `uname -r`)/kernel/drivers/net/atl2/
mkdir -p %{buildroot}/lib/modules/%{kernel}/kernel/drivers/net/atl2/
install atl2.ko %{buildroot}/lib/modules/%{kernel}/kernel/drivers/net/atl2/

# This is a hack to make sure correct version gets in the local kernel too
#install atl2.ko /lib/modules/$(echo `uname -r`)/kernel/drivers/net/atl2/

%clean

%files
%defattr(-,root,root,-)
/lib/modules/%{kernel}/kernel/drivers/net/atl2/atl2.ko

%post
# This is a fix to make sure our module went in the right directory
mkdir -p /lib/modules/$(echo `uname -r`)/kernel/drivers/net/atl2/
mv /lib/modules/%{kernel}/kernel/drivers/net/atl2/atl2.ko \
   /lib/modules/$(echo `uname -r`)/kernel/drivers/net/atl2/
/sbin/depmod -a
/sbin/modprobe -f atl2

%changelog
* Thu Nov 21 2007 Martin Andrews <Martin.Andrews@xxxxxxxxxx> - 0.1.0.0
- Initial build - this is a complete hack, I'm sorry
- Unfortunately, the spec file with the atl2 source tarball hangs 
- This build just forces the kernel module into the right place

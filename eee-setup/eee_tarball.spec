Summary: Brings over the EeeDora tarball
Name: eee_tarball
Version: 0.0.0.0
Release: 0
License: GPL
Group: Development/Build Tools
BuildRoot: /var/tmp/%{name}-buildroot
Source0: eee_tarball-0.1.0.0.tar.gz

# These includes just ensure that it gets installed 'late enough'
Requires: bash
#Requires: initscripts
#Requires: chkconfig
Requires: fedora-release
#Requires: coreutils
#Requires: findutils
#Requires: which
Requires: udev
#Requires: rpm-build
Requires: tar
Requires: unzip

%description

%prep
%setup -q

%build

%install
rm -rf %{buildroot}

# Let's add the stuff to the buildroot now
mkdir -p %{buildroot}/root/  
install eee-setup.tar.gz %{buildroot}/root/



%clean

%files
%defattr(-,root,root,-)
/root/eee-setup.tar.gz

%post
# This is a fix to make sure our module went in the right directory
#mkdir -p /lib/modules/$(echo `uname -r`)/kernel/drivers/net/atl2/
#mv /lib/modules/%{kernel}/kernel/drivers/net/atl2/atl2.ko \
#   /lib/modules/$(echo `uname -r`)/kernel/drivers/net/atl2/
#/sbin/depmod -a
#/sbin/modprobe -f atl2

%changelog
* Sun Mar 09 2008 Martin Andrews <Martin.Andrews@xxxxxxxxxx> - 2.6.24.3-12
- Decided to rename the rpm based on kernel version after all,
- since that is the deciding factor for a forced update.
* Thu Nov 21 2007 Martin Andrews <Martin.Andrews@xxxxxxxxxx> - 0.1.0.0
- Initial build - this is a complete hack, I'm sorry
- Since the kernel-version dependency is always going to be there
- and we don't want to have to keep releasing new RPMs, let's
- just tar everything we might need up, and install it over there
- so that we can untar it at our leisure
- And, as each untaring script works, add it into this tar,
- and let the kickstart file launch it in one go.

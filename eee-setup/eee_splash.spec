Summary: Adds the splash screen to anaconda-runtime
Name: eee_splash
Version: 0.0.0.0
Release: 0
License: GPL
Group: Development/Build Tools
BuildRoot: /var/tmp/%{name}-buildroot
Source0: eee_splash-0.0.0.0.tar.gz

# These includes just ensure that it gets installed 'late enough'
Requires: bash
Requires: fedora-release
Requires: udev
Requires: tar
Requires: unzip
Requires: anaconda-runtime

%description

%prep
%setup -q

%build

%install
rm -rf %{buildroot}

# Install the artwork in the right place (maybe more required, though)
mkdir -p %{buildroot}/usr/lib/anaconda-runtime/
install syslinux-vesa-splash.jpg %{buildroot}/usr/lib/anaconda-runtime/

mkdir -p %{buildroot}/boot/grub
install splash.xpm.gz %{buildroot}/boot/grub

#cp ${setup}/artwork/splash.xpm.gz /boot/grub/
##cp ${setup}/artwork/splash.jpg /usr/lib/syslinux/
#cp ${setup}/artwork/splash.jpg /usr/lib/anaconda-runtime/syslinux-vesa-splash.jpg



%clean

%files
%defattr(-,root,root,-)
# Since this will conflicts ... what to do ?
/usr/lib/anaconda-runtime/syslinux-vesa-splash.jpg
/boot/grub/splash.xpm.gz

%post
# This is a fix to make sure our module went in the right directory
#mkdir -p /lib/modules/$(echo `uname -r`)/kernel/drivers/net/atl2/
#mv /lib/modules/%{kernel}/kernel/drivers/net/atl2/atl2.ko \
#   /lib/modules/$(echo `uname -r`)/kernel/drivers/net/atl2/
#/sbin/depmod -a
#/sbin/modprobe -f atl2

%changelog
* Thu Nov 30 2007 Martin Andrews <Martin.Andrews@xxxxxxxxxx> - 0.1.0.0
- Initial build - this is a complete hack, I'm sorry
- Since the kickstart %post starts after the ISO builder has created /isolinux
- and the %post environment is chrooted outside of it, we must fix up the 
- splash screen *before* the post, but after anaconda-runtime has been installed.

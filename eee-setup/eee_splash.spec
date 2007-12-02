Summary: Adds the splash screen to anaconda-runtime
Name: eee_splash
Version: 0.0.0.0
Release: 0
License: GPL
Group: Development/Build Tools
BuildRoot: /var/tmp/%{name}-buildroot
Source0: eee_splash-0.0.0.0.tar.gz

# These includes ensure that it gets installed 'late enough'
Requires: bash
Requires: fedora-release
Requires: udev
Requires: tar
Requires: unzip
# These are more specific
Requires: anaconda-runtime
Requires: fedora-logos

%description
Adds the EeeDora splash screens to ISO install, and regular boot (for when the system is on the Eee hardware)

%prep
rm -rf %{buildroot}
%setup -q

%build

%install
#mkdir -p %{buildroot}
#echo "*** START ***"
#echo -n "*** Currently in : "
#pwd
#echo "*** Contents :"
#ls
#echo "*** END ***"

mkdir -p %{buildroot}/usr/lib/anaconda-runtime/
install syslinux-vesa-splash.jpg.eee %{buildroot}/usr/lib/anaconda-runtime/

mkdir -p %{buildroot}/boot/grub/
install splash.xpm.gz.eee %{buildroot}/boot/grub/

#cp ${setup}/artwork/splash.xpm.gz /boot/grub/
##cp ${setup}/artwork/splash.jpg /usr/lib/syslinux/
#cp ${setup}/artwork/splash.jpg /usr/lib/anaconda-runtime/syslinux-vesa-splash.jpg

%clean

%files
%defattr(-,root,root,-)
# Since this will conflicts ... what to do ?
/usr/lib/anaconda-runtime/syslinux-vesa-splash.jpg.eee
/boot/grub/splash.xpm.gz.eee

%pre
#mv %{buildroot}/usr/lib/anaconda-runtime/syslinux-vesa-splash.jpg %{buildroot}/usr/lib/anaconda-runtime/syslinux-vesa-splash.jpg.orig
#mv %{buildroot}/boot/grub/splash.xpm.gz %{buildroot}/boot/grub/splash.xpm.gz.orig

p=/usr/lib/anaconda-runtime/
mkdir -p ${p}  # Must be there already
if [ -f ${p}/syslinux-vesa-splash.jpg ]; then 
 mv ${p}/syslinux-vesa-splash.jpg ${p}/syslinux-vesa-splash.jpg.rpmsave
fi

p=/boot/grub
mkdir -p ${p}
if [ -f ${p}/splash.xpm.gz ]; then 
 mv ${p}/splash.xpm.gz ${p}/splash.xpm.gz.rpmsave
fi

%post
p=/usr/lib/anaconda-runtime/
mv ${p}/syslinux-vesa-splash.jpg.eee ${p}/syslinux-vesa-splash.jpg

p=/boot/grub
mv ${p}/splash.xpm.gz.eee ${p}/splash.xpm.gz.rpmsave



%changelog
* Thu Nov 30 2007 Martin Andrews <Martin.Andrews@xxxxxxxxxx> - 0.1.0.0
- Initial build - this is a complete hack,  I'm sorry
- Since the kickstart %post starts after the ISO builder has created /isolinux
- and the %post environment is chrooted outside of it, we must fix up the 
- splash screen *before* the %post, but after anaconda-runtime has been installed.

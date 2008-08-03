Summary: Wireless Internet Connection Daemon
Name:   wicd
#Version: 1.3.1
#Release: 3
Version: 1.4.2
Release: 1%{?dist}
URL:    https://sourceforge.net/projects/wicd/
Source: %{name}_%{version}-src.tar.bz2
#Patch:  wicd.redhat.patch
Patch:  wicd.eeedora.patch
License: GPL
Group:  System Environment/Base
#BuildRoot: /var/tmp/%{name}-root
BuildRoot: %{_buildroot}
#BuildArch: noarch
BuildArch: i386
Requires: python chkconfig dbus

%description
wicd was started because of the lack of useful, functional wireless network
connection managers in Linux. It is also capable of connecting to wired
networks as an added bonus. 

%prep
%setup -q -c
%patch0 -p1

%install
[ -d "$RPM_BUILD_ROOT" -a "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT
mkdir $RPM_BUILD_ROOT
cp -pr * $RPM_BUILD_ROOT
#cd $RPM_BUILD_ROOT/opt/wicd/
#rm -f *.pyc 
#rm -f *.pyo
cd $RPM_BUILD_ROOT/opt/wicd/data
rm -f wicd.log
ln -sf /var/log/wicd.log .

%clean
[ -d "$RPM_BUILD_ROOT" -a "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT

%post
init_script=wicd
# /sbin/chkconfig --add %{name} >/dev/null 2>&1 || :
if [ -x /usr/lib/lsb/install_initd ]; then
	/usr/lib/lsb/install_initd /etc/init.d/${init_script}
elif [ -x /sbin/chkconfig ]; then
	/sbin/chkconfig --add ${init_script}
else
	for i in 2 3 4 5; do
		ln -sf /etc/init.d/${init_script} /etc/rc.d/rc${i}.d/S28${init_script}
	done
	for i in 1 6; do
		ln -sf /etc/init.d/${init_script} /etc/rc.d/rc${i}.d/K89${init_script}
	done
fi
/sbin/restorecon /var/log/wicd.log


%preun
init_script=wicd
#if [ $1 = 0 ]; then
#	/sbin/service %{name} stop > /dev/null 2>&1
#	/sbin/chkconfig --del %{name}
#fi
#only on uninstall, not on upgrades.
if [ $1 = 0 ]; then
	/etc/init.d/${init_script} stop  > /dev/null 2>&1
	if [ -x /usr/lib/lsb/remove_initd ]; then
		/usr/lib/lsb/install_initd /etc/init.d/${init_script}
	elif [ -x /sbin/chkconfig ]; then
		/sbin/chkconfig --del ${init_script}
	else
		rm -f /etc/rc.d/rc?.d/???${init_script}
	fi
fi

%files
%defattr(-,root,root)
/usr/share/pixmaps/wicd.png
/usr/share/applications/hammer-00186ddbac.desktop
/opt/wicd/data
/opt/wicd/encryption
/opt/wicd/images
/opt/wicd/translations
# /opt/wicd/tray-edgy.py
# /opt/wicd/tray-dapper.py
/opt/wicd/tray.py*
/opt/wicd/networking.py*
/opt/wicd/misc.py*
/opt/wicd/gui.py*
/opt/wicd/edgy.py*
/opt/wicd/dapper.py*
/opt/wicd/daemon.py*
/opt/wicd/autoconnect.py*
/opt/wicd/run-script.py*
/etc/init.d/wicd
/etc/dbus-1/system.d/wicd.conf
/etc/acpi/resume.d/80-wicd-connect.sh

%changelog
* Sun Jul 6 2008 Martin Andrews <EeeDora@PLATFORMedia.com> 1.4.2-1
- Proper patching for new version and Fedora 9
* Thu Sep 13 2007 Stuart Gathman <stuart@gathman.org> 1.3.1-3
- run chkconfig for install/uninstall
* Thu Sep 13 2007 Stuart Gathman <stuart@gathman.org> 1.3.1-2
- Fit RH init better.
* Thu Sep 13 2007 Stuart Gathman <stuart@gathman.org> 1.3.1-1
- RPM Spec file

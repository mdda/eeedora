Summary: Wireless Internet Connection Daemon
Name:   wicd
Version: 1.5.0
Release: 1%{?dist}
URL:    https://sourceforge.net/projects/wicd/
#Source: %{name}_%{version}-src.tar.bz2
Source: %{name}-%{version}.tar.gz
#Patch:  wicd.redhat.patch
#Patch:  wicd.eeedora.patch
License: GPL
Group:  System Environment/Base
#BuildRoot: /var/tmp/%{name}-root
BuildRoot: %{_buildroot}
#BuildArch: noarch
BuildArch: i386
BuildRequires: python-devel
# BuildRequires: rpm-pythonprov
# BuildRequires: rpmbuild(macros) >= 1.228
Requires(post,preun):  /sbin/chkconfig
Requires: python
Requires: dbus
Requires: dhclient
Requires: dbus-python
Requires: python-devel
#Requires: python-pygobject
#Requires: python-pygtk-glade
Requires: pygtk2-libglade
#Requires: python-pygtk-gtk
Requires: pygtk2
Requires: /sbin/restorecon

%description
wicd was started because of the lack of useful, functional wireless network
connection managers in Linux. It is also capable of connecting to wired
networks as an added bonus. 

%prep
# %setup -q -c
%setup -q
# %patch0 -p1
%{__python} setup.py configure

%build
%{__python} setup.py build

%install
# [ -d "$RPM_BUILD_ROOT" -a "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT
# mkdir $RPM_BUILD_ROOT
# cp -pr * $RPM_BUILD_ROOT
# cd $RPM_BUILD_ROOT/
%{__python} setup.py install --root=$RPM_BUILD_ROOT --optimize=2
# %py_ocomp $RPM_BUILD_ROOT%{py_sitedir}
# %py_comp $RPM_BUILD_ROOT%{py_sitedir}
# %py_postclean

#gunzip $RPM_BUILD_ROOT/usr/share/man/man8/wicd*.8.gz
#gunzip $RPM_BUILD_ROOT/usr/share/man/man5/wicd*.5.gz

#cd $RPM_BUILD_ROOT/opt/wicd/data
#rm -f wicd.log
#ln -sf /var/log/wicd.log .
echo "" >> $RPM_BUILD_ROOT/var/log/wicd/wicd.log

%clean
[ -d "$RPM_BUILD_ROOT" -a "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT

%post
init_script=wicd
# /sbin/chkconfig --add %{name} >/dev/null 2>&1 || :
if [ -x /usr/lib/lsb/install_initd ]; then
	/usr/lib/lsb/install_initd /etc/init.d/${init_script}
elif [ -x /sbin/chkconfig ]; then
	/sbin/chkconfig --add ${init_script}
	/sbin/chkconfig --level 345 ${init_script} on
#	/sbin/service ${init_script} start
else
	for i in 2 3 4 5; do
		ln -sf /etc/init.d/${init_script} /etc/rc.d/rc${i}.d/S28${init_script}
	done
	for i in 1 6; do
		ln -sf /etc/init.d/${init_script} /etc/rc.d/rc${i}.d/K89${init_script}
	done
fi

# Creation of /var/log/wicd also done in wicd init.d script (due to tmpfs mounting)
mkdir -p $RPM_BUILD_ROOT/var/log/wicd

#mp=$RPM_BUILD_ROOT/etc/rc.local
#touch ${mp}
#echo "" >> ${mp}
#echo "# Added so that wicd can write a log file harmlessly" >> ${mp}
#echo "mkdir -p /var/log/wicd" >> ${mp}
#echo "" >> ${mp}



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
		/sbin/service ${init_script} stop
		/sbin/chkconfig --del ${init_script}
	else
		rm -f /etc/rc.d/rc?.d/???${init_script}
	fi
fi

%files
%defattr(-,root,root)
/usr/lib/python2.5/site-packages/wicd/*
/etc/dbus-1/system.d/wicd.conf
/usr/share/applications/wicd.desktop
/usr/share/icons/hicolor/*/apps/wicd-client.svg
/usr/share/icons/hicolor/*/apps/wicd-client.png
/usr/share/pixmaps/wicd/*
/etc/wicd/*
/var/lib/wicd/configurations/
/usr/bin/wicd-client
/usr/sbin/wicd
/usr/share/wicd/wicd.glade
/usr/lib/wicd/*
/etc/xdg/autostart/wicd-tray.desktop
/usr/share/doc/wicd/*
/usr/share/autostart/wicd-tray.desktop
/var/run/wicd/
/etc/rc.d/init.d/wicd
/usr/share/man/man8/wicd.8.gz
/usr/share/man/man5/wicd-manager-settings.conf.5.gz
/usr/share/man/man5/wicd-wired-settings.conf.5.gz
/usr/share/man/man5/wicd-wireless-settings.conf.5.gz
/etc/acpi/resume.d/80-wicd-connect.sh
/etc/acpi/suspend.d/50-wicd-suspend.sh
/usr/share/locale/*/LC_MESSAGES/wicd.mo
/usr/lib/python2.5/site-packages/Wicd-1.5.0-py2.5.egg-info
/var/log/wicd/wicd.log

%changelog
* Sun Jul 6 2008 Martin Andrews <EeeDora@PLATFORMedia.com> 1.4.2-1
- Proper patching for new version and Fedora 9
* Thu Sep 13 2007 Stuart Gathman <stuart@gathman.org> 1.3.1-3
- run chkconfig for install/uninstall
* Thu Sep 13 2007 Stuart Gathman <stuart@gathman.org> 1.3.1-2
- Fit RH init better.
* Thu Sep 13 2007 Stuart Gathman <stuart@gathman.org> 1.3.1-1
- RPM Spec file

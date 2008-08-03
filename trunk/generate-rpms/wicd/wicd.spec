Summary: Wireless Internet Connection Daemon
Name:   wicd
#Version: 1.3.1
#Release: 3
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
BuildRequires : python-devel
Requires: python chkconfig dbus

%description
wicd was started because of the lack of useful, functional wireless network
connection managers in Linux. It is also capable of connecting to wired
networks as an added bonus. 

%prep
# %setup -q -c
%setup -q
# %patch0 -p1
python setup.py configure

%install
# [ -d "$RPM_BUILD_ROOT" -a "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT
# mkdir $RPM_BUILD_ROOT
# cp -pr * $RPM_BUILD_ROOT
# cd $RPM_BUILD_ROOT/
python setup.py install --root=$RPM_BUILD_ROOT
#gunzip $RPM_BUILD_ROOT/usr/share/man/man8/wicd*.8.gz
#gunzip $RPM_BUILD_ROOT/usr/share/man/man5/wicd*.5.gz

#cd $RPM_BUILD_ROOT/opt/wicd/data
#rm -f wicd.log
#ln -sf /var/log/wicd.log .

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
/usr/lib/python2.5/site-packages/wicd/*
/etc/dbus-1/system.d/wicd.conf
/usr/share/applications/wicd.desktop
/var/log/wicd/
/usr/share/icons/hicolor/scalable/apps/wicd-client.svg
/usr/share/icons/hicolor/192x192/apps/wicd-client.png
/usr/share/icons/hicolor/128x128/apps/wicd-client.png
/usr/share/icons/hicolor/96x96/apps/wicd-client.png
/usr/share/icons/hicolor/72x72/apps/wicd-client.png
/usr/share/icons/hicolor/64x64/apps/wicd-client.png
/usr/share/icons/hicolor/48x48/apps/wicd-client.png
/usr/share/icons/hicolor/36x36/apps/wicd-client.png
/usr/share/icons/hicolor/32x32/apps/wicd-client.png
/usr/share/icons/hicolor/24x24/apps/wicd-client.png
/usr/share/icons/hicolor/22x22/apps/wicd-client.png
/usr/share/icons/hicolor/16x16/apps/wicd-client.png
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
/usr/share/locale/eo/LC_MESSAGES/wicd.mo
/usr/share/locale/ro/LC_MESSAGES/wicd.mo
/usr/share/locale/tr/LC_MESSAGES/wicd.mo
/usr/share/locale/sl_SI/LC_MESSAGES/wicd.mo
/usr/share/locale/ca_ES/LC_MESSAGES/wicd.mo
/usr/share/locale/zh_HK/LC_MESSAGES/wicd.mo
/usr/share/locale/zh_CN/LC_MESSAGES/wicd.mo
/usr/share/locale/el_GR/LC_MESSAGES/wicd.mo
/usr/share/locale/es_GT/LC_MESSAGES/wicd.mo
/usr/share/locale/sv_SE/LC_MESSAGES/wicd.mo
/usr/share/locale/nl/LC_MESSAGES/wicd.mo
/usr/share/locale/da_DK/LC_MESSAGES/wicd.mo
/usr/share/locale/pl/LC_MESSAGES/wicd.mo
/usr/share/locale/ko_KR/LC_MESSAGES/wicd.mo
/usr/share/locale/es_VE/LC_MESSAGES/wicd.mo
/usr/share/locale/pt/LC_MESSAGES/wicd.mo
/usr/share/locale/es/LC_MESSAGES/wicd.mo
/usr/share/locale/es_GL/LC_MESSAGES/wicd.mo
/usr/share/locale/pt_BR/LC_MESSAGES/wicd.mo
/usr/share/locale/sp_MX/LC_MESSAGES/wicd.mo
/usr/share/locale/eu_ES/LC_MESSAGES/wicd.mo
/usr/share/locale/sk/LC_MESSAGES/wicd.mo
/usr/share/locale/vi_VN/LC_MESSAGES/wicd.mo
/usr/share/locale/et_EE/LC_MESSAGES/wicd.mo
/usr/share/locale/ja/LC_MESSAGES/wicd.mo
/usr/share/locale/no/LC_MESSAGES/wicd.mo
/usr/share/locale/lv/LC_MESSAGES/wicd.mo
/usr/share/locale/en_US/LC_MESSAGES/wicd.mo
/usr/share/locale/ua/LC_MESSAGES/wicd.mo
/usr/share/locale/it/LC_MESSAGES/wicd.mo
/usr/share/locale/he/LC_MESSAGES/wicd.mo
/usr/share/locale/gl_ES/LC_MESSAGES/wicd.mo
/usr/share/locale/ml_IN/LC_MESSAGES/wicd.mo
/usr/share/locale/fi/LC_MESSAGES/wicd.mo
/usr/share/locale/cs_CZ/LC_MESSAGES/wicd.mo
/usr/share/locale/fr/LC_MESSAGES/wicd.mo
/usr/share/locale/de/LC_MESSAGES/wicd.mo
/usr/share/locale/zh_TW/LC_MESSAGES/wicd.mo
/usr/share/locale/hu/LC_MESSAGES/wicd.mo
/usr/share/locale/ar_EG/LC_MESSAGES/wicd.mo
/usr/share/locale/ru/LC_MESSAGES/wicd.mo
/usr/share/locale/bg_PHO/LC_MESSAGES/wicd.mo
/usr/share/locale/bg/LC_MESSAGES/wicd.mo
/usr/share/locale/te_IN/LC_MESSAGES/wicd.mo
/usr/lib/python2.5/site-packages/Wicd-1.5.0-py2.5.egg-info

%changelog
* Sun Jul 6 2008 Martin Andrews <EeeDora@PLATFORMedia.com> 1.4.2-1
- Proper patching for new version and Fedora 9
* Thu Sep 13 2007 Stuart Gathman <stuart@gathman.org> 1.3.1-3
- run chkconfig for install/uninstall
* Thu Sep 13 2007 Stuart Gathman <stuart@gathman.org> 1.3.1-2
- Fit RH init better.
* Thu Sep 13 2007 Stuart Gathman <stuart@gathman.org> 1.3.1-1
- RPM Spec file

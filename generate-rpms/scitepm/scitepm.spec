#
# spec file for package scitepm
#
# Copyright  (c)  2008 - Martin Andrews
# This file and all modifications and additions to the pristine
# package are under the same license as the package itself.
#

%define is_mandrake %(test -e /etc/mandrake-release && echo 1 || echo 0)
%define is_suse %(test -e /etc/SuSE-release && echo 1 || echo 0)
%define is_fedora %(test -e /etc/fedora-release && echo 1 || echo 0)

%define dist redhat
%define disttag rh

%define _bindir		/usr/bin
%define _datadir	/usr/share

%if %is_mandrake
%define dist mandrake
%define disttag mdk
%endif
%if %is_suse
%define dist suse
%define disttag suse
%define kde_path /opt/kde3
%define _bindir		%kde_path/bin
%define _datadir	%kde_path/share
%endif
%if %is_fedora
%define dist fedora
#%define disttag rhfc
%define disttag fc
%endif

%define _iconsdir	%_datadir/icons
%define _docdir		%_datadir/doc
%define _localedir	%_datadir/locale
# %define qt_path		/usr/lib/qt3

%define distver %(release="`rpm -q --queryformat='%{VERSION}' %{dist}-release 2> /dev/null | tr . : | sed s/://g`" ; if test $? != 0 ; then release="" ; fi ; echo "$release")
# %define distlibsuffix %(%_bindir/kde-config --libsuffix 2>/dev/null)
# %define _lib lib%distlibsuffix
%define packer %(finger -lp `echo "$USER"` | head -n 1 | cut -d: -f 3)

Name:      scitepm
#Icon:      sciptepm.xpm
Summary:   Programmer code helper sidebar for SciTE
Version:   1.6.13
Release:   1.%{disttag}%{distver}
#Release:			1%{?dist}
License:   GPL
Vendor:    The SciTEpm development team <scitepm@sourceforge.net>
Packager:  %packer
Group:     Development/Editors
#Source0:   %{name}2-%version.tar.bz2
Source0:   %{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
#BuildRoot: %{_tmppath}/%{name}2-%{version}-%{release}-build
#BuildRequires: kdebase3-devel
#Prereq: /sbin/ldconfig
BuildRequires : gtk2-devel
BuildRequires : glib2-devel
Requires: scite
#Requires: gtk+-2.0 
#Requires: glib-2.0
#Requires: gtk+
Requires: glib2
Provides: scitepm

%description
ScitePM is a sidebar utility that makes working with SciTE a little more programmer-centric.
By showing the program file organisation logically, rather than as laid out on the filesystem, 
ScitePM makes the life of a developer easier.

 
%prep
#echo %_target
#echo %_target_alias
#echo %_target_cpu
#echo %_target_os
#echo %_target_vendor
echo Building %{name}-%{version}-%{release}

%setup -q

%build
#CFLAGS="%optflags" CXXFLAGS="%{optflags}" \
#        ./configure --mandir=%{_mandir}\
#	            --disable-rpath \
#		    --with-xinerama \
#		    --without-gl \
#		    --disable-debug \
#		    --disable-cppunit \
#		    --enable-final
make

%install
mkdir -p  %{buildroot}%{_bindir}
make INSTALLDIR=%{buildroot}%{_bindir} install

%clean
[ "${RPM_BUILD_ROOT}" != "/" ] && rm -rf ${RPM_BUILD_ROOT}

%post
#cd %_docdir/HTML/*/%{name}2
#ln -s ../common common
#/sbin/ldconfig

%postun
#/sbin/ldconfig

%files
%defattr(-,root,root)

#%dir %_docdir/HTML/en/%{name}2/
#%doc %_docdir/HTML/*/%{name}2/*.docbook
#%doc %_docdir/HTML/*/%{name}2/*.png
#%doc %_docdir/HTML/*/%{name}2/index.cache.bz2

# the binary files
%attr(0755,root,root) %{_bindir}/%{name}

# the shared libraries
#%kde_path/%_lib/*.so.*.*.*

%changelog
* Thu Jul 8 2008 - ScitePM _at_ PLATFORMedia.com
- Created spec.base file, and updated 'make tarball'

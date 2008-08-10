#
# This file and all modifications and additions to the pristine
# package are under the same license as the package itself.
#
# norootforbuild

Name:             truecrypt
Version:         6.0a
Release:         2.1
Obsoletes:       truecrypt-kmp =< 4.3a
BuildRoot:       %{_tmppath}/%{name}-%{version}-build
BuildRequires:  gcc-c++ >= 4.0 pkgconfig desktop-file-utils
BuildRequires:  fuse-devel wxGTK-devel >= 2.8.0
%if 0%{?suse_version} > 910
BuildRequires:  update-desktop-files
%endif

License:         TrueCrypt License Version 2.5
Group:            System/Libraries
Url:              http://www.truecrypt.org
Source0:         truecrypt-%{version}-source.tar.gz
Source1:         truecrypt-%{version}-source.tar.gz.sig
Source2:         truecrypt.desktop
# Borrowed from gentoo and Fedora:-)
Patch0:          %{name}-%{version}-wx.patch
# just to get rid of some compiler warnings:
Patch1:          %{name}-%{version}-parentheses.patch
Summary:         Free open-source disk encryption software for Windows Vista/XP/2000, Mac OS X and Linux

%description
TrueCrypt is a software system for establishing and maintaining an on-the-fly-encrypted volume (data storage device).

On-the-fly encryption means that data are automatically encrypted or decrypted right before they are loaded or saved, without any user intervention.
No data stored on an encrypted volume can be read (decrypted) without using the correct password/keyfile(s) or correct encryption keys. 

Entire file system is encrypted (i.e., file names, folder names, contents of every file, and free space).

Authors:
--------
 - TrueCrypt Foundation <ennead@truecrypt.org>
 - Paul Le Roux

%prep
%setup -n truecrypt-%{version}-source
%patch0 -p1
%patch1 -p1

%build
make

%install
%{__install} -D -m 0755 Main/truecrypt %{buildroot}%{_bindir}/truecrypt

%__install -d -m 755 %{buildroot}%{_datadir}/pixmaps
%__install -m 644 Resources/Icons/TrueCrypt-16x16.xpm %{buildroot}%{_datadir}/pixmaps/truecrypt.xpm
%if 0%{?suse_version}
  %__cp %{SOURCE2} %{name}.desktop
  %suse_update_desktop_file -i %{name}
%elseif %{defined fedora_version}
  desktop-file-install --dir=%{buildroot}%{_datadir}/applications/ %{SOURCE2}
%endif


%clean
%{__rm} -rf %{buildroot}

%files
#%defattr(-, root, root,-)
%attr(0755,root,root) %{_bindir}/truecrypt
%doc Release/Setup\ Files/* Readme.txt
%{_datadir}/applications/%{name}.desktop
%{_datadir}/pixmaps/truecrypt.xpm

%changelog -n truecrypt
* Sat Jul 12 2008 Nico Kruber <nico.laus.2001@gmx.de>
- update to 6.0a
* Sat Jul 05 2008 Nico Kruber <nico.laus.2001@gmx.de>
- update to 6.0
- added entry in start menu
- included program icon
* Thu Feb 21 2008 - dmacvicar@suse.de
- update to 5.0a
* Sun Sep 23 2007 - dmacvicar@suse.de
- fix build on 10.3 and Factory
* Thu Sep  6 2007 - dmacvicar@suse.de
- Add dependency on the kernel module
* Mon May 21 2007 - dmacvicar@suse.de
- Update to 4.3a
* Mon Aug 21 2006 - dmacvicar@suse.de
- Add patches from Gentoo to compile on 2.6.18
* Mon Jul  3 2006 - dmacvicar@suse.de
- Update to 4.2a
* Thu Jun 01 2006 - dmacvicar@suse.de
- initial package of 4.2

#! /usr/bin/perl -w
use strict;

my $rpms = '';
$rpms .= qq(
 # Basic build tools
 make  gcc 
 rpm-build
 createrepo
 
 # Downloader (handy)
 curl 
);


$rpms .= qq(
# For building overall
 livecd-tools
 
# For artwork
 ImageMagick
	
# For acpi
 acpid
 
# For truecrypt  ...
 fuse-devel wxGTK-devel
	fuse wxGTK
 
# For uvc (webcam)
 SDL SDL-devel

# For wicd
	dhclient 
	chkconfig 
 python-devel 
	python dbus dbus-python 
	pygtk2-libglade pygtk2
 
# For scitepm
 gtk2-devel glib2-devel
	scite glib2
	
# For eee-user-defaults
	bash firefox scite
	
# For madwifi 
 module-init-tools hwdata

);

my @rpms=();
foreach my $rpm (split('\s*\n\s*', $rpms)) {
 next if($rpm =~ m{^\s*(\#.*)?$});  # Remove comments
 push @rpms, split('\s+', $rpm);    # Separate out within the lines
}

#print map { "rpm='$_'\n"} @rpms;
#exit 0;

my @rpms_installed=split("\n", `rpm -qa --queryformat "%{=NAME}\\n"`);

my %rpms_missing=();
foreach my $rpm (sort @rpms) {
 print "Checking for '$rpm'\n";
 my $found=grep( m{^$rpm}, @rpms_installed);
 next if($found);
 $rpms_missing{$rpm}=1;
}
if(%rpms_missing) {
 print "Need to do :\nyum install ",join(' ',sort keys %rpms_missing),"\n";
}
else {
 print "All RPMs installed Ok!\n";
}

my @packages=qw(
);

my %packages_missing=();
foreach my $package (@packages) {
 local $@=undef;
 eval qq{require $package}; 
	next unless($@);
	$packages_missing{$package}=1;
}
if(%packages_missing) {
 print qq{Need to do :\nperl -MCPAN -e shell;\n},(map { "install $_;\n" } sort keys %packages_missing),qq{\n};
}
else {
 print "All perl packages Ok!\n";
}

1;

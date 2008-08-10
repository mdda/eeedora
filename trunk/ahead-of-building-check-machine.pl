#! /usr/bin/perl -w
use strict;

my $rpms = '';
$rpms .= qq(
 # Basic build tools
 make  gcc 
 rpm-build
 
 # Downloader (handy)
 curl 
);


$rpms .= qq(
# For building overall
 livecd-tools
 
# For artwork
 ImageMagick
 
# For truecrypt  ...
 
# For uvc (webcam)
 SDL SDL-devel

# For wicd
 python-devel
 
# For scitepm
 gtk2-devel glib2-devel

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
foreach my $rpm (@rpms) {
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
 print "All perl use packages Ok!\n";
}

1;

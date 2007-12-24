#! /usr/bin/perl

my %ev=(
 'button/sleep' => 'zzz',
 'button/lid' =>  'lid',
 'button/power' => 'power',
 'hotkey ATKD 00000011' => 'wifi',
 'hotkey ATKD 00000030' => 'vga',
 'hotkey ATKD 00000012' => 'apps',
 'hotkey ATKD 00000013' => 'mute',
 'hotkey ATKD 00000014' => 'voldown',
 'hotkey ATKD 00000015' => 'volup',
);
foreach my $k (keys %ev) {
# if(open(FEV,">/etc/acpi/events/$ev{$k}.conf")) {
 if(open(FEV,">events/$ev{$k}.conf")) {
  print FEV "# Event file for Eee Event : $ev{$k}\n";
  print FEV qq(event=$k\naction=/etc/acpi/actions/eee "$ev{$k}" "%e"\n);
  close(FEV);
 }
}

#action=/etc/acpi/actions/eee zzz "%e"

exit
__END__
# These are the brightness buttons - handled pretty well by the Asus BIOS(?)
#event=hotkey ATKD 0000002[0123456789abcdef]
#action=/etc/acpi/actions/eee brightness "%e"

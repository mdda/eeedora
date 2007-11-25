# This is  a kickstart file for the 'liveinst' install of the live image onto the Eee

# Wowza!

lang en_US.UTF-8
keyboard us
timezone US/Eastern
auth --useshadow --enablemd5

#selinux --enforcing
selinux --disabled

network --device eth0 --bootproto dhcp

#firewall --disabled
firewall --enabled --trust=eth0 --ssh

#xconfig --card "VMWare" --videoram 16384 --hsync 31.5-37.9 --vsync 50-70 --resolution 800x600 --depth 16
#xconfig --startxonboot --defaultdesktop=XFCE
# This is an idea... since we know the correct configuration...
skipx 

#Switch this over - not having sshd is more secure (until a non-public password is set)
#services --enabled=NetworkManager --disabled=network,sshd
services --enabled=NetworkManager,network,sshd 

# This is for the real install
clearpart --drives sda
part / --fstype ext2 --size 1 --ondisk=sda --asprimary --grow

#part swap --recommended DO NOT WANT

# A default public root password - not the best idea.
rootpw eee

%post

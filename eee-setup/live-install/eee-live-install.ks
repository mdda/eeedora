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
ShowProgress() {
 echo $"LiveInstall : $1" >> /etc/eeedora.progress
}
# By this stage, this is already on the new machine, opened up
setup=/root/eee-setup


fedoranonlive=/etc/rc.d/init.d/fedora-nonlive

ShowProgress "Creating ${fedoranonlive} (needed for post-install processing)"
cp ${setup}/services/fedora-nonlive ${fedoranonlive} 
chmod 755 ${fedoranonlive}
/sbin/restorecon ${fedoranonlive}

ShowProgress "Set ${fedoranonlive} as the task after this script is done"
/sbin/chkconfig --add fedora-nonlive

#ShowProgress "Save a little bit of space at least..."
#rm -f /boot/initrd*

# workaround avahi segfault (#279301)
#touch /etc/resolv.conf
#/sbin/restorecon /etc/resolv.conf

ShowProgress "End of Kickstart script"
%end

# This is  a kickstart file for the 'liveinst' install of the live image onto the Eee

# Wowza!
interactive

lang en_US.UTF-8
keyboard us
timezone US/Eastern
auth --useshadow --enablemd5

#selinux --enforcing
selinux --disabled

# Not sure which of these is present...
network --device eth0 --bootproto dhcp --hostname=Eee
#network --device eth1 --bootproto dhcp --hostname=Eee

#firewall --disabled
#firewall --enabled --trust=eth0 --ssh
firewall --enabled --ssh

#xconfig --card "VMWare" --videoram 16384 --hsync 31.5-37.9 --vsync 50-70 --resolution 800x600 --depth 16
#xconfig --startxonboot --defaultdesktop=XFCE
# This is an idea... since we know the correct configuration...
skipx 

#Switch this over - not having sshd is more secure (until a non-public password is set)
#services --enabled=NetworkManager --disabled=network,sshd
#services --enabled=NetworkManager,network,sshd 
services --enabled=network --disabled=NetworkManager,sshd

# This is for the real install
# zerombr yes # Now options for zerombr are deprecated
zerombr

ignoredisk --drives=sdb,sdc,sdd
clearpart --all --drives sda
part / --fstype ext2 --ondisk=sda --asprimary --size 1 --grow --fsoptions="noatime"
#part / --fstype ext2 --ondisk=sda --asprimary --size 1 --grow --fsoptions="noatime" --label=/EeeDora
#part swap --recommended DO.NOT.WANT.

#bootloader --location=none
bootloader --location=mbr --timeout=3

# A default public root password - not the best idea.
rootpw eeedora

%post
ShowProgress() {
# echo $"LiveInstall : $1" >> /etc/eeedora.progress
 echo $"real-kickstart :"`date +%F_%H-%M`" : $1" >> /etc/eeedora.progress
}
ShowProgress "Start of RealInstall Kickstart script"

# By this stage, this is already on the new machine, opened up
setup=/root/eee-setup

# We are able to comment these out - done by eedora.ks when building the original ISO image
#
# ShowProgress "Blacklist the ath5k kernel module"
# ${setup}/ath/blacklist-ath5k ${setup}
#
# ShowProgress "Install the ath kernel module"
# ${setup}/ath/install-ath ${setup}
#
# ShowProgress "Install the atl2 kernel module"
# ${setup}/atl2/install-atl2 ${setup}

fb=eeedora-firstboot
init=/etc/rc.d/init.d

ShowProgress "Creating  ${init}/${fb} (needed for post-install processing)"
cp ${setup}/services/${fb} ${init}/${fb}
chmod 755 ${init}/${fb}
/sbin/restorecon ${init}/${fb}

ShowProgress "Set ${init}/${fb} as the task after this script is done"
/sbin/chkconfig --add ${fb}

# workaround avahi segfault (#279301)
touch /etc/resolv.conf
/sbin/restorecon /etc/resolv.conf

ShowProgress "End of RealInstall Kickstart script"
%end

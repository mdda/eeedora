# This is  a kickstart file for the 'liveinst' install of the live image onto the Eee

# Wowza!
interactive

lang en_US.UTF-8
keyboard us
timezone US/Eastern
auth --useshadow --enablemd5

#selinux --enforcing
selinux --disabled

# Not sure whether this is present...
#network --device eth0 --bootproto dhcp

#firewall --disabled
#firewall --enabled --trust=eth0 --ssh
firewall --enabled --ssh

#xconfig --card "VMWare" --videoram 16384 --hsync 31.5-37.9 --vsync 50-70 --resolution 800x600 --depth 16
#xconfig --startxonboot --defaultdesktop=XFCE
# This is an idea... since we know the correct configuration...
skipx 

#Switch this over - not having sshd is more secure (until a non-public password is set)
#services --enabled=NetworkManager --disabled=network,sshd
services --enabled=NetworkManager,network,sshd 

# This is for the real install
# zerombr yes # Now options for zerombr are deprecated
zerombr yes

ignoredisk --drives=sdb,sdc,sdd
clearpart --all --drives sda
part / --fstype ext2 --ondisk=sda --asprimary --size 1 --grow --fsoptions="noatime"
#part swap --recommended DO.NOT.WANT.

#bootloader --location=none
#bootloader --location=mbr
bootloader --location=mbr --timeout=3

# A default public root password - not the best idea.
rootpw eee

# Problem in anaconda :
#03:46:35 INFO    : moving (1) to step installpackages
#03:46:35 INFO    : Preparing to install packages
#03:48:49 INFO    : moving (1) to step postinstallconfig
#03:48:49 INFO    : doing post-install fs mangling
#03:48:49 INFO    : going to do resize
#03:48:53 INFO    : trying to mount sys on /sys
#03:48:53 INFO    : set SELinux context for mountpoint /sys to False
#03:48:53 DEBUG   : isys.py:mount()- going to mount sys on /mnt/sysimage/sys
#03:48:53 DEBUG   : isys.py:mount()- going to mount /selinux on /mnt/sysimage/selinux
#03:48:53 ERROR   : error mounting selinuxfs: (19, 'No such device')
#03:48:53 DEBUG   : isys.py:mount()- going to mount /dev on /mnt/sysimage/dev

# Got to line 1202 of livecd.py...  But the root filesystem isn't mounted in the right place, so there is no /etc





%post
ShowProgress() {
# echo $"LiveInstall : $1" >> /etc/eeedora.progress
 echo $"real-kickstart :"`date +%F_%H-%M`" : $1" >> /etc/eeedora.progress
}
ShowProgress "Start of RealInstall Kickstart script"

# By this stage, this is already on the new machine, opened up
setup=/root/eee-setup

ShowProgress "Install the atl2 kernel module"
${setup}/atl2/install-atl2 ${setup}

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

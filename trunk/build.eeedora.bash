#! /bin/bash

# EeeDora Announcement : http://forum.eeeuser.com/viewforum.php?id=10

# See : http://fedoraproject.org/wiki/FedoraLiveCD/LiveCDHowTo

eeedora="EeeDora-20071119"
mkdir yum-cache 

livecd-creator \
  --config=./eeedora.ks \
  --cache=`pwd` \
  --fslabel=${eeedora} \
  | tee livecd-creator.output

grep "Installing" livecd-creator.output | sort > packages.output

#### TO DO : 
# Check install works
# Get the eth0 connection working : 
#   atheros L2 100Mbit Ethernet adapter (PCI)
#   driver : atl2 (i.e. ATL2)
#   LOOK AT : http://forums.fedoraforum.org/showthread.php?t=162793&page=1&pp=15
# Get the wlan0 connection working : 
#   atheros AR5007EG 802.11 b/g wireless
#   driver : ath_pci

# Fix up /etc/fstab : 
# noatime for the ext2 /dev/sda
# Add a tmpfs for the logging, like in :
#     http://forum.eeeuser.com/viewtopic.php?id=890

# Make auto-login smooth, with desktop showing
# Put in suitable xorg.conf


### NB : To boot of a flash drive, put it in the USB slot, and switch on the machine
# Then hit 'F2' to get to the BIOS
# Switch the Harddisk to the USB drive (not the internal one)
# Then, the machine will look to the USB first.

# Booting a USB drive on the Eee : 
#  Switch off machine
#  Insert bootable USB drive in any socket
#  Switch on machine
#  Press F2 once for the BIOS Setup
#  Right arrow across to Boot
#  Set 'BootBooster' to disabled (gives you more time at start)
#  Set 'Hard Disk Drives' to have the USB device as 1st Drive
#  Set 'Boot Device Priority' to have the HDD (now the USB drive) at the top
#  Save and Exit
#  It should boot into the USB drive


echo -n $"Write to USB drive on /dev/sdb1 ? [yes/NO] "
read answer1
if [ "$answer1" = "yes" ] ; then
 echo -n $"Are you sure you want to put it on /dev/sdb1 ? [yes/NO] "
 read answer2
 if [ "$answer2" = "yes" ] ; then
  # See : http://fedoraproject.org/wiki/FedoraLiveCD/USBHowTo
  /usr/bin/livecd-iso-to-disk ${eeedora}.iso /dev/sdb1 
  echo -n $"Run a QEMU session to test the USB Image on /dev/sdb1 ? [yes/NO] "
   read answer3
   if [ "$answer3" = "yes" ] ; then
    qemu -hda /dev/sdb -m 256 -std-vga -no-kqemu
   fi
 fi
fi

exit 0;

### Notes on USB Flash drives for 
# http://www.redhat.com/archives/kickstart-list/2005-October/msg00062.html

# Test a simple disk image for Fedora 8 :
# curl -O http://fedora.mirror.facebook.com/linux/releases/8/Fedora/i386/os/images/diskboot.img
# dd if=diskboot.img of=/dev/sdb

# Check that it'll work :
# qemu -hda /dev/sdb -m 256 -std-vga -no-kqemu

# Create an empty partition on the USB : 
#  FAT16 (vfat) Bootable (becomes /dev/sdb1), using :
# /sbin/cfdisk /dev/sdb


# Mounting the Live Image for checking...

mkdir /media/eeedora-image
mount -o loop -t squashfs /media/disk/LiveOS/squashfs.img  /media/eeedora-image
ls -l /media/eeedora-image/

mkdir /media/liveos-ext3
mount -o loop -t ext3 /media/eeedora-image/LiveOS/ext3fs.img  /media/liveos-ext3
ls -l /media/liveos-ext3/


# revisor.conf information :
#  http://revisor.fedoraunity.org/documentation/revisor-configuration-files
#  http://revisor.fedoraunity.org/documentation/revisor-configuration-all-the-options

#revisor \
#	--config=./revisor.eeedora.conf \
#	--debug \
#	--gui \
#	--model=f8-i386 \

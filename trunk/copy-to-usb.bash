#! /bin/bash

# Usage : copy-to-usb /dev/sdb1 EeeDora_XYZ.iso

# This is the drive to put the USB Live image on to
usbpart=${1:-/dev/sdb1}
# This is the iso file
eeedora_iso=${2:-$( ls *.iso | tail -1 )}

# Let's reparse that to get the drive information
usbdrive=$( echo ${usbpart} | sed 's|[1234]$||') 

echo "Drive: ${usbdrive}, Partition: ${usbpart}, ISO: ${eeedora_iso}"

# EeeDora Announcement : http://forum.eeeuser.com/viewforum.php?id=10
dt='date +%F_%Hh%Mm'

# This is just a temporary mount point
#usbmount=/media/temp-usb-mountpoint

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

# append initrd=initrd0.img root=/dev/sdb1 rootfstype=vfat ro quiet liveimg


usbcopystart='NotDone'
usbcopyend='NotDone'

echo -n $"Write to USB drive on ${usbpart} ? [yes/NO] "
read answer1
if [ "$answer1" = "yes" ] ; then
	# See : http://fedoraproject.org/wiki/FedoraLiveCD/USBHowTo
	usbcopystart=`${dt}`

 # This is to allow the USB to mount if you just inserted it (sloppy, I know)
 sleep 5

	/usr/bin/livecd-iso-to-disk --overlay-size-mb 128 ${eeedora_iso} ${usbpart}

#	mkdir ${usbmount}

	# Remove this later - the drivers are going to go into RPMs anyway
#	mount ${usbpart} ${usbmount}

#	mkdir ${usbmount}/drivers
#	cp drivers/atl2/atl2.ko ${usbmount}/drivers/
# 	cp scripts/install-atl2 ${usbmount}/drivers/

	# Actually, the scripts are a good thing for development...
#	mkdir -p ${usbmount}/scripts
#	cp scripts/install-atl2 ${usbmount}/scripts/
#	cp scripts/report-back.bash ${usbmount}/scripts/
#	cp scripts/start-xfce ${usbmount}/scripts/

	# http://fedoraproject.org/wiki/Artwork/F8Themes/Infinity/Round3Final#head-8302d21a33d6f60a43f54da05aa423b14a327131

# The next line works - but I'd like to see whether it actually comes from /boot/grub/
#	convert -colors 65536 -depth 16 eee-setup/artwork/eeedora-splash.png ${usbmount}/syslinux/splash.jpg
#	mv ${usbmount}/syslinux/syslinux-vesa-splash.png ${usbmount}/syslinux/splash.jpg

#	umount ${usbmount}
#	rmdir ${usbmount}
	
	usbcopyend=`${dt}`

	#echo -n $"Run a QEMU session to test the USB Image on ${usbdrive} ? [yes/NO] "
	#read answer3
	#if [ "$answer3" = "yes" ] ; then
	#	qemu -hda ${usbdrive} -m 256 -std-vga -no-kqemu
	#fi
fi

echo "Copied ISO to USB : ${usbcopystart} to ${usbcopyend}"

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

#mkdir /media/liveos-ext3
#mount -o loop -t ext3 /media/eeedora-image/LiveOS/ext3fs.img  /media/liveos-ext3
#s -l /media/liveos-ext3/
mkdir /media/liveos-ext2
mount -o loop -t ext3 /media/eeedora-image/LiveOS/ext2fs.img  /media/liveos-ext2
ls -l /media/liveos-ext2/


# revisor.conf information :
#  http://revisor.fedoraunity.org/documentation/revisor-configuration-files
#  http://revisor.fedoraunity.org/documentation/revisor-configuration-all-the-options

#revisor \
#	--config=./revisor.eeedora.conf \
#	--debug \
#	--gui \
#	--model=f8-i386 \

# Hmm : What is a PC-e mini slot ?

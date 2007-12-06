#! /bin/bash

# EeeDora Announcement : http://forum.eeeuser.com/viewforum.php?id=10
dt='date +%F_%H-%M'

# This is the ISO name (and the name of the distribution)
eeedora=EeeDora-`${dt}`

# Now for the code :

# Create the repository of eee specific rpms (used in kickstart file)
mkdir -p rpms-for-eee/i386
# There really needs to be rpms in there, though...
# TODO : Add a check for decent RPM (eee_tarball-x.y.z.a.rpm)

createrepo rpms-for-eee

# set up a link for the repo 
ln -s `pwd`/rpms-for-eee /mnt/eee-specific


# See : http://fedoraproject.org/wiki/FedoraLiveCD/LiveCDHowTo

# This caches rpms locally (you should clean this out once you're done)
mkdir yum-cache 

creatingstart=`${dt}`

echo "Starting ISO creation at ${creatingstart}"

livecdcreator=/usr/bin/livecd-creator
if [ -f ${livecdcreator} ]; then 
	# Fix up /usr/bin/livecd-creator, because the default size of the image is 4096, which is too large to 
	# transfer onto the internal drive of the Eee
	#         self.image_size = 2048 # in megabytes
	# NB : I know that this is a REALLY HORRIBLE thing to do.
	grep image_size ${livecdcreator}

	cp ${livecdcreator} ${livecdcreator}-orig
	sed -i 's|^\([ ]*self.image_size =\).*$|\1 2048 # Updated for Eee Internal Drive|' ${livecdcreator}

	grep image_size ${livecdcreator}
fi

# http://www-128.ibm.com/developerworks/linux/library/l-fedora-livecd/
# See http://www.redhat.com/archives/anaconda-devel-list/2007-July/msg00054.html to understand (important --turbo-liveinst)
#  --turbo-liveinst 
livecd-creator \
  --config=./eeedora.ks \
  --cache=`pwd` \
  --fslabel=${eeedora} \
  | tee livecd-creator-output.${creatingstart}

# Undo the alteration
mv ${livecdcreator}-orig ${livecdcreator}
grep image_size ${livecdcreator}

grep "Installing" livecd-creator-output.${creatingstart} | sort | sed 's|\r||' > packages-output.${creatingstart}

rm -f /mnt/eee-specific

creatingend=`${dt}`

#### TO DO : 
# Get the eth0 connection working : 
#   atheros L2 100Mbit Ethernet adapter (PCI)
#   driver : atl2 (i.e. ATL2)
#   LOOK AT : http://forums.fedoraforum.org/showthread.php?t=162793&page=1&pp=15
# Get the wlan0 connection working : 
#   atheros AR5007EG 802.11 b/g wireless
#   driver : ath_pci
#   LOOK AT : http://wiki.eeeuser.com/ubuntu

# Fix up /etc/fstab : 
# noatime for the ext2 /dev/sda
# Add a tmpfs for the logging, like in :
#     http://forum.eeeuser.com/viewtopic.php?id=890

# Make auto-login smooth, with desktop showing

echo -n $"Write to USB drive ? [yes/NO] "
read answer1
if [ "$answer1" = "yes" ] ; then
 ./copy-to-usb.bash "" ${eeedora}.iso
fi

echo "Created ISO       : ${creatingstart} to ${creatingend}"

exit 0;

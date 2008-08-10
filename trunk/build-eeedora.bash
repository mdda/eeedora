#! /bin/bash

# EeeDora Announcement : http://forum.eeeuser.com/viewforum.php?id=10
dt='date +%F_%Hh%Mm'

# This is the ISO name (and the name of the distribution)
eeedora=EeeDora_`${dt}`

# Create the repository of eee specific rpms (used in kickstart file)
mkdir -p rpms-for-eee/i386
# There really needs to be rpms in there, though...
# TODO : Add a check for decent RPM (eee_tarball-x.y.z.a.rpm)

createrepo rpms-for-eee

# set up a link for the repo - needed since the file:// location in the kickstart file is absolute
ln -s `pwd`/rpms-for-eee /mnt/eee-specific

# See : http://fedoraproject.org/wiki/FedoraLiveCD/LiveCDHowTo

# This caches rpms locally (you should clean this out once you're completely done)
cachedir=`pwd`/yum-cache 
mkdir -p ${cachedir}

# Clean out this cache directory - in case we've been making updates to RPMs without incrementing version #s properly
rm -rf ${cachedir}/eee-specific

creatingstart=`${dt}`

echo "Starting ISO creation at ${creatingstart}"

#livecdcreator=/usr/bin/livecd-creator
#if [ -f ${livecdcreator} ]; then 
#	# Fix up /usr/bin/livecd-creator, because the default size of the image is 4096, which is too large to 
#	# transfer onto the internal drive of the Eee
#	#         self.image_size = 2048 # in megabytes
#	# NB : I know that this is a REALLY HORRIBLE thing to do.
# echo "Before ${livecdcreator} Replace"
# grep "self.image_size = " ${livecdcreator}
#
#	cp ${livecdcreator} ${livecdcreator}-orig
#	sed -i 's|^\([ ]*self.image_size =\) 4096 .*$|\1 2048 # Updated for Eee Internal Drive|' ${livecdcreator}
#
# echo "After ${livecdcreator} Replace"
#	grep "self.image_size = " ${livecdcreator}
#fi

# /usr/lib/python2.5/site-packages/imgcreate/creator.py


# http://www-128.ibm.com/developerworks/linux/library/l-fedora-livecd/
# See http://www.redhat.com/archives/anaconda-devel-list/2007-July/msg00054.html to understand (important --turbo-liveinst)
#  --turbo-liveinst 

# ./flash-livecd-creator 

livecd-creator \
  --config=./eeedora.ks \
  --cache=${cachedir} \
  --fslabel=${eeedora} \
  | tee livecd-creator-output.${creatingstart}
#		--skip-minimize \

## Undo the alteration
#mv ${livecdcreator}-orig ${livecdcreator}
#
#echo "After ${livecdcreator} Finished"
#grep "self.image_size = " ${livecdcreator}

grep "Installing" livecd-creator-output.${creatingstart} | sort | sed 's|\r||' > packages-output.${creatingstart}

# kill the eee-specific repo mount point 
rm -f /mnt/eee-specific

creatingend=`${dt}`

# exit

echo -n $"Write to USB drive ? [yes/NO] "
read answer1
if [ "$answer1" = "yes" ] ; then
 ./copy-to-usb.bash "" ${eeedora}.iso
fi

echo "Created ISO       : ${creatingstart} to ${creatingend}"

exit 0;

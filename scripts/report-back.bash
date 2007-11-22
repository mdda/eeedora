#! /bin/bash

# This just dumps a complete state-of-play into a dated subdirectory 
# of the current dir - useful for information gathering on the (tiny) Eee

dated = eee-fedora.`date +%F.%T`

mkdir ${dated}

pushd .
cd ${dated}

dmesg > dmesg.txt
mount > mount.txt
cp /etc/fstab .
cp /var/log/messages .
/sbin/lsmod > lsmod.txt
/sbin/ifconfig > ifconfig.txt
/sbin/iwconfig > iwconfig.txt
cp /etc/X11/xorg.conf .
cp /var/log/Xorg.0.log .
history > history.txt

popd .

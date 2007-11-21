#! /bin/bash
mkdir ./eee-fedora
cd eee-fedora

dmesg > dmesg.txt
mount > mount.txt
cp /etc/fstab .
cp /var/log/messages .
/sbin/lsmod > lsmod.txt
/sbin/ifconfig > ifconfig.txt
/sbin/iwconfig > iwconfig.txt
cp /etc/X11/xorg.conf .
cp /var/log/Xorg.0.log .

cd ..
# Kickstart file for EeeDora - Fedora for the EeePC

# Interesting : http://rhcelinuxguide.wordpress.com/2006/06/23/linux-install-options-in-fedora/

lang en_US.UTF-8
keyboard us
timezone US/Eastern
auth --useshadow --enablemd5

#selinux --enforcing
selinux --disabled

# This needs a --device command
network --device eth0 --bootproto dhcp --hostname=Eee

#firewall --disabled
#firewall --enabled --trust=eth0 --ssh
firewall --enabled --ssh

# This is since we know the correct configuration...
skipx 

#Switch this over - not having sshd is more secure (until a non-public password is set)
#services --enabled=NetworkManager --disabled=network,sshd
#services --enabled=NetworkManager,network,sshd 
services --enabled=network --disabled=NetworkManager,sshd

# Force the kickstart to recognize the atl2 driver ASAP
#device atl2

# OLD : No Partition information required to build the ISO 
# New : Fedora 9 livecd-creator looks for a '/' definition for sizing and filesystem information
#part / --fstype ext2 --size 1792 --grow

# This is so it will build on my 701 4G EeePC - but the live system doesn't need to be 
# very big anyway...
part / --fstype ext2 --size 1350 --grow


# A default public root password - not the best idea.
rootpw eeedora

#If you installed *ubuntu the normal way with one big 4gb partition on the SSD, there only needs to be one line in your /etc/fstab file, the one mounting /
#  UUID=[your-uuid-here]   /    ext2    defaults,errors=remount-ro,noatime  0     1
#Mine has the added "noatime" option to reduce harddrive writes (nice but not necessary), and also it's "ext2" though yours might be "ext3" which is okay because that's the default.

# xrandr --output VGA --right-of LVDS --mode 1024x768
# xrandr --auto

#Don't forget to install the  libgl1-mesa-dri , libgl1-mesa-glx , libglu1-mesa libraries for full 3D graphics.  

#And use the xxmc video option in xine (or whatever).
#EDIT:  Correction:  the xv video option may be better.

#Also, if you need to drive a monitor with an odd resolution you can do:
#xrandr --newmode 1280x720  74.50  1280 1344 1472 1664  720 723 728 748
#xrandr --addmode VGA 1280x720
#xrandr --output LVDS --off
#xrandr --output VGA --mode 1280x720

# Post-install creation of kickstart file :
#  http://xml2hostconf.sourceforge.net/

# Look for mirrors in : http://mirrors.fedoraproject.org/publiclist/Fedora/8/i386/

#repo --name=releases --baseurl=http://mirrors.tummy.com/pub/fedora.redhat.com/fedora/linux/releases/$releasever/Everything/$basearch/os/
#repo --name=updates  --baseurl=http://mirrors.tummy.com/pub/fedora.redhat.com/fedora/linux/updates/$releasever/$basearch/

#repo --name=releases  --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?arch=$basearch&repo=fedora-$releasever
#repo --name=updates   --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?arch=$basearch&repo=updates-released-f$releasever

## Fedora 9
#repo --name=releases         --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?arch=i386&repo=fedora-9
#repo --name=updates          --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?arch=i386&repo=updates-released-f9
#repo --name=updates-newkey   --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f9.newkey&arch=i386

# Fedora 10
repo --name=releases         --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?arch=i386&repo=fedora-10
repo --name=updates          --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?arch=i386&repo=updates-released-f10
#repo --name=updates-newkey   --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f10.newkey&arch=i386

#repo --name=atrpms   --baseurl=http://dl.atrpms.net/f$releasever-$basearch/atrpms/stable
#repo --name=atrpms   --baseurl=http://dl.atrpms.net/f$releasever-$basearch/atrpms/stable

# If this was updated quickly enough... then we would use it...  for madwifi
#repo --name=livna-testing    --baseurl=http://rpm.livna.org/fedora/testing/9/i386/


# This repo file location is created as a link in the build-eeedora script
repo --name=eee-specific --baseurl=file:///mnt/eee-specific
	
# %packages
# @ base
# @ base-x
# @ editors

# This is how to get a hyper-slim install
%packages --nobase
@ Core
kernel

bash
sudo

anaconda
anaconda-runtime
# This is needed by anaconda / liveinst
cracklib-python

syslinux
isomd5sum

# New for fixing up anaconda
patch

yum
yum-fastestmirror
# yum-skip-broken # Not needed any more in F9

openssh-clients
openssh-server
openssh-askpass

pam
# Prompt for root password if needed
usermode-gtk

# acpi for the hotkeys (asus_acpi included in the eee_tarball)
acpid

# No need on the Eee
# @ hardware-support 

# @ admin-tools
# @ printing
# @ text-internet
# @ graphical-internet

memtest86+

## Enable Wifi AP searching
## wifi-radar
# Now we have wicd (below)
# And disable NetworkManager, since it messes us up
-NetworkManager

# Expected to be on the machine :
firefox
scite
curl

# Very handy
joe 

# These are all selectable via options in /root/eee-setup/addons/install
#openoffice.org-impress
#openoffice.org-writer
#openoffice.org-calc
#samba-client
#Zim



# Take these out for the Eee - We know we don't need them
#-*firmware  # if @hardware-support is included above

# include on laptops - monitors power load of each application
#powertop

# X-Windows
@ base-x
firstboot
liberation-fonts
-xorg-x11-apps
-xorg-x11-twm
-xorg-x11-utils

%include eeedora.ks.include-xorg-tidy

# Kill unnecessary fonts
-lohit-fonts-*
-paktype-fonts
-kacst-fonts
-jomolhari-fonts
-dejavu-lgc-fonts
-baekmuk-ttf-fonts-*
-sazanami-fonts-gothic
-cjkunifonts*

# Select a login/password X session manager
-gdm
# This is the lightest-weight one, but I'm looking for /no/ login screen
#xorg-x11-xdm
# But if there's none installed, then the 'setup-nologin' script should be tuned to autologin the single user on this system

# The graphical boot is a bit of a timewaster...
-rhgb

-glx-utils
-authconfig-gtk
-policycoreutils-gui
-smolt-firstboot

system-config-date
system-config-display
system-config-network
system-config-printer

# This is required for /usr/sbin/lokkit (selinux) ??
system-config-firewall-tui

#-system-config-firewall
-system-config-users
#-system-config-soundcard
-system-config-services  

# Audio (new style = pulseaudio) - must fix up /dev/snd devices on every boot...
# chmod -R a+rwx /dev/snd (into /etc/rc.local)
# also start on startup (as user) : pulseaudio -D (into ~/.bash_profile - and remove ~/.xinit)
pulseaudio

# This is a decent volume control
alsamixergui
# This is for CLI volume control (and for acpi scripting...)
alsa-utils

# Maybe want this
#pavucontrol

# Look important, but not needed, somehow
#padevchooser
#paman
#paprefs

# This seems to focus on networking...
#paprefs

# This is for the luvcview program
### Renable if we get this program back...
#SDL

# Not necessary once xcfe is reliable - we have 'Terminal'
-xterm

###############################################
#  Include the Desktop system you want here   #
###############################################
# %include eeedora.xfce.ks.include
%include eeedora.lxde.ks.include

#xarchiver

# since we don't have a media player yet
#audacious
#vlc

# we don't have an ftp client (use the one in firefox instead)
# gftp
# ncftp

# we don't include evolution, so let's take thunderbird
# thunderbird

# we have no picture viewer
#eog pulls in gnome-desktop
#ristretto is unknown

# no document viewer ether
#evince

# IF we have enough space
#dia
#inkscape
#planner

# This is to pave the way for truecrypt-{5,6} stuff, or encfs (now, I think, my preference)
fuse
fuse-libs

# we _need_ xdg-user-dirs
xdg-user-dirs

# do not want
-gimp-help
-scim-bridge-gtk
-dvd+rw-tools
-pidgin
-ekiga

-xsane
-xsane-gimp
-sane-backends

-specspo

-samba-common
-samba-client

-a2ps
-redhat-lsb
-sox
-hplip
-hpijs
-coolkey
-ccid
-pinfo
-vorbis-tools
-wget
-yum-updatesd
-zd1211-firmware
-aspell*
-setroubleshoot
-irda*
-radeontool

# Bluetooth
-bluez*
-gnome-bluetooth-libs

# Speech synthesis
-festival*
-gnome-speech

# make sure no debuginfo doesn't end up on the live image
-*debuginfo

# Needs inclusion for EeeDora9 (not 8)
# dhclient = pulled in by wicd now

# Now all the Eee specific stuff - from the eee-specific repo
eee_tarball
eee_splash

# And now our new stuff

eee-acpi
eee-user-defaults
eee-nologin
scitepm
wicd

# wifi-radar # No need now that wicd works in Fedora 10

# No need in Fedora 10 !!  Phew
# eee-madwifi  
# madwifi

# Include for now - may get replaced by pure encfs
#truecrypt



%post
ShowProgress() {
# echo $"$1" >> /etc/eeedora.progress
# Also show this on the console when building the image (host machine)
 echo $"eeedora-ks   :"`date +%F_%H-%M`" : $1" >> /etc/eeedora.progress
 echo $"eeedora-ks   :"`date +%F_%H-%M`" : $1"
}
ShowProgress "Start of EeeDora Kickstart script"

# This is on the machine that's doing the ISO image building...
# However, the eee_setup rpm has been installed, so there's 
# stuff worth doing/manipulating in the chroot environment 
# even before we get over to the target machine.

# open up the tarball
tar -xzf /root/eee-setup.tar.gz -C /root/
# Ahh - let's find out where it un-wrapped into...
setup_temp=`ls -d /root/eee-setup_* | sort | tail -1`
setup=/root/eee-setup
# Now create a link...
rm -f ${setup}
ln -s ${setup_temp} ${setup}
ShowProgress "Unwrapped into ${setup_temp} to ${setup}"
# Now we're in the 'regular' situation, with un-versioned file locations

# ShowProgress "Blacklist the ath5k kernel module"
# ${setup}/ath/blacklist-ath5k ${setup}

ShowProgress "Turn off SELINUX on the Eee"
${setup}/misc/selinux-off ${setup}

ShowProgress "Install the ath kernel module"
# ${setup}/ath/install-ath ${setup}
/sbin/modprobe ath_pci
/sbin/modprobe wlan_scan_sta

ShowProgress "Adjust wicd startup script to make log directory on tmpfs"
sed -i -e 's|daemon|mkdir -p /var/log/wicd; &|' /etc/init.d/wicd

# This is on-demand for the moment (not in tray)
# It wouldn't work in rc.local anyway, since the GUI needs X11 *up*
# ShowProgress "Start wicd startup"
# echo "" >> /etc/rc.local 
# echo "# Start wicd on startup" >> /etc/rc.local 
# echo "wicd-client &" >> /etc/rc.local 

echo "" >> /etc/rc.local 
echo "# Set authmode on ath0 (seems to help wicd)" >> /etc/rc.local 
echo "/sbin/iwpriv ath0 authmode 1" >> /etc/rc.local 

# ShowProgress "Fix up wifi-radar config"
# mkdir -p /etc/wifi-radar/
# cp ${setup}/ath/wifi-radar-ath /etc/wifi-radar/wifi-radar.conf

# This is now in the kernel - so ignore...
# ShowProgress "Install the atl2 kernel module"
# ${setup}/atl2/install-atl2 ${setup}

# ShowProgress "Install the asus_acpi_eee kernel module"
# ${setup}/acpi/install-acpi ${setup}
# ${setup}/acpi/blacklist-asus_acpi ${setup}

# ShowProgress "Force asus_acpi to be loaded"
# aa=/etc/sysconfig/modules/asus_acpi_eee.modules
# echo "" >> ${aa} 
# echo "# Force asus_acpi_eee to load" >> ${aa} 
# echo "/sbin/modprobe asus_acpi_eee" >> ${aa}
# chmod 755 ${aa}

# Old version : Not necessary now
#echo "" >> /etc/rc.local 
#echo "# Force asus_acpi to load" >> /etc/rc.local 
#echo "/sbin/modprobe asus_acpi" >> /etc/rc.local 
#echo "install battery /sbin/modprobe asus_acpi && /sbin/modprobe --ignore-install battery" >> /etc/rc.local 
#echo "/etc/init.d/acpid restart" >> /etc/rc.local 

# ShowProgress "Put the acpi handlers in"
# cp ${setup}/acpi/events/*.conf /etc/acpi/events/
# cp ${setup}/acpi/actions/eee* /etc/acpi/actions/ 

# # This may be in the kernel :: Check!
# ShowProgress "Install the uvc webcam kernel module"
# ${setup}/uvc/install-uvc ${setup}

ShowProgress "Start camera on startup"
echo "" >> /etc/rc.local 
echo "# Start Camera on startup" >> /etc/rc.local 
echo "echo 1 > /proc/acpi/asus/camera" >> /etc/rc.local 

# ShowProgress "Install the truecrypt kernel module - and main function"
# ShowProgress "Install the truecrypt main function (now uses fuse)"
# ${setup}/truecrypt/install-truecrypt ${setup}

ShowProgress "Fixing snd module removal to enable clean power-down"
cp ${setup}/misc/fix-powerdown /sbin/halt.local
chmod 755 /sbin/halt.local

fb=eeedora-firstboot
init=/etc/rc.d/init.d

ShowProgress "Creating ${init}/${fb} (needed for live version)"
cp ${setup}/services/${fb} ${init}/${fb}
chmod 755 ${init}/${fb}
/sbin/restorecon ${init}/${fb}

ShowProgress "Set ${init}/${fb} as the task after this script is done"
/sbin/chkconfig --add ${fb}

# We can do this, since it only affects the RW live image 
# (not the underlying RO source for the later live install)
ShowProgress "Save a little bit of space in live memory at least..."
rm -f /boot/initrd*

# workaround avahi segfault (#279301)
touch /etc/resolv.conf
/sbin/restorecon /etc/resolv.conf

ShowProgress "End of Live Kickstart script"
%end

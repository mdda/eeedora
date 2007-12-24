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
#network --device eth1 --bootproto dhcp --hostname=Eee

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

# No Partition information required to build the ISO 

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

#repo --name=releases --baseurl=http://download.fedora.redhat.com/pub/fedora/linux/releases/8/Everything/i386/os
#repo --name=updates  --baseurl=http://download.fedora.redhat.com/pub/fedora/linux/updates/8/i386

#repo --name=releases --baseurl=http://fedora.mirror.facebook.com/linux/releases/$releasever/Everything/$basearch/os/
#repo --name=updates  --baseurl=http://fedora.mirror.facebook.com/linux/updates/$releasever/$basearch/

#repo --name=releases --baseurl=http://mirrors.tummy.com/pub/fedora.redhat.com/fedora/linux/releases/$releasever/Everything/$basearch/os/
#repo --name=updates  --baseurl=http://mirrors.tummy.com/pub/fedora.redhat.com/fedora/linux/updates/$releasever/$basearch/

repo --name=releases  --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?arch=i386&repo=fedora-8
repo --name=updates   --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?arch=i386&repo=updates-released-f8

#repo --name=releases  --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?arch=$basearch&repo=fedora-$releasever
#repo --name=updates   --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?arch=$basearch&repo=updates-released-f$releasever

#repo --name=atrpms   --baseurl=http://dl.atrpms.net/f$releasever-$basearch/atrpms/stable
#repo --name=atrpms   --baseurl=http://dl.atrpms.net/f$releasever-$basearch/atrpms/stable

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
syslinux
isomd5sum

# New for fixing up anaconda
patch

yum
yum-fastestmirror
yum-skip-broken

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

# irssi
# drivel
memtest86+
# a2ps
#alpine
#pidgin
#xchat
#blobwars
#gimp
#ImageMagick
#NetworkManager-vpnc
#privoxy
#tor
#rhythmbox
#seahorse
#sound-juicer
#totem
#vim-X11

# Enable Wifi AP searching
wifi-radar
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
-system-config-firewall
-system-config-users
system-config-soundcard
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

# Not necessary once xcfe is reliable - we have 'Terminal'
-xterm

# xfce packages
@ xfce-desktop
-mousepad
xfwm4-themes
gtk-xfce-engine

# This is needed only for XFCE programs (like mousepad which we don't want) to print
-xfprint
# But ...  xfce4-panel requires mousepad - which in turn requires xfprint - which pulls in the whole of tetex

# New stuff to compensate for xfprint's strange login-disabling behaviour :
#libpciaccess
#libgomp
#dialog
#libgsf
#tmpwatch
#libcroco
gdbm
# End of xfprint antidote

# Don't need this - pulseaudio has the goodies
-xfce4-mixer

# Here are some of the pretty xfce4 plugins

# Good for the Eee
xfce4-battery-plugin
-xfce4-clipman-plugin
# Use datetime instead - but maybe this is built in, since I can't remove it
# -xfce4-clock-plugin
xfce4-cpugraph-plugin
# This is better than the simple clock
xfce4-datetime-plugin
-xfce4-dict-plugin
# Monitors disk performance
-xfce4-diskperf-plugin
-xfce4-eyes-plugin
# Monitors free space
-xfce4-fsguard-plugin
# This monitors a general script
-xfce4-genmon-plugin
-xfce4-mailwatch-plugin
-xfce4-minicmd-plugin
xfce4-mount-plugin
xfce4-netload-plugin
-xfce4-notes-plugin
xfce4-places-plugin
-xfce4-quicklauncher-plugin
# This may just be useful for now
xfce4-screenshooter-plugin
-xfce4-sensors-plugin
# This may be mandatory, though
-xfce4-session
-xfce4-smartbookmark-plugin
# I like this 
xfce4-systemload-plugin
# Nice-to-have only
-xfce4-timer-plugin
# No need for this command line plugin
-xfce4-verve-plugin
# This allows media to be ejected easily
xfce4-volstatus-icon
# For wireless devices
xfce4-wavelan-plugin
# Nice-to-have, but not essential really
xfce4-weather-plugin
# We've got Firefox already
-xfce4-websearch-plugin
# No need to switch keyboard layouts constantly
-xfce4-xkb-plugin
# Needed to use gnome panel applets - but why do I care?
-xfce4-xfapplet-plugin

# some more stuff for xfce
#orage

thunar-archive-plugin
thunar-media-tags-plugin
thunar-volman

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


# more things we don't need in Xfce
-evolution
-evolution-webcal
-evolution-data-server

-gnome-panel
-gnome-desktop
-gnome-user-docs
-gnome-backgrounds
-gnome-games
-gnome-netstatus
-gnome-python2-applet
-gnome-applets

# make sure no debuginfo doesn't end up on the live image
-*debuginfo

# Now all the Eee specific stuff - from the eee-specific repo
eee_tarball
eee_splash

%post
ShowProgress() {
# echo $"$1" >> /etc/eeedora.progress
 echo $"live-kickstart :"`date +%F_%H-%M`" : $1" >> /etc/eeedora.progress
}
ShowProgress "Start of Live Kickstart script"

# This is on the machine that's doing the ISO image building...
# However, the eee_setup rpm has been installed, so there's 
# stuff worth doing/manipulating in the chroot environment 
# even before we get over to the target machine.

# open up the tarball
tar -xzf /root/eee-setup.tar.gz -C /root/
setup=/root/eee-setup

ShowProgress "Blacklist the ath5k kernel module"
${setup}/ath/blacklist-ath5k ${setup}

ShowProgress "Install the ath kernel module"
${setup}/ath/install-ath ${setup}

ShowProgress "Fix up wifi-radar config"
mkdir -p /etc/wifi-radar/
cp ${setup}/ath/wifi-radar-ath /etc/wifi-radar/wifi-radar.conf

ShowProgress "Install the atl2 kernel module"
${setup}/atl2/install-atl2 ${setup}

ShowProgress "Install the asus_acpi kernel module"
${setup}/acpi/install-acpi ${setup}

#ShowProgress "Force asus_acpi to be loaded"
#echo "# Force asus_acpi to load" >> /etc/rc.local 
#echo "/sbin/modprobe asus_acpi" >> /etc/rc.local 
#echo "/etc/init.d/acpi restart" >> /etc/rc.local 

ShowProgress "Put the acpi handlers in"
cp ${setup}/acpi/events/*.conf /etc/acpi/events/
cp ${setup}/acpi/actions/eee* /etc/acpi/actions/ 

ShowProgress "Install the uvc webcam kernel module"
${setup}/uvc/install-uvc ${setup}

ShowProgress "Start camera on startup"
echo "# Start Camera on startup" >> /etc/rc.local 
echo "echo 1 > /proc/acpi/asus/camera" >> /etc/rc.local 

ShowProgress "Install the truecrypt kernel module - and main function"
${setup}/truecrypt/install-truecrypt ${setup}

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

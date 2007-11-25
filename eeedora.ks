lang en_US.UTF-8
keyboard us
timezone US/Eastern
auth --useshadow --enablemd5

#selinux --enforcing
selinux --disabled

network --device eth0 --bootproto dhcp

#firewall --disabled
firewall --enabled --trust=eth0 --ssh

#xconfig --card "VMWare" --videoram 16384 --hsync 31.5-37.9 --vsync 50-70 --resolution 800x600 --depth 16
#xconfig --startxonboot --defaultdesktop=XFCE
# This is an idea... since we know the correct configuration...
skipx 

#Switch this over - not having sshd is more secure (until a non-public password is set)
#services --enabled=NetworkManager --disabled=network,sshd
services --enabled=NetworkManager,network,sshd 

# This isn't for the live version - just for the install - Needs Fixing.
#clearpart --drives sda
#part / --fstype ext2 --size 1 --ondisk=sda --asprimary --grow
#part swap --recommended

# A default public root password - not the best idea.
rootpw eee

#If you installed *ubuntu the normal way with one big 4gb partition on the SSD, there only needs to be one line in your /etc/fstab file, the one mounting /
#  UUID=[your-uuid-here]   /    ext2    defaults,errors=remount-ro,noatime  0     1
#Mine has the added "noatime" option to reduce harddrive writes (nice but not necessary), and also it's "ext2" though yours might be "ext3" which is okay because that's the default.

# xrandr --output VGA --right-of LVDS --mode 1024x768
# xrandr --auto

#At least this is working for me.  (Use xorg.conf in eee_files/)
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

#repo --name=official --baseurl=http://download.fedora.redhat.com/pub/fedora/linux/releases/8/Everything/i386/os
#repo --name=official-updates --baseurl=http://download.fedora.redhat.com/pub/fedora/linux/updates/8/i386

#repo --name=facebook --baseurl=http://fedora.mirror.facebook.com/linux/releases/8/Everything/i386/os
#repo --name=facebook-updates --baseurl=http://fedora.mirror.facebook.com/linux/updates/8/i386

#repo --name=tummy-releases --baseurl=http://mirrors.tummy.com/pub/fedora.redhat.com/fedora/linux/releases/8/Everything/i386/os
#repo --name=tummy-updates --baseurl=http://mirrors.tummy.com/pub/fedora.redhat.com/fedora/linux/updates/8/i386

repo --name=releases --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-8&arch=i386
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f8&arch=i386

#repo --name=atrpms --baseurl=http://dl.atrpms.net/f$releasever-$basearch/atrpms/stable

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
anaconda
anaconda-runtime
syslinux
isomd5sum

yum
yum-fastestmirror
yum-skip-broken

openssh-clients
openssh-server
openssh-askpass

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

# mdda desired
firefox
#openoffice.org-impress
#openoffice.org-writer
#openoffice.org-calc

# mdda useful list
joe 
scite
Zim
curl

# mdda dev tools
cvs
samba-client

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

# %include eeedora.ks.include-xorg-tidy

# Kill unnecessary fonts
-lohit-fonts-*
#-lohit-fonts-bengali
#-lohit-fonts-gujarati
#-lohit-fonts-hindi
#-lohit-fonts-kannada
#-lohit-fonts-oriya
#-lohit-fonts-punjabi
#-lohit-fonts-tamil
#-lohit-fonts-telugu
-kacst-fonts
-jomolhari-fonts
-dejavu-lgc-fonts
-baekmuk-ttf-fonts-*
-sazanami-fonts-gothic
-cjkunifonts*

# Use xdm as the login/password X session manager
-gdm
-rhgb
# This is the lightest-weight one, but I'm looking for /no/ login screen
-xorg-x11-xdm

-glx-utils
-authconfig-gtk
-paktype-fonts
-pirut
-policycoreutils-gui
-smolt-firstboot

system-config-date
system-config-display
system-config-network
system-config-printer
-system-config-users
system-config-soundcard
-system-config-services  

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

# Here are some of the pretty xfce4 plugins

# Good for the Eee
xfce4-battery-plugin
-xfce4-clipman-plugin
# Use datetime instead
-xfce4-clock-plugin
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
# This may be manditory, though
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
# Needed to use gnome panel applets
xfce4-xfapplet-plugin

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
#-samba-client
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
-bluez*
-festival*
-gnome-bluetooth-libs
-gnome-speech
-irda*

# more things we don't need in Xfce
-evolution
-evolution-webcal
-evolution-data-server
-gnome-panel
-gnome-desktop
-gnome-user-docs
-gnome-backgrounds
-gnome-games

# make sure no debuginfo doesn't end up on the live image
-*debuginfo

# Now all the Eee specific stuff - from the eee-specific repo
eee_tarball

%post
ShowProgress() {
 echo $"$1" >> /etc/eeedora.progress
}

# This is on the machine that's doing the ISO image building...
# However, the eee_tarball rpm has been installed, so there's 
# stuff worth doing/manipulating in the chroot environment 
# even before we get over to the target machine.

# open up the tarball
tar -xzf /root/eee-setup.tar.gz -C /root/
tarball=/root/eee_tarball

ShowProgress "Install the atl2 kernel module"
${tarball}/atl2/install-atl2

ShowProgress "Copy over known-good xorg.conf"
cp ${tarball}/xorg/xorg.conf /etc/X11/

ShowProgress "Create /etc/sysconfig/desktop (needed for installation)"
cp ${tarball}/xfce/sysconfig-desktop /etc/sysconfig/desktop 

fedoralive=/etc/rc.d/init.d/fedora-live

ShowProgress "Creating ${fedoralive} (needed for live version)"
cp ${tarball}/services/fedora-live ${fedoralive} 
chmod 755 ${fedoralive}
/sbin/restorecon ${fedoralive}

ShowProgress "Set ${fedoralive} as the task after this script is done"
/sbin/chkconfig --add fedora-live

#ShowProgress "Save a little bit of space at least..."
#rm -f /boot/initrd*

# workaround avahi segfault (#279301)
touch /etc/resolv.conf
/sbin/restorecon /etc/resolv.conf

ShowProgress "End of Kickstart script"
%end

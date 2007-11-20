lang en_US.UTF-8
keyboard us
timezone US/Eastern
auth --useshadow --enablemd5
network --device eth0 --bootproto dhcp

# This isn't for the live version - just for the install
#clearpart --drives sda
#part / --fstype ext2 --size 1 --ondisk=sda --asprimary --grow
#part swap --recommended


#selinux --enforcing
#selinux --disabled

#firewall --disabled
firewall --enabled --trust=eth0 --ssh

#services --enabled=NetworkManager --disabled=network,sshd
services --enabled=NetworkManager,network
# services --enabled=NetworkManager,network,sshd  # Later

rootpw eee

#xconfig --card "VMWare" --videoram 16384 --hsync 31.5-37.9 --vsync 50-70 --resolution 800x600 --depth 16
xconfig --startxonboot

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

#repo --name=everything --baseurl=http://download.fedora.redhat.com/pub/fedora/linux/releases/8/Everything/i386/os
repo --name=facebook --baseurl=http://fedora.mirror.facebook.com/linux/releases/8/Everything/i386/os
	
#Reported un-matched : 
#iprutils
#yaboot
#ppc64-utils
#s390utils
#elilo
# ristretto

# %packages
# @ core
# @ base
# @ base-x
# @ editors

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
#gnome-games
#blobwars
#gimp
#ImageMagick
#NetworkManager-vpnc
#openoffice.org-impress
#openoffice.org-writer
#openoffice.org-calc
#privoxy
#tor
#rhythmbox
#seahorse
#sound-juicer
#totem
#vim-X11

# mdda desired
firefox

# mdda useful list
joe
curl
scite
Zim
samba-client

# mdda dev tools
cvs

# Take these out for the Eee - We know we don't need them
#-*firmware  # if @hardware-support is included above

# include on laptops - monitors power load of each application
#powertop

# X-Windows
@ base-x
firstboot
liberation-fonts

# Kill unnecessary fonts
-lohit*
-lohit-fonts-bengali
-lohit-fonts-gujarati
-lohit-fonts-hindi
-lohit-fonts-kannada
-lohit-fonts-oriya
-lohit-fonts-punjabi
-lohit-fonts-tamil
-lohit-fonts-telugu
-kacst-fonts
-jomolhari-fonts
-dejavu-lgc-fonts
-cjkunifonts-uming
-baekmuk-ttf-fonts-gulim

-gdm
-glx-utils
-authconfig-gtk
-paktype-fonts
pirut
openssh-askpass
-policycoreutils-gui
-rhgb
-smolt-firstboot
system-config-date
system-config-display
system-config-network
system-config-printer
-system-config-users
-system-config-soundcard
system-config-services  
-xorg-x11-apps
-xorg-x11-twm
-xorg-x11-utils
xterm

# xfce packages
@ xfce-desktop
-mousepad
-xfce4-mailwatch-plugin

gtk-xfce-engine
xfce4-battery-plugin
#xfce4-clipman-plugin
xfce4-cpugraph-plugin
xfce4-datetime-plugin
#xfce4-dict-plugin
xfce4-diskperf-plugin
#xfce4-eyes-plugin
xfce4-fsguard-plugin
xfce4-genmon-plugin
#xfce4-minicmd-plugin
xfce4-mount-plugin
xfce4-netload-plugin
#xfce4-notes-plugin
xfce4-places-plugin
#xfce4-quicklauncher-plugin
xfce4-screenshooter-plugin
xfce4-sensors-plugin
#xfce4-smartbookmark-plugin
xfce4-systemload-plugin
#xfce4-timer-plugin
xfce4-verve-plugin
xfce4-wavelan-plugin
xfce4-weather-plugin
#xfce4-websearch-plugin
#xfce4-xfapplet-plugin
xfce4-xkb-plugin
xfwm4-themes

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
#gftp
ncftp

# we don't include evolution, so let's take thunderbird
#thunderbird

# we have no picture viewer
eog
#ristretto is unknown

# no document viewer ether
evince

# IF we have enough space
#dia
#inkscape
#planner
# we _need_ xdg-user-dirs
xdg-user-dirs

# do not want
-gimp-help
-gnome-user-docs
-gnome-backgrounds
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
-baekmuk-ttf-fonts*
#-bluez*
-cjkunifonts*
-festival*
-gnome-bluetooth-libs
-gnome-speech
-irda*
-sazanami-fonts-gothic

# more things we don't need in Xfce
-evolution
-evolution-webcal
#-gnome-panel
-gnome-desktop
-evolution-data-server

# make sure debuginfo doesn't end up on the live image
-*debuginfo
-debuginfo

%post
ShowProgress() {
 echo $"$1" >> /etc/eeedora.progress
}

ShowProgress("Creating /etc/sysconfig/desktop (needed for installation)")
cat > /etc/sysconfig/desktop <<EOF
DESKTOP="XFCE"
EOF

#ShowProgress("Save a little bit of space at least...")
#rm -f /boot/initrd*

# workaround avahi segfault (#279301)
touch /etc/resolv.conf
/sbin/restorecon /etc/resolv.conf

liveuser="eeedora"

ShowProgress("Add '${liveuser}' user with no passwd")
useradd -c "Eeedora Live" ${liveuser}
passwd -d ${liveuser} > /dev/null

ShowProgress("Replace bluecurve with xfce to get the default Xfce look for '${liveuser}'")
# FIXME: should be done in the xfce-mcs-plugins package
mkdir -p /home/${liveuser}/.config/xfce4/mcs_settings
cat > /home/${liveuser}/.config/xfce4/mcs_settings/gtk.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mcs-option SYSTEM "mcs-option.dtd">

<mcs-option>
	<option name="Gtk/FontName" type="string" value="Sans 9"/>
	<option name="Gtk/KeyThemeName" type="string" value="Default"/>
	<option name="Gtk/ToolbarStyle" type="string" value="icons"/>
	<option name="Net/CursorBlink" type="int" value="1"/>
	<option name="Net/CursorBlinkTime" type="int" value="500"/>
	<option name="Net/DndDragThreshold" type="int" value="8"/>
	<option name="Net/DoubleClickTime" type="int" value="300"/>
	<option name="Net/IconThemeName" type="string" value="Rodent"/>
	<option name="Net/ThemeName" type="string" value="Xfce"/>
	<option name="Xft/Antialias" type="int" value="1"/>
	<option name="Xft/HintStyle" type="string" value="hintfull"/>
	<option name="Xft/Hinting" type="int" value="1"/>
	<option name="Xft/RGBA" type="string" value="none"/>
</mcs-option>
EOF

ShowProgress("Replace default.png with default.jpg to get the background image")
# FIXME: this is a bug in the xfdesktop package, already (partly) fixed in cvs
cat > /home/${liveuser}/.config/xfce4/mcs_settings/desktop.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mcs-option SYSTEM "mcs-option.dtd">

<mcs-option>
	<option name="brightness_0_0" type="int" value="0"/>
	<option name="color1_0_0" type="color" value="           15104,           23296,           35072,           65535"/>
	<option name="color2_0_0" type="color" value="           15872,           26624,           40448,           65535"/>
	<option name="colorstyle_0_0" type="int" value="0"/>
	<option name="desktopiconstyle" type="int" value="2"/>
	<option name="icons_use_system_font_size" type="int" value="1"/>
	<option name="imagepath_0_0" type="string" value="/usr/share/backgrounds/images/default.jpg"/>
	<option name="imagestyle_0_0" type="int" value="3"/>
	<option name="showdm" type="int" value="1"/>
	<option name="showimage_0_0" type="int" value="1"/>
	<option name="showwl" type="int" value="1"/>
</mcs-option>
EOF

# set up timed auto-login for after 20 seconds
sed -i -e 's/\[daemon\]/[daemon]\nTimedLoginEnable=true\nTimedLogin=${liveuser}\nTimedLoginDelay=20/' /etc/gdm/custom.conf
if [ -e /usr/share/icons/hicolor/96x96/apps/fedora-logo-icon.png ] ; then
    cp /usr/share/icons/hicolor/96x96/apps/fedora-logo-icon.png /home/${liveuser}/.face
    chown ${liveuser}:${liveuser} /home/${liveuser}/.face
    # TODO: would be nice to get e-d-s to pick this one up too... but how?
fi

ShowProgress("Make '${liveuser}' user use Xfce")
echo "startxfce4" > /home/${liveuser}/.xsession
chmod a+x /home/${liveuser}/.xsession
chown ${liveuser}:${liveuser} /home/${liveuser}/.xsession

ShowProgress("Set User permissions - Can be removed once the ui hacks have gone")
chown -R ${liveuser}:${liveuser} /home/${liveuser}/
chmod 700 /home/${liveuser}/

ShowProgress("/sbin/restorecon for ${liveuser} home directory")
/sbin/restorecon -R /home/${liveuser}/
chmod 700 /home/${liveuser}/

ShowProgress("Creating /etc/rc.d/init.d/fedora-live  (needed for live version)")
# FIXME: it'd be better to get this installed from a package
# All the below (up until chmod 700 /home/fedora) is going into this script
cat > /etc/rc.d/init.d/fedora-live << EOF
#!/bin/bash
#
# live: Init script for live image
#
# chkconfig: 345 00 99
# description: Init script for live image.

ShowProgress() {
 echo $"init.d.fedora-live : $1" >> /etc/eeedora.progress
}

ShowProgress("Loading /etc/init.d/functions")
. /etc/init.d/functions

ShowProgress("Testing cmdline - go no further if not a live image")
if ! strstr "\`cat /proc/cmdline\`" liveimg || [ "\$1" != "start" ] || [ -e /.liveimg-configured ] ; then
 ShowProgress("Apparently this was not a live image")
 exit 0
fi

exists() {
 which \$1 >/dev/null 2>&1 || return
 \$*
}

ShowProgress("Touching liveimg-configured")
touch /.liveimg-configured

ShowProgress("Mount live image")
if [ -b /dev/live ]; then
 mkdir -p /mnt/live
 mount -o ro /dev/live /mnt/live
fi

if ! [ 1 ]; then # DISABLE CREATION OF SWAP PARTITION - SAVE FLASH RAM OVERWRITES
 ShowProgress("Enable swaps unless requested otherwise")
 # This is the list of current swap partitions
 swaps=\`blkid -t TYPE=swap -o device\`
 if ! strstr "\`cat /proc/cmdline\`" noswap -a [ -n "\$swaps" ] ; then
  # Go through the list until we get a hit...
  for s in \$swaps ; do
    action "Enabling swap partition \$s" swapon \$s
  done
 fi
else
 ShowProgress("Eee has swap disabled")
fi

ShowProgress("Configure X, allowing user to override xdriver")
for o in \`cat /proc/cmdline\` ; do
    case \$o in
    xdriver=*)
        xdriver="--set-driver=\${o#xdriver=}"
        ;;
    esac
done

ShowProgress("system-config-display ($xdriver)")
exists system-config-display --noui --reconfig --set-depth=24 \$xdriver

ShowProgress("Unmute sound card")
exists alsaunmute 0 2> /dev/null

ShowProgress("Turn off firstboot for livecd boots")
echo "RUN_FIRSTBOOT=NO" > /etc/sysconfig/firstboot

# echo "don't start yum-updatesd for livecd boots")
#chkconfig --level 345 yum-updatesd off

ShowProgress("Don't start cron/at as they tend to be painful in a Live context")
# don't start cron/at as they tend to spawn things which are
# disk intensive that are painful on a live image
chkconfig --level 345 crond off
chkconfig --level 345 atd off
chkconfig --level 345 anacron off
chkconfig --level 345 readahead_early off
chkconfig --level 345 readahead_later off

ShowProgress("Stopgap fix for RH #217966; should be fixed in HAL instead")
touch /media/.hal-mtab

# disable screensaver locking
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults -s -t bool /apps/gnome-screensaver/lock_enabled false >/dev/null
EOF
# The above all went into the /etc/init.d/fedora-live script

ShowProgress("Fixing init of fedora-live")
chmod 755 /etc/rc.d/init.d/fedora-live
/sbin/restorecon /etc/rc.d/init.d/fedora-live

ShowProgress("Last : Actually run init of fedora-live")
/sbin/chkconfig --add fedora-live

%end

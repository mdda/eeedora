#!/bin/bash

export DISPLAY=:0

case "$3" in
	#Fn+F2
	00000010)
		# Wlan On
		/etc/acpi/actions/wlan.sh poweron
		note='wifi-on'
		;;

 00000011)
		# Wlan Off
		/etc/acpi/actions/wlan.sh poweroff
		note='wifi-off'
		;;

 #Fn+F6
	00000012)
		# Webcam switch
		/etc/acpi/actions/camera.sh
		# TaskManager
		# /usr/bin/gnome-system-monitor
		note='webcam-switch'
		;;

	#Fn+F7
	00000013)
		# Volume mute
		/usr/bin/amixer set -D hw:0 Master toggle
		o=`/usr/bin/amixer get Master | egrep ' Playback \[on\]'`
		if [ -z "$o" ]; then
			note='vol-unmute'
		else
			note='vol-mute'
		fi
		;;

	#Fn+F8
	00000014)
		# Volume down
		/usr/bin/amixer set -D hw:0 Master 10%- unmute
		note='vol-down'
		;;

	#Fn+F9
	00000015)
		# Volume up
		/usr/bin/amixer set -D hw:0 Master 10%+ unmute
		note='vol-up'
		;;

	#Fn+F5
	00000030)
		# External Monitor on Large, LCD off
		/usr/bin/xrandr --output VGA  --mode 1024x768 \
																		--output LVDS --off
		if [[ "$?" != "0" ]]; then
			/usr/bin/xrandr --output VGA  --preferred \
																			--output LVDS --off
		fi
		note='vga-on'
		;;

	00000031)
		# External Monitor Same as LCD
		/usr/bin/xrandr --output LVDS --mode 800x480 \
																		--output VGA  --mode 800x600
		note='vga-on'
		;;
    
	00000032)
		# Back to internal LCD
		/usr/bin/xrandr --output VGA  --off       \
																		--output LVDS --preferred
		note='vga-off'
		;;

	*)
		logger "ACPI hotkey $3 action is not defined"
		;;
esac

if [ "${acpi}" == "apps" ]; then
 # /etc/acpi/actions/apps
 /home/eeedora/.hotkey-app
 note=''
fi

if [ "empty${note}" != "empty" ]; then 
 # Find the right X window user
	user=`ps axo user,comm | grep xfwm4 | grep --invert-match grep | cut -d ' ' -f 1` 
 su ${user} -c "DISPLAY=:0 /usr/bin/python /etc/acpi/actions/eee.py \"${note}\" \"${full}\""
fi

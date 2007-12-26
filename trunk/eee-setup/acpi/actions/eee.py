#!/usr/bin/env python

import pygtk
pygtk.require('2.0')
import pynotify
import sys
import gtk
import os

if __name__ == '__main__':
	if not pynotify.init("acpi notification"):
		sys.exit(1)
	n = pynotify.Notification("Unknown","'%s'acpi event : %s" % (sys.argv[1], sys.argv[2]))
	to=500
	
	if sys.argv[1] == "wifi-off":
		#uri = "file:///usr/share/icons/gnome/scalable/devices/network-wireless.svg"
		#uri = "file:///usr/share/icons/Mist/scalable/places/network.svg"
		uri = "file:///usr/share/icons/Bluecurve/64x64/actions/connect_no.png"
		n = pynotify.Notification("Wifi", "Your wireless adapter has been <b><span color='red'>disabled</span></b>. This should save power and prevent interferences in planes. Press <i>Fn-F2</i> to reenable it.", uri)
		to=3000
	if sys.argv[1] == "wifi-on":
		#uri = "file:///usr/share/icons/gnome/scalable/devices/network-wireless.svg"
		#uri = "file:///usr/share/icons/HighContrast-SVG/scalable/devices/network-wireless.svg"
		uri = "file:///usr/share/icons/Bluecurve/64x64/actions/connect_established.png"
		n = pynotify.Notification("Wifi", "Your wireless adapter has been <b><span color='red'>enabled</span></b>. Press <i>Fn-F2</i> to disable it.", uri)
		to=3000

	if sys.argv[1] == "resume":
		n = pynotify.Notification("Resume", "Your Eee just resumed from a suspend")
		to=3000
	if sys.argv[1] == "shutdown":
		uri = "file:///usr/share/icons/Bluecurve/64x64/actions/stop.png"
		n = pynotify.Notification("Shutdown", "Eee is shutting down immediately", uri)

	if sys.argv[1] == "vol-mute":
		uri = "file:///usr/share/icons/Bluecurve/64x64/status/audio-volume-muted.png"
		n = pynotify.Notification("Speaker Mute", "", uri)
	if sys.argv[1] == "vol-unmute":
		uri = "file:///usr/share/icons/Bluecurve/64x64/status/audio-volume-muted.png"
		n = pynotify.Notification("Speaker Unmute", "", uri)
	if sys.argv[1] == "vol-down":
		uri = "file:///usr/share/icons/Bluecurve/64x64/status/audio-volume-low.png"
		n = pynotify.Notification("Volume - Decrease", "", uri)
	if sys.argv[1] == "vol-up":
		uri = "file:///usr/share/icons/Bluecurve/64x64/status/audio-volume-high.png"
		n = pynotify.Notification("Volume - Increase", "", uri)

	if sys.argv[1] == "vga-disconnected":
		uri = "file:///usr/share/icons/Bluecurve/32x32/actions/stop.png"
		n = pynotify.Notification("LCD / VGA Switch", "No monitor attached", uri)
		to=1000
	if sys.argv[1] == "vga-on":
		uri = "file:///usr/share/icons/Bluecurve/64x64/stock/stock-fullscreen.png"
		n = pynotify.Notification("LCD / VGA Switch", "Monitor in 1280x1024", uri)
		to=3000
	if sys.argv[1] == "vga-off":
		uri = "file:///usr/share/icons/Bluecurve/32x32/stock/stock-fullscreen.png"
		n = pynotify.Notification("LCD / VGA Switch", "External monitor Off", uri)
		to=3000

	if sys.argv[1] == "apps":
		uri = "file:///usr/share/icons/Bluecurve/32x32/stock/panel-accessories.png"
		n = pynotify.Notification("Apps Key", sys.argv[2], uri)
		to=3000

	n.set_timeout(to)
	if not n.show():
		print "Failed to send notification"
		sys.exit(1)


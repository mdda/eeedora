#!/bin/bash

PWR=$(cat /sys/devices/platform/eeepc/wlan)

UnloadModules() {
	rmmod ath_pci
	rmmod ath_rate_sample
	rmmod wlan_scan_sta
	rmmod wlan_tkip
	rmmod wlan_wep
	rmmod wlan
}

LoadModules() {
	modprobe ath_pci
}

case $1 in
	poweron)
		if [[ "$PWR" = "0" ]]; then
			modprobe pciehp pciehp_force=1
 		echo 1 > /sys/devices/platform/eeepc/wlan
 		rmmod pciehp
		fi
		;;

	poweroff)
		if [[ "$PWR" = "1" ]]; then
			modprobe pciehp pciehp_force=1
			ifconfig ath0 down
			wlanconfig ath0 destroy
			UnloadModules
			echo 0 > /sys/devices/platform/eeepc/wlan
			rmmod pciehp
		fi
		;;
esac

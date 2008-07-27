#!/bin/bash

CAMERA=$(cat /sys/devices/platform/eeepc/camera)

if [[ "$CAMERA" = "0" ]]; then
 echo 1 > /sys/devices/platform/eeepc/camera
else
	echo 0 > /sys/devices/platform/eeepc/camera
fi

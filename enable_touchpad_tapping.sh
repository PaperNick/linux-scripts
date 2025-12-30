#!/bin/bash

# Inspired by ToZ: https://forum.xfce.org/viewtopic.php?pid=73728#p73728

xinput_touchpad_device_id="$(xinput list | grep Touchpad | awk '{print $6}' | grep -o '[0-9]\+')"
xinput_touchpad_props="$(xinput list-props "$xinput_touchpad_device_id")"
xinput_touchpad_main_prop="$(echo "$xinput_touchpad_props" | grep 'Tapping Enabled' | grep -v 'Default')"

xinput_touchpad_main_prop_id="$(echo "$xinput_touchpad_main_prop" | awk '{print $4}' | grep -o '[0-9]\+')"
current_tapping_value="$(echo "$xinput_touchpad_main_prop" | awk '{print $5}')"


debug() {
  echo "Device ID: $xinput_touchpad_device_id; Prop ID: $xinput_touchpad_main_prop_id; Current Tapping Value: $current_tapping_value"
}

enable_tapping() {
  if [ "$current_tapping_value" = "0" ]; then
    xinput set-prop "$xinput_touchpad_device_id" "$xinput_touchpad_main_prop_id" 1
    notify-send -t 3000 -i input-touchpad-symbolic 'Touchpad Tapping On' 'Touchpad tapping is now enabled'
  fi
}

for param in "$@"; do 
  if [ "$param" = "-d" ]; then
    debug
    exit 0
  fi
done


enable_tapping

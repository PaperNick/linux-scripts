#!/bin/bash

# Inspired by ToZ: https://forum.xfce.org/viewtopic.php?pid=73728#p73728

xinput_touchpad_device_id="$(xinput list | grep Touchpad | awk '{print $6}' | grep -o '[0-9]\+')"
xinput_touchpad_props="$(xinput list-props "$xinput_touchpad_device_id")"
xinput_touchpad_main_prop="$(echo "$xinput_touchpad_props" | grep 'Tapping Enabled' | grep -v 'Default')"

xinput_touchpad_main_prop_id="$(echo "$xinput_touchpad_main_prop" | awk '{print $4}' | grep -o '[0-9]\+')"
current_tapping_value="$(echo "$xinput_touchpad_main_prop" | awk '{print $5}')"
toggled_tapping_value=$(( 1 - current_tapping_value ))


debug() {
  echo "Device ID: $xinput_touchpad_device_id; Prop ID: $xinput_touchpad_main_prop_id; Current Tapping Value: $current_tapping_value; Toggled Tapping Value: $toggled_tapping_value"
}

toggle_tapping() {
  xinput set-prop "$xinput_touchpad_device_id" "$xinput_touchpad_main_prop_id" "$toggled_tapping_value"

  if [ "$toggled_tapping_value" = "1" ]; then
    notify-send -t 3000 -i input-touchpad-symbolic 'Touchpad Tapping On' 'Touchpad tapping is now enabled'
  else
    notify-send -t 3000 -i touchpad-disabled-symbolic 'Touchpad Tapping Off' 'Touchpad tapping has been disabled'
  fi
}

for param in "$@"; do 
  if [ "$param" = "-d" ]; then
    debug
  fi
done

toggle_tapping

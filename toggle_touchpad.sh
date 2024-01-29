#!/bin/bash

current_touchpad_value=$(synclient -l | grep TouchpadOff | awk '{print $3}')
toggled_touchpad_value=$((1 - $current_touchpad_value))
synclient TouchpadOff=$toggled_touchpad_value

if [ "$toggled_touchpad_value" = "0" ]; then
    notify-send -t 3000 -i input-touchpad-symbolic 'Touchpad On' 'Touchpad is now enabled'
else
    notify-send -t 3000 -i touchpad-disabled-symbolic 'Touchpad Off' 'Touchpad has been disabled'
fi

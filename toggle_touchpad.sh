#!/bin/bash

current_touchpad_value=$(synclient -l | grep TouchpadOff | awk '{print $3}')
toggled_touchpad_value=$((1 - $current_touchpad_value))
synclient TouchpadOff=$toggled_touchpad_value

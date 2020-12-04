#!/bin/bash

# Schedule in crontab:
# */5 * * * * DISPLAY=:0.0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus /path/to/battery_reminder.sh


MIN_VALUE=40
MAX_VALUE=80

battery_output="$(upower -i /org/freedesktop/UPower/devices/battery_BAT1)"


battery_percentage() {
    # Return the battery percentage as int. Example: 70
    local percentage=$(echo "$battery_output" | grep percentage | awk '{print $2}')
    # Remove % sign
    echo ${percentage%\%}
}

battery_state() {
    # Possible values: charging, discharging
    local state="$(echo "$battery_output" | grep state | awk '{print $2}')"
    echo "$state"
}

send_unplug_charging_message() {
    notify-send -i battery-full-charged "The battery has been charged." "Please unplug the power supply."
}

send_charge_battery_message() {
    notify-send -i battery-low "The battery percentage is low. " "Please plug in the power supply."
}

if [ $(battery_percentage) -ge $MAX_VALUE ] && [ "$(battery_state)" = "charging" ]; then
    send_unplug_charging_message
elif [ $(battery_percentage) -le $MIN_VALUE ] && [ "$(battery_state)" = "discharging" ]; then
    send_charge_battery_message
fi

#!/bin/bash

# Dependencies:
# - at

SCRIPT_FULL_PATH="$(readlink -f "$0")"

MIN_BATTERY_PERCENT=41
MAX_BATTERY_PERCENT=79

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

schedule_next_check() {
    local check_after_minutes=1

    if [ "$(battery_state)" = "charging" ]; then
        if [ $(battery_percentage) -le $(( $MAX_BATTERY_PERCENT - 10 )) ]; then
            check_after_minutes=9
        fi
    elif [ "$(battery_state)" = "discharging" ]; then
        if [ $(battery_percentage) -ge $(( $MIN_BATTERY_PERCENT + 10 )) ]; then
            check_after_minutes=10
        fi
    fi

    echo "DISPLAY=:0.0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus $SCRIPT_FULL_PATH" | at now + $check_after_minutes minutes
}

main() {
    if [ $(battery_percentage) -ge $MAX_BATTERY_PERCENT ] && [ "$(battery_state)" = "charging" ]; then
        send_unplug_charging_message
    elif [ $(battery_percentage) -le $MIN_BATTERY_PERCENT ] && [ "$(battery_state)" = "discharging" ]; then
        send_charge_battery_message
    fi

    schedule_next_check
}

main

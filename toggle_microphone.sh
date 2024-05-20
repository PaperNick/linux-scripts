#!/bin/bash

# Mute/Unmute built-in and external USB mics
# Inspired from: https://askubuntu.com/a/1152002

toggle_builtin_mic() {
    pacmd list-sources | grep -B 60 'analog-input-internal-mic:' | grep -oP 'index: \d+' | awk '{print $2}' | xargs -I {} pactl set-source-mute {} toggle
}

builtin_mic_status() {
    local is_builtin_mic_muted="$(pacmd list-sources | grep -B 60 'analog-input-internal-mic:' | grep muted | awk '{print $2}')"
    if [ "$(echo $is_builtin_mic_muted)" = 'yes' ]; then
        # Mic is off - return value 0
        echo 0
    else
        # Mic is on - return value 1
        echo 1
    fi
}

mute_usb_mic() {
    pacmd list-sources | grep -i -C 1 Blue_Microphones | grep -oP 'index: \d+' | awk '{print $2}' | xargs -I {} pactl set-source-mute {} 1
}

unmute_usb_mic() {
    pacmd list-sources | grep -i -C 1 Blue_Microphones | grep -oP 'index: \d+' | awk '{print $2}' | xargs -I {} pactl set-source-mute {} 0
}

main() {
    toggle_builtin_mic
    is_builtin_mic_on="$(builtin_mic_status)"
    if [ "$is_builtin_mic_on" = "1" ]; then
        unmute_usb_mic
        notify-send -t 3000 -i audio-input-microphone-symbolic 'Microphone On' 'You microphone is now enabled'
    else
        mute_usb_mic
        notify-send -t 3000 -i microphone-sensitivity-muted-symbolic 'Microphone Muted' 'You microphone has been muted'
    fi
}

main

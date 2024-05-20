#!/bin/bash

# Mute/Unmute built-in and external USB mics
# Inspired from: https://askubuntu.com/a/1152002

toggle_builtin_mic() {
    builtin_mic_toggle_output="$(amixer set Capture toggle)"
    if [ "$(echo $builtin_mic_toggle_output | grep '\[on\]')" != '' ]; then
        # Mic is on - return value 1
        echo 1
    else
        # Mic is off - return value 0
        echo 0
    fi
}

mute_usb_mic() {
    pacmd list-sources | grep -i -C 1 Blue_Microphones | grep -oP 'index: \d+' | awk '{print $2}' | xargs -I {} pactl set-source-mute {} 1
}

unmute_usb_mic() {
    pacmd list-sources | grep -i -C 1 Blue_Microphones | grep -oP 'index: \d+' | awk '{print $2}' | xargs -I {} pactl set-source-mute {} 0
}

main() {
    is_builtin_mic_on="$(toggle_builtin_mic)"

    if [ "$is_builtin_mic_on" = "1" ]; then
        unmute_usb_mic
        notify-send -t 3000 -i audio-input-microphone-symbolic 'Microphone On' 'You microphone is now enabled'
    else
        mute_usb_mic
        notify-send -t 3000 -i microphone-sensitivity-muted-symbolic 'Microphone Muted' 'You microphone has been muted'
    fi
}

main

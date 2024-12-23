#!/bin/bash

# Mute/Unmute built-in and external USB mics
# Inspired from: https://askubuntu.com/a/1152002
# Use pactl instead of pacmd: https://www.baeldung.com/linux/microphone-mute-unmute

INTERNAL_MIC_ID="$(pactl list short sources | grep 'alsa_input.pci-0000' | awk '{print $1}')"
BLUE_MIC_ID="$(pactl list short sources | grep Blue_Microphones | awk '{print $1}')"

toggle_builtin_mic() {
    pactl set-source-mute "$INTERNAL_MIC_ID" toggle
}

toggle_usb_mic() {
    pactl set-source-mute "$BLUE_MIC_ID" toggle
}

builtin_mic_status() {
    local is_builtin_mic_muted="$(pactl list | grep -i "Source.*#$INTERNAL_MIC_ID" -A 10 | grep -i Mute | awk '{print $2}')"
    if [ "$(echo $is_builtin_mic_muted)" = 'yes' ]; then
        # Mic is off - return value 0
        echo 0
    else
        # Mic is on - return value 1
        echo 1
    fi
}

mute_usb_mic() {
    pactl set-source-mute "$BLUE_MIC_ID" 1
}

unmute_usb_mic() {
    pactl set-source-mute "$BLUE_MIC_ID" 0
}

main() {
    if [ "$INTERNAL_MIC_ID" = "" ]; then
        # Internal mic is not enabled, toggle only the Blue mic
        toggle_usb_mic
    else
        toggle_builtin_mic
        is_builtin_mic_on="$(builtin_mic_status)"
        if [ "$is_builtin_mic_on" = "1" ]; then
            unmute_usb_mic
            notify-send -t 3000 -i audio-input-microphone-symbolic 'Microphone On' 'You microphone is now enabled'
        else
            mute_usb_mic
            notify-send -t 3000 -i microphone-sensitivity-muted-symbolic 'Microphone Muted' 'You microphone has been muted'
        fi
    fi
}

main

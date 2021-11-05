#!/bin/bash

mic_toggle_output="$(amixer set Capture toggle)"
if [ "$(echo $mic_toggle_output | grep '\[on\]')" != '' ]; then
    is_mic_on=1
else
    is_mic_on=0
fi

if [ "$is_mic_on" = "1" ]; then
    notify-send -t 3000 -i audio-input-microphone-symbolic 'Microphone On' 'You microphone is now enabled'
else
    notify-send -t 3000 -i microphone-sensitivity-muted-symbolic 'Microphone Muted' 'You microphone has been muted'
fi

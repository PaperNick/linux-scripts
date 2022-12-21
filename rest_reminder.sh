#!/bin/bash

SCRIPT_FULL_PATH="$(readlink -f "$0")"
REMIND_AFTER_MINUTES=70

notify-send -t 10000 -i gnome-set-time 'Break Time!' 'Stand up, move around and refresh your eyes for a couple of minutes.'

echo "'$SCRIPT_FULL_PATH'" | at now + $REMIND_AFTER_MINUTES minutes

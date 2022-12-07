#!/bin/bash

SCRIPT_FULL_PATH="$(readlink -f "$0")"

notify-send -t 10000 -i gnome-set-time 'Break Time!' 'Stand up, move around and refresh your eyes for a couple of minutes.'

echo "sleep 10m && '$SCRIPT_FULL_PATH'" | at now + 60 minutes

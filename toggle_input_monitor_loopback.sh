#!/bin/bash

# Sources:
# https://plusdeck.readthedocs.io/en/latest/loopback/
# https://blog.georgovassilis.com/2021/03/02/monitoring-input-audio-with-ubuntu/


function is_loopback_enabled() {
  local is_loopback_enabled=0

  if [ "$(pactl list modules | grep module-loopback)" != "" ]; then
    is_loopback_enabled=1
  fi

  # Return the boolean int value
  echo $is_loopback_enabled
}


if [ "$(is_loopback_enabled)" = "1" ]; then
  # Disable loopback
  pactl unload-module module-loopback
  notify-send -t 3000 -i microphone-sensitivity-muted-symbolic 'Monitor Off' 'Input monitor loopback has been disabled'
else
  # Enable loopback
  pactl load-module module-loopback latency_msec=1
  notify-send -t 3000 -i audio-input-microphone-symbolic 'Monitor On' 'Input monitor loopback has been enabled'
fi

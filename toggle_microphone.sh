#!/bin/bash

# Toggles the active input devices and mutes the rest of the input sources

# Sources:
# Inspired from: https://askubuntu.com/a/1152002
# Use pactl instead of pacmd: https://www.baeldung.com/linux/microphone-mute-unmute
# https://man.archlinux.org/man/pactl.1#COMMANDS

# Devices
DEFAULT_DEVICE='@DEFAULT_SOURCE@'
DEFAULT_DEVICE_NAME="$(pactl get-default-source)"  # Returns "auto_null.monitor" when no input devices
DEFAULT_DEVICE_ID="$(pactl list short sources | grep "$DEFAULT_DEVICE_NAME" | awk '{print $1}')"

INTERNAL_MIC_ID="$(pactl list short sources | grep 'alsa_input.pci-0000' | awk '{print $1}')"
BLUE_MIC_ID="$(pactl list short sources | grep 'alsa_input.usb.*Blue_Microphones' | awk '{print $1}')"
FOCUSRITE_SCARLETT_ID="$(pactl list short sources | grep 'alsa_input.usb-Focusrite_Scarlett_4i4' | awk '{print $1}')"
ALL_DEVICES=("$INTERNAL_MIC_ID" "$BLUE_MIC_ID" "$FOCUSRITE_SCARLETT_ID")

OTHER_DEVICES=()
for device_id in "${ALL_DEVICES[@]}"; do
  if [ "$device_id" != "" ] && [ "$device_id" != "$DEFAULT_DEVICE_ID" ]; then
    OTHER_DEVICES+=("$device_id")
  fi
done

is_device_muted() {
  local device_id="$1"

  # Return value: 'yes' or 'no'
  pactl get-source-mute "$device_id" | awk '{print $2}'
}

toggle_device() {
  local device_id="$1"
  pactl set-source-mute "$device_id" toggle
}

mute_device() {
  local device_id="$1"
  echo "$device_id" | xargs -I {} pactl set-source-mute "{}" 1
}

unmute_device() {
  local device_id="$1"
  echo "$device_id" | xargs -I {} pactl set-source-mute "{}" 0
}

main() {
  toggle_device "$DEFAULT_DEVICE"

  # Mute other input sources
  for device_id in "${OTHER_DEVICES[@]}"; do
    mute_device "$device_id"
  done
}

main

#!/bin/bash

# Add as a custom action in Thunar:
# Paste the following in ~/.config/Thunar/uca.xml
#
# <action>
#   <icon>applications-multimedia</icon>
#   <name>Total Duration of Media</name>
#   <submenu></submenu>
#   <unique-id>1759255574082022-1</unique-id>
#   <command>/PATH/TO/SCRIPTS/calculate_media_duration.sh %F</command>
#   <description>Calculate the total duration of the selected media files and display a notification</description>
#   <range>*</range>
#   <patterns>*</patterns>
#   <audio-files/>
#   <video-files/>
# </action>

MEDIA_FILES=("$@")

if [ "${#MEDIA_FILES[@]}" = "0" ]; then
  echo "Error: No media files provided"
  exit 1
fi

if [ "$(command -v ffprobe)" = "" ]; then
  echo 'Error: "ffmpeg" is not installed on this system. Aborting script.'
  exit 1
fi


DURATION_SECONDS=0
for file in "${MEDIA_FILES[@]}"; do
  if [ ! -f "$file" ]; then
    continue
  fi

  file_seconds="$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" 2> /dev/null | awk '{print int($1)}')"
  file_seconds="${file_seconds:-0}"  # Set seconds to 0 on error

  DURATION_SECONDS=$((DURATION_SECONDS+file_seconds))
done

if [ "$DURATION_SECONDS" = "0" ]; then
  exit 0
fi


total_time_formatted="$(printf '%02d:%02d:%02d\n' $((DURATION_SECONDS/3600)) $((DURATION_SECONDS%3600/60)) $((DURATION_SECONDS%60)))"
notify-send -i preferences-system-time-symbolic "Total Duration of the selected files" "$total_time_formatted"

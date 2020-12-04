echo "notify-send -i gnome-set-time 'Break Time!' 'Stand up, move around and refresh your eyes for a couple of minutes.' && sleep 10m && eval '$(readlink -f "$0")'" | at now + 60 minutes

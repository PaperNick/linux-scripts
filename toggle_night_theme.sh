#!/bin/bash

CURRENT_THEME="$(xfconf-query -c xfwm4 -p /general/theme)"

if [ "$CURRENT_THEME" = "Greybird" ]; then
    xfconf-query -c xfwm4 -p /general/theme -s Greybird-dark
    xfconf-query -c xsettings -p /Net/ThemeName -s Greybird-dark
else
    xfconf-query -c xfwm4 -p /general/theme -s Greybird
    xfconf-query -c xsettings -p /Net/ThemeName -s Greybird
fi

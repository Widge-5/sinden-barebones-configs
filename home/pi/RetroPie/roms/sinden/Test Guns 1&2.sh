#!/bin/bash
{
  sudo pkill -9 -f "mono"
  sudo rm /tmp/LightgunMono* -f
} &> /dev/null

utilscfg="/home/pi/Lightgun/utils/widgeutils.cfg"

cd /home/pi/Lightgun/Application
sudo mono LightgunMono.exe sdl 30

# ON EXIT #
if [ $(grep "<AutostartEnable>" "$utilscfg" | grep -o '".*"' | sed 's/"//g') = "1" ]; then
  echo "Autostarting is enabled, no need to display reminder message."
else
  dialog --infobox "\nNow restart your Sinden Lightguns\n      before your next game" 6 37
  sleep 3
fi
clear

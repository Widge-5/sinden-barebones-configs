#!/bin/bash
clear
{
  sudo pkill -9 -f "mono"
  sudo rm /tmp/LightgunMono* -f
} &> /dev/null


cd /home/pi/Lightgun/Application
sudo mono-service LightgunMono.exe

#!/bin/bash
clear
{
  sudo pkill -9 -f "mono"
  sudo rm /tmp/LightgunMono* -f
} &> /dev/null



cd /home/pi/Lightgun/Player1recoilauto
sudo mono-service LightgunMono.exe
cd /home/pi/Lightgun/Player2recoilauto
sudo mono-service LightgunMono2.exe
cd /home/pi/Lightgun/Player3recoilauto
sudo mono-service LightgunMono3.exe
cd /home/pi/Lightgun/Player4recoilauto
sudo mono-service LightgunMono4.exe

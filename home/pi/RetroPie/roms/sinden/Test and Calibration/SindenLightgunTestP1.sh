#!/bin/bash
{
  sudo pkill -9 -f "mono"
  sudo rm /tmp/LightgunMono* -f
} &> /dev/null


DIR=/home/pi/Lightgun/Player1
hdfile=test1080.bmp
sdfile=test720.bmp
ogfile=testOG.bmp

framebuffer=$(fbset)
yres=$(echo $framebuffer | grep "geometry" | awk -F" " '{print $5 }')
echo $yres" display detected"

if [ $yres -ge 1080 ]; then
    cp -p $DIR/$hdfile $DIR/test.bmp
elif [ $yres -ge 720 ]; then
    cp -p $DIR/$sdfile $DIR/test.bmp
else
  cp -p $DIR/$ogfile $DIR/test.bmp
fi

cd $DIR
sudo mono LightgunMono.exe sdl 30

# sinden-barebones-configs
Collection of updated/edited configuration files for the Sinden Barebones 9.1 image.  

This repository houses the default configuration files for the Sinden Barebones image and its games.  If you need to restore a lost or corrupted file for your barebones image, you should be able to find it here.

This branch is a Work-In-Progress.

### To-Do ###
- ~~Supermodel.ini (restore default hotkeys)~~ *file updated*
- ~~LG mono config for p2 recoil configs have p1 buttons set.~~ *files updated*
- ~~LG mono config for p2 needs to have CalibrateX and CalibrateY offset values removed~~ *non-existent*
- ~~Add README.txt in RetroPie/roms/daphne/ showing how to create symlinks for actionmax roms~~ *included in fixes script*
- ~~New PHO config~~ *file updated*
- ~~Storm Bubbles MAME builds (4 total)~~ *a script has been created to automate installation*
- ~~Super Russian Roulette config (controls correction)~~ *file edited*
- ~~Fix ownership of folders under roms~~ *included in fixes script*
- global emulators.cfg needs to be appended with new games
- retroarch.cfg needs keyboard mapsfor joypads removed -- *file updated but needs to be surgically amended in script*
- retroarch.cfg needs `input_overlay_next = alt` -- *file updated but needs to be surgically amended in script*
- create mame cfgs for newly supported games that need them
- check if any mame artwork/samples are needed.
- ~~New firefox config for Mame2010~~ *file created*
- ~~new overlay cfgs to enable border-size switching~~ *files edited*
- ~~new overlays for newly supported games~~ *files created*
- delete old `firefox.opt` for mame-current

### Script needs to : ###
- download and install newly created/edited files
- delete `/opt/retropie/configs/all/retroarch/config/MAME/firefox.opt`
- Surgically amend 2x 'lightgunmono2.exe.config' files
- Surgically amend '/opt/retropie/configs/all/retroarch.cfg'
- make SBupdate.sh executable and run it
- run the chmod command to fix rom folder permissions

### emulators.cfg additions ###
#### *confirmed* ####
- arcade_firefox = "lr-mame2010-StormedBubbles"
- arcade_bshark = "lr-mame-StormedBubbles"
- arcade_seawolf = "lr-mame-StormedBubbles"
- arcade_seawolf2 = "lr-mame-StormedBubbles"
- arcade_sharrier = "lr-mame-StormedBubbles"
- arcade_skyraid = "lr-mame-StormedBubbles"
- arcade_tailg = "lr-mame-StormedBubbles"
- arcade_topgunner = "lr-mame-StormedBubbles"
- arcade_wildplt = "lr-mame-StormedBubbles"
*(note- firefox is a change to an existing entry)
#### *unfinished* ####
- arcade_avalnche = "lr-mame-StormedBubbles"
- arcade_destroyr = "lr-mame-StormedBubbles"
- arcade_lockon = "lr-mame-StormedBubbles"
- arcade_nightstr = "lr-mame-StormedBubbles"
- arcade_pong = "lr-mame-StormedBubbles"

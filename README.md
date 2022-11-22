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
- ~~global emulators.cfg needs to be appended with new games~~ *file editeded*
- ~~retroarch.cfg needs keyboard maps for joypads removed~~  *file updated but needs to be surgically amended in script*
- ~~retroarch.cfg needs `input_overlay_next = alt`~~ *file updated but needs to be surgically amended in script*
- ~~create mame cfgs for newly supported games that need them~~ *files created*
- ~~check if any mame artwork/samples are needed.~~ *files added*
- ~~New firefox config for Mame2010~~ *file created*
- ~~new overlay cfgs to enable border-size switching~~ *files edited*
- ~~new overlays for newly supported games~~ *files created*
- ~~delete old `firefox.opt` for mame-current~~ -- *deleted from repo, but needs to be removed in script*

### Script needs to : ###
- download and install newly created/edited files - using the file `changed_file_list.txt` as reference.  Each line on that file is the download link for the file and the destination location of the file seperated with only a single semi-colon `;`. The script needs to be able to deal with filenames that may contain commas `,`. 
- delete `/opt/retropie/configs/all/retroarch/config/MAME/firefox.opt`
- Surgically amend 2x 'lightgunmono2.exe.config' files to correct the button assignments
- Surgically amend '/opt/retropie/configs/all/retroarch.cfg' to remove p1 controller keyboard binds
- Amend '/opt/retropie/configs/all/emulators.cfg' with the entries listed below.  To avoid duplicates, the script should check if an entry already exists for the game named before the `=` and, if so, alter it to match our list. Otherwise, just append the entry to the end of the file.
- make SBupdate.sh executable and run it (downloaded earlier in script) to download and install latest StormedBubbles cores.
- Update stock lr-mame2003-plus (a binary update is fine) for the maxforce alignment fix
- run the chown command to fix rom folder permissions
- (I recommend naming this script something like BB90-91update or whatever. Something that makes it clear this is an update from BB9.0 to BB9.1.  Don't want someone running this in the future if they already have a later release).


### emulators.cfg additions ###
#### *confirmed* ####
- arcade_firefox = "lr-mame2010-StormedBubbles"
- arcade_avalnche = "lr-mame-StormedBubbles"
- arcade_bombee = "lr-mame-StormedBubbles"
- arcade_bshark = "lr-mame-StormedBubbles"
- arcade_cutieq = "lr-mame-StormedBubbles"
- arcade_destroyr = "lr-mame-StormedBubbles"
- arcade_geebee = "lr-mame-StormedBubbles"
- arcade_lockon = "lr-mame-StormedBubbles"
- arcade_mmagic = "lr-mame-StormedBubbles"
- arcade_seawolf = "lr-mame-StormedBubbles"
- arcade_seawolf2 = "lr-mame-StormedBubbles"
- arcade_sharrier = "lr-mame-StormedBubbles"
- arcade_skyraid = "lr-mame-StormedBubbles"
- arcade_sprtshot = "lr-flycast"
- arcade_tailg = "lr-mame-StormedBubbles"
- arcade_topgunner = "lr-mame-StormedBubbles"
- arcade_wildplt = "lr-mame-StormedBubbles"

*(note- firefox is a change to an existing entry)*



### Summary of files to be updated from changed_file_list.txt ###
- The StormedBubbles update script
- daphne Readme.txt
- revised Supermodel.ini
- Sports Shooting USA calibration
- Golly Ghost Calibration
- Point Blank 2 Calibration
- artwork files for mame games
- new/updated mame game cfgs
- new/updated retroarch game cfgs
- system launching images
- new/updated bezel overlay images
- new updated overlay cfgs that allow border resizing.

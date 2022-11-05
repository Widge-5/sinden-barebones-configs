#!/bin/bash

#########################################################################################
###     Author: wiggy808
###     Created: 11/2/2022
###     Notes: Fixes the following issues for BB9:
###
###     1.) New PHO config
###     2.) Storm Bubbles MAME builds
###     3.) Supermodel.ini
###     4.) Super Russian Roulette config (controls correction).
###     5.) Fix ownership of folders under roms
###     6.) LG mono config for p2 recoil configs have p1 buttons set.
###     7.) Add README.txt in RetroPie/roms/daphne/ showing how to create symlinks for actionmax roms
###
###     Usage: sudo ./script_name.sh
#########################################################################################

####---------------------------------------Common----------------------------------------
ROMDIR=/home/pi/RetroPie/roms
DAPHNE_DIR=daphne
P2_REC_DIR=/home/pi/Lightgun/Player2recoil
P2_RECAUTO_DIR=/home/pi/Lightgun/Player2recoilauto
FILE=LightgunMono2.exe.config
LOG=/tmp/bb9_fixes.log
BBFILE=/etc/bb-release
GTG=0
AMREADME=$ROMDIR/daphne/README.TXT

function update_button_value () {
        echo "changing ${1} to ${2} in file ${3}"
        sed -i -e "s/\"${1}\" value=\"[0-9][0-9]\"/\"${1}\" value=\"${2}\"/" ${3}
}

function vbb () {
        val=$(md5sum $BBFILE | awk '{print $1}')
        if [[ "$val" == "90577410891f44ec5d52efaa55ffe95b" ]]; then
                GTG=1
        fi
}



##---Item 5
##---------------- Several rom folders are not set to owner pi group pi -----------------------
function update_permissions () {
	echo "Fixing permissions on recoil configs... "
	chown -R pi:pi $ROMDIR
}

##---Item 6
##-------------- LG mono config for p2 recoil configs have p1 buttons set ---------------------
function update_p2_recoil () {
	echo "Fixing p2 recoil configs... "
	# Fixes for P2 Recoil LightgunMono2.exe.config
	update_button_value ButtonFrontRight 10 $P2_REC_DIR/$FILE
	update_button_value ButtonRearRight 14 $P2_REC_DIR/$FILE
	update_button_value ButtonUp 61 $P2_REC_DIR/$FILE
	update_button_value ButtonDown 49 $P2_REC_DIR/$FILE
	update_button_value ButtonLeft 47 $P2_REC_DIR/$FILE
	update_button_value ButtonRight 50 $P2_REC_DIR/$FILE
	update_button_value ButtonFrontRightOffscreen 10 $P2_REC_DIR/$FILE
	update_button_value ButtonRearRightOffscreen 14 $P2_REC_DIR/$FILE
	update_button_value ButtonUpOffscreen 61 $P2_REC_DIR/$FILE
	update_button_value ButtonDownOffscreen 49 $P2_REC_DIR/$FILE
	update_button_value ButtonLeftOffscreen 47 $P2_REC_DIR/$FILE
	update_button_value ButtonRightOffscreen 50 $P2_REC_DIR/$FILE
}

function update_p2_recoil_auto () {}
	echo "Fixing p2 recoil auto configs... "
	# Fixes for P2 Recoil Auto LightgunMono2.exe.config
	update_button_value ButtonFrontRight 10 $P2_RECAUTO_DIR/$FILE
	update_button_value ButtonRearRight 14 $P2_RECAUTO_DIR/$FILE
	update_button_value ButtonUp 61 $P2_RECAUTO_DIR/$FILE
	update_button_value ButtonDown 49 $P2_RECAUTO_DIR/$FILE
	update_button_value ButtonLeft 47 $P2_RECAUTO_DIR/$FILE
	update_button_value ButtonRight 50 $P2_RECAUTO_DIR/$FILE
	update_button_value ButtonFrontRightOffscreen 10 $P2_RECAUTO_DIR/$FILE
	update_button_value ButtonRearRightOffscreen 14 $P2_RECAUTO_DIR/$FILE
	update_button_value ButtonUpOffscreen 61 $P2_RECAUTO_DIR/$FILE
	update_button_value ButtonDownOffscreen 49 $P2_RECAUTO_DIR/$FILE
	update_button_value ButtonLeftOffscreen 47 $P2_RECAUTO_DIR/$FILE
	update_button_value ButtonRightOffscreen 50 $P2_RECAUTO_DIR/$FILE
}

##---Item 7
##-------------- Create README for how to play actionmax roms ---------------------

function create_am_readme () {
        echo "Adding $AMREADME for actionmax roms..."
cat >"$AMREADME" <<_EOF_
cd ~/RetroPie/roms/daphne
ln -s actionmax 38ambushalley.daphne
ln -s actionmax bluethunder.daphne
ln -s actionmax hydrosub2021.daphne
ln -s actionmax popsghostly.daphne
ln -s actionmax sonicfury.daphne
_EOF_

}


#------------------------------------------------------------------------------------
###------------------------------------MAIN------------------------------------------
#------------------------------------------------------------------------------------
function main () {
	vbb
	if [ $GTG -eq 1 ]; then
		update_permissions
		update_p2_recoil
		update_p2_recoil_auto
		create_am_readme
	else
		echo "This script is for official BB9 images only".
	fi
}

main | tee $LOG
cat $LOG

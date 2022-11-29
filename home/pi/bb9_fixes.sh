#!/bin/bash

#########################################################################################
###     Author: wiggy808
###     Created: 11/2/2022
###     Updated: 11/25/2022
###     Notes: Fixes the following issues for BB9:
###
###     1.) New PHO config
###     2.) Storm Bubbles MAME builds
###     3.) Supermodel.ini
###     4.) Super Russian Roulette config (controls correction).
###     5.) Fix ownership of folders under roms
###     6.) LG mono config for p2 recoil configs have p1 buttons set.
###     7.) [REMOVED] Add README.txt in RetroPie/roms/daphne/ showing how to create symlinks for actionmax roms
###     8.) Download latest Change File Config list and process entries to update bios / config / bezels etc.
###     9.) Update stock Mame2003-Plus and all StormedBubbles Mame cores  -WIDGE
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
CURRDIR=$(pwd)
TMPDIR=$CURRDIR/changefiles
CONF=changed_file_list.txt
CONFCLEAN=changed_file_list.txt.clean
CONFURL="https://raw.githubusercontent.com/Widge-5/sinden-barebones-configs/BB-9.1/changed_file_list.txt"
SB_UPDATE="/home/pi/SBupdater.sh"
GLOBAL_CFG=/opt/retropie/configs/all/retroarch.cfg


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


##---Item 8
##-------------- Download latest Change file for new Bezels Configs etc ---------------------
function get_config_changes () {

        #----------------------------------------------------#
        #--- Prep work and dl of latest Change File list  ---#
        #----------------------------------------------------#

        #--- Ensure wget is installed ---#
         wget_test=$(dpkg -l | grep wget)
         if [ -z "$wget_test" ]; then
                echo "Installing wget..."
                apt install wget -y
         fi

        #--- Download new and remove pre-existing Master Change File and other change files ---#
         if [ ! -d $TMPDIR ]; then
             mkdir $TMPDIR
         else
                echo "Prepping $TMPDIR for processing Master Change File..."
                /bin/rm -rf $TMPDIR/*
         fi
         cd $TMPDIR

         echo "Downloading latest Master Change File..."
         wget $CONFURL
         tr -d '^M' <$CONF > $CONFCLEAN


	#---------------------------------#
        #--- Process Change File list  ---#
        #---------------------------------#
        if [ ! -f $CONFCLEAN ]; then
                echo "----------ERROR!! could not download latest Master Change File from: $CONFURL exiting-------------"
                exit 0
        else

                echo "Master Change File downloaded successfully, processing..."
                IFS=$'\n'
                for line in `cat $CONFCLEAN`
                do

                        src=$(echo $line | cut -d";" -f1)
                        dst=$(echo $line | cut -d";" -f2)

                        #--- Process each Change File Entry ---#
                         echo "Downloading Change file: $src..."
                         change_file_entry=$(basename $src)
                         wget --content-disposition $src

                        #--- Verify change file entry download ---#
                         if [ ! -f "$change_file_entry" ]; then
                                echo "----------ERROR!! could not download $change_file_entry from: $src continuing-------------"
                         else
                                #--- Backup system file if it exists. Install new one ---#			 ### SOME FILES IN VARIOUS LOCATIONS SHARE THE SAME NAME, WILL THIS OVERWRITE SAME-NAME BACKUPS? -WIDGE
														### Names are irrelevant, only paths with names matter. dst is the second variable in the change_list_file.txt which is supposed to be unique yes? --wiggy 
                                if [ -f "$dst" ]; then
                                        echo "Backing up existing file: $dst..."
                                        /bin/cp -p $dst "$dst".bak
                                fi

                                /bin/cp -p $change_file_entry $dst
                                if [ $? == 0 ]; then
                                        echo "Change file: $change_file_entry installed successfully..."
                                else
                                        echo "----------ERROR!! could not install $change_file_entry into: $dst continuing-------------"
                                fi
                         fi
			 
                done

		### CAN WE DELETE THE CHANGELIST FILE HERE, ONCE PROCESSING IS COMPLETE? ###
		### The file is kept for future scalability. If file is removed we cannot determine the last changelist file processed on the Pi. 
		### "/bin/rm -rf $TMPDIR/*" above removes existing ones before it saves the current one running so that only the last changelist is kept for this reason.
        fi
}


function update_mame_cores () {			### - ADDED BY WIDGE - ###
	echo "Updating lr-mame2003-plus..."              
	/home/pi/RetroPie-Setup/retropie_packages.sh lr-mame2003-plus
										# - ADD IN SOME TEST HERE TO CHECK SUCCESS, ECHO ERROR IF FAILED. Good idea, not sure best way to do this dpkg maybe. -wiggy
	echo "Updating StormedBubbles mame cores..."
	if test -f $SB_UPDATE; then			# Test to make sure the SB Update script was downloaded
		chmod +x $SB_UPDATE
		$SB_UPDATE
	else
	      echo "----------ERROR!! SBupdater is not installed-------------"
	fi
}

function update_cfg_value () {				#  PLEASE CHECK THIS, NOT 100% SURE IF THIS IS CORRECT
        echo "changing ${1} to ${2} in file ${3}"	#  TRIED TO REVERSE ENGINEER YOUR update_button_value FUNCTION
        sed -i -e "s/${1} = \"[0-9][0-9]\"/${1} = \"${2}\"/" ${3}
}

function update_global_config () {}
	echo "Fixing Global retroarch.cfg... "
	# make p1-gun-select the border change button (hotkey + back-right)
	update_cfg_value input_overlay_next alt $GLOBAL_CFG
	# remove P1 keyboard binds
	update_cfg_value input_player1_b nul $GLOBAL_CFG
	update_cfg_value input_player1_l nul $GLOBAL_CFG
	update_cfg_value input_player1_left nul $GLOBAL_CFG
	update_cfg_value input_player1_r nul $GLOBAL_CFG
	update_cfg_value input_player1_right nul $GLOBAL_CFG
	update_cfg_value input_player1_select nul $GLOBAL_CFG
	update_cfg_value input_player1_start nul $GLOBAL_CFG
	update_cfg_value input_player1_up nul $GLOBAL_CFG
	update_cfg_value input_player1_x nul $GLOBAL_CFG
	update_cfg_value input_player1_y nul $GLOBAL_CFG
}

#------------------------------------------------------------------------------------
###------------------------------------MAIN------------------------------------------
#------------------------------------------------------------------------------------
function main () {
	vbb
	if [ $GTG -eq 1 ]; then
		update_p2_recoil
		update_p2_recoil_auto
		update_global_config	# added by Widge
		get_config_changes
		update_mame_cores	# added by Widge
		update_permissions	# Would probably be best to run this last - WIDGE. agree -wiggy
	else
		echo "This script is for official BB9 images only".
	fi
}

main | tee $LOG
cat $LOG

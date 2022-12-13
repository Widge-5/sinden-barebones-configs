#!/bin/bash
#########################################################################################
###     Authors: wiggy808 / Widge
###     Created: 11/2/2022
###     Updated: 12/12/2022
###     Notes: Fixes or adds the following for BB9:
###
###     1.) New PHO config (combined with #8)
###     2.) Storm Bubbles MAME builds (combined with #9)
###     3.) Supermodel.ini - (combined with #8)
###     4.) Super Russian Roulette config controls correction (combined with #8)
###     5.) Fix ownership of folders under /home/pi/RetroPie/roms directory
###     6.) Lightgun mono config for p2 recoil configs have p1 buttons set.
###     7.) Add README.txt in RetroPie/roms/daphne/ showing how to create symlinks for actionmax roms (combined with #8)
###     8.) Download latest Change File Config list and process entries to update bios / config / bezels etc.
###     9.) Update stock Mame2003-Plus and all StormedBubbles Mame cores
###     10.) Removes default keyboard bindings to Player 1 in retropie's global retroarch.cfg 
###     11.) Removes RA configs for ptblank2 and MAME opt files for ptblank2 and firefox
###     12.) Downloads latest Emulator Change config text file and applies to global emulators.cfg
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
CURRDIR=$(pwd)
TMPDIR=$CURRDIR/changefiles
CONF=changed_file_list.txt
CONFCLEAN=changed_file_list.txt.clean
CONFURL="https://raw.githubusercontent.com/Widge-5/sinden-barebones-configs/BB-9.1/changed_file_list.txt"
SB_UPDATE="/home/pi/SBupdater.sh"
GLOBAL_CFG=/opt/retropie/configs/all/retroarch.cfg
GLOBAL_EMU_CFG=/opt/retropie/configs/all/emulators.cfg
CHANGE_EMU_CFG=changed_emulators_cfg.txt
CHANGE_EMU_CFG_CLEAN=changed_emulators_cfg.txt.clean
CHANGE_EMU_CFG_URL="https://raw.githubusercontent.com/Widge-5/sinden-barebones-configs/BB-9.1/changed_emulators_cfg.txt"


function vbb () {
        val=$(md5sum $BBFILE | awk '{print $1}')
        if [[ "$val" == "80577410891f44ec5d52efaa55ffe95b" ]]; then
                GTG=1
        fi
}

function shutdown_es () {
	echo "Shutting Emulation Station down..."
	pkill -9 -f "emulationstation"
}


##---Item 5
##---------------- Several rom folders are not set to owner pi group pi -----------------------
function update_permissions () {
	echo "Fixing permissions on recoil configs... "
	chown -R pi:pi $ROMDIR
}


##---Item 6
##-------------- LG mono config for p2 recoil configs have p1 buttons set ---------------------
function update_button_value () {
        echo "changing ${1} to ${2} in file ${3}"
        sed -i -e "s/\"${1}\" value=\"[0-9][0-9]\"/\"${1}\" value=\"${2}\"/" ${3}
}

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

function update_p2_recoil_auto () {
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
         wget --timeout 15 $CONFURL
         tr -d '\r' <$CONF > $CONFCLEAN
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
					 change_file_entry=$(basename $dst)
					 wget --timeout 15 --content-disposition $src
					#--- Verify change file entry download ---#
					 if [ ! -f "$change_file_entry" ]; then
							echo "----------ERROR!! could not download $change_file_entry from: $src continuing-------------"
					 else
							#--- Backup system file if it exists. Install new one ---#			 
							if [ -f "$dst" ]; then
									echo "Backing up existing file: $dst..."
									/bin/cp -p $dst "$dst".bak
							fi
							mkdir -p "${dst%/*}"
							/bin/cp -p $change_file_entry $dst
							if [ $? == 0 ]; then
									echo "Change file: $change_file_entry installed successfully..."
							else
									echo "----------ERROR!! could not install $change_file_entry into: $dst continuing-------------"
							fi
					 fi
		 
			done
	fi
}

##---Item 9
##--------------  Update stock Mame2003-Plus and all StormedBubbles Mame cores ---------------------
function update_mame_cores () {
	echo "Reinstalling USB ROM Service..."
	/home/pi/RetroPie-Setup/retropie_packages.sh usbromservice remove
	/home/pi/RetroPie-Setup/retropie_packages.sh usbromservice install_bin

        echo "Updating lr-mame2003-plus..."              
	/home/pi/RetroPie-Setup/retropie_packages.sh lr-mame2003-plus install_bin
										# - ADD IN SOME TEST HERE TO CHECK SUCCESS, ECHO ERROR IF FAILED. Good idea, not sure best way to do this dpkg maybe. -wiggy

	echo "Downloading StormedBubbles updater..."
	wget --timeout 15 --content-disposition https://github.com/Widge-5/sinden-barebones-configs/raw/BB-9.1/home/pi/SBupdater.sh

	echo "Updating StormedBubbles mame cores..."
	if test -f $SB_UPDATE; then			# Test to make sure the SB Update script was downloaded
		chmod +x $SB_UPDATE
		$SB_UPDATE
	else
	      echo "----------ERROR!! SBupdater is not installed-------------"
	fi
	
}

##---Item 10
##--------------  Removes default keyboard bindings to Player 1 in retropie's global retroarch.cfg ---------------------
function update_cfg_value () {                          
        echo "changing ${1} to ${2} in file ${3}"       
        sed -i -e "/${1} =/s/\".*\"/\"${2}\"/" ${3}
}

function update_global_config () {
        echo "Fixing Global retroarch.cfg... "
        # Fixes for P2 Recoil Auto LightgunMono2.exe.config
        update_cfg_value input_overlay_next alt $GLOBAL_CFG
        update_cfg_value input_player1_a nul $GLOBAL_CFG
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
        update_cfg_value input_player1_gun_aux_a nul $GLOBAL_CFG

}

##---Item 11
##-------------- Removes RA configs for ptblank2 and MAME opt files for ptblank2 and firefox ---------------------
function remove_mame_files () {
	echo "Removing Firefox option file and Point Blank 2 option and config file..."
	/bin/rm -f /opt/retropie/configs/all/retroarch/config/MAME/firefox.opt
	/bin/rm -f /opt/retropie/configs/all/retroarch/config/MAME 2016/ptblank2.cfg
	/bin/rm -f /opt/retropie/configs/all/retroarch/config/MAME 2016/ptblank2.opt
}

##---Item 12
##-------------- Downloads latest Emulator Change config text file and applies to global emulators.cfg ---------------------
function prep_update_emu_cfg () {
	#- Create working directory for changefiles
        if [ ! -d "$TMPDIR" ]; then
                mkdir -p $TMPDIR
        fi

        #- Download change emulator config file and create backup of current emulators.cfg
        echo "Cleaning out any previous change files..."
        cd $TMPDIR
        /bin/rm -rf $CHANGE_EMU_CFG*

        echo "Downloading latest changed Emulators Config File..."
        wget --timeout 5 $CHANGE_EMU_CFG_URL
        tr -d '\r' <$CHANGE_EMU_CFG > $CHANGE_EMU_CFG_CLEAN


        if [ -f "$GLOBAL_EMU_CFG" ]; then
                echo "Backing up $GLOBAL_EMU_CFG..."
                /bin/cp -fp $GLOBAL_EMU_CFG "$GLOBAL_EMU_CFG".bak
        else
                echo "ERROR: Cannot read $GLOBAL_EMU_CFG perhaps file does not exist"
                exit 0
        fi

}

function update_emu_cfg () {

	if [ -f "$GLOBAL_EMU_CFG" ]; then

                echo "Configuring $GLOBAL_EMU_CFG for $1..."

                #- $CHANGE_EMU_CFG key / values
                key=$(echo $1 | awk '{print $1}')
                value=$(echo $1 | awk '{print $3}')

                #- Get count of entry in emulators.cfg file
                gcount=$(cat $GLOBAL_EMU_CFG  | grep ^"$key " | wc -l)
                echo "found $gcount lines"

                #- Delete all the lines if there's more than 1, modify line if just 1, and add line if 0
                if [ $gcount -gt 1 ]; then
                        sed -i "/^$key /d" $GLOBAL_EMU_CFG              
                        echo "$1" >> $GLOBAL_EMU_CFG
                elif [ $gcount -eq 1 ]; then
                        sed -i -e "/$key =/s/\".*\"/$value/" $GLOBAL_EMU_CFG
                elif [ $gcount -eq 0 ]; then
                        echo "$1" >> $GLOBAL_EMU_CFG
                else
                        echo "ERROR: Cannot read $GLOBAL_EMU_CFG"
                fi
        fi

}


#------------------------------------------------------------------------------------
###------------------------------------MAIN------------------------------------------
#------------------------------------------------------------------------------------
function main () {
	
	#- Script must be run as root
	if [[ $EUID > 0 ]]; then

		echo "ERROR: usage: sudo ./bb9_fixes.sh"
		exit 0
	else	
		vbb
		if [ $GTG -eq 1 ]; then
			shutdown_es
			update_p2_recoil
			update_p2_recoil_auto
			update_global_config
			update_mame_cores
			get_config_changes
			update_permissions
			remove_mame_files

			#- Process Change Emulators Config File
			prep_update_emu_cfg
			if [ -f $CHANGE_EMU_CFG_CLEAN ]; then
				IFS=$'\n'
				for line in `cat $CHANGE_EMU_CFG_CLEAN`
				do
					update_emu_cfg $line
				done
			else
				echo "ERROR: Could not download Change Emulators Config file from: $CHANGE_EMU_CFG_URL Exiting..."
				exit 0
			fi 
			
		else
			echo "This script is for official BB9 images only"
		fi
	exit 0
	fi
}
main | tee $LOG
cat $LOG

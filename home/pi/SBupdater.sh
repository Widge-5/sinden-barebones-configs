#!/bin/bash


function do_everything () {
## function to download the zip unpack it and place it in the required location ##
## The parameters : $1 filename to download (minus extension), 
                 #  $2 location address of file on github
                 #  $3 local destination folder of unpacked .so file
                 #  $4 filename of the .so (including extension)
                 #  $5 for multipart zips, 1 if there is also a .z01 file
                 #  $6 for multipart zips, 1 if there is also a .z02 file

  ## set variables ##
  fNAME=$1; fSOURCE=$2; fDEST=$3 fSO=$4
  
  ##  Set download links for wget ##
  fDL="$fSOURCE$fNAME".zip
  if [ $5 -eq 1 ]; then fDL+=" "$fSOURCE$fNAME".z01"; fi
  if [ $6 -eq 1 ]; then fDL+=" "$fSOURCE$fNAME".z02"; fi

  ## download files ##
  echo "! ! Attempting to download zip files for "$fNAME"..."
  wget $fDL -P "$DIR"

  ## check for a returned error from the download ##
  if [ $? -ne 0 ]; then echo "! !Failed to download "$fNAME
    else
    echo "! ! "$fNAME" downloaded"

    ## backup existing .so file then unpack new .so from zip to the specified location ##
    echo "! ! Making a backup of "$fSO
    mv "$fDEST$fSO" "$fDEST$fSO".bak
    echo "! ! Unzipping "$fSO" from "$fNAME".zip..."
    7z e "$DIR$fNAME".zip -o"$fDEST"

    ## check for a returned error from the unzip process ##
    if [ $? -ne 0 ]; then
      echo "! ! Failed to unzip "$fNAME
      mv "$fDEST$fSO".bak "$fDEST$fSO"
    else echo "! ! Update of "$fNAME" completed"
    fi
  fi
}


function main () {
  ## Create logfile ##
  echo > SBupdate.log
  
  ## Check if script has been run as root and, if not, quit ##
  if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

  echo "! ! StormedBubbles update started $(date)"

  ## Set location constants ##
  DIR="/home/pi/.tmpSB/"
  REPO="https://github.com/Widge-5/Sinden_RPi_Emus/raw/main/compiled_binaries/"

  ## Check if P7Zip is installed and, if not, install it ##
  if  ! dpkg -l | grep -q "7zr"
    then
      echo "! ! P7Zip needed to proceed. Installing..."
      apt install p7zip* -y
    fi

  ## Check if wget is installed and, if not, install it ##
  if  ! dpkg -l | grep -q "wget"
    then
      echo "! ! WGET needed to proceed. Installing..."
      apt install wget -y
    fi

  ## Check if temp location exists and, if not, create it. Otherwise remove any old zips from it ##
  if [ ! -d "$DIR" ]
    then
      echo "! ! Creating temp folder "$DIR
      mkdir "$DIR"
    else
      echo "! ! Temp folder "$DIR" already exists"
      echo "! ! Clearing out any existing zip files from temp folder..."
      rm "$DIR"*.z*
    fi


  ## Begin the update process ##
  echo "! ! Beginning the update process..."
  do_everything "lr-mame2010-StormedBubbles" "$REPO"                            "/opt/retropie/libretrocores/lr-mame2010-StormedBubbles/" "mame2010_libretro.so"       0 0
  do_everything "lr-mame2015-StormedBubbles" "$REPO"lr-mame2015-StormedBubbles/ "/opt/retropie/libretrocores/lr-mame2015-StormedBubbles/" "mame2015_libretro.so"       1 0
  do_everything "lr-mame2016-StormedBubbles" "$REPO"lr-mame2016-StormedBubbles/ "/opt/retropie/libretrocores/lr-mame2016-StormedBubbles/" "mamearcade2016_libretro.so" 1 0
  do_everything "lr-mame-StormedBubbles"     "$REPO"lr-mame-StormedBubbles/     "/opt/retropie/libretrocores/lr-mame-StormedBubbles/"     "mamearcade_libretro.so"     1 1
  do_everything "lr-mess-StormedBubbles"     "$REPO"lr-mess-StormedBubbles/     "/opt/retropie/libretrocores/lr-mess-StormedBubbles/"     "mamemess_libretro.so"       1 1

  ## delete temp folder ##
  echo "! ! Deleting temp folder"
  rm -rf "$DIR"

  echo "! ! StormedBubbles update finished $(date)"
}


main | tee SBupdate.log
cat SBupdate.log | grep "! !"

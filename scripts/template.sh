#!/bin/bash

# ==========================================
# Read sources
source ./sync/paths.dat
source ./sync/launchers.dat
# ==========================================

#set manafacture

man="xx"
# Set system
sys="yy"
#set launcher 
la=${la_xx_yy}
# set if roms are in subfolders or flat , false = flat true = subfolders
subfolder_check=false

#set file extension -

ext1=sfc
ext2=
ext3=
ext4=
ext5=
ext6=


# ===========================================

if [ -d ${remote_data_root}${man}/${sys} ]
then
source ./sync/sync.sh
else 
source ./sync/sync_local.sh
fi



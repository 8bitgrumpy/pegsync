#!/bin/bash

# ==========================================
# Read sources
source ./sync/paths.dat
source ./sync/launchers.dat
# ==========================================

#set manafacture

man="nintendo"
# Set system
sys="snes_cd"
#set launcher 
la=${la_nintendo_snes_cd}
# set if roms are in subfolders or flat , false = flat true = subfolders
subfolder_check=true

#set file extension -

ext1=smc
ext2=sfc
ext3=swc
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



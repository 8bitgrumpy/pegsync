#!/bin/bash

#checks 

echo -----------------------
echo  REMOTE PATH FOUND - USING REMODE MODE!
echo -----------------------

echo   Manafacture set to :-
echo -e "\e[36m ${man} \e[0m"
echo        System set to :-
echo -e "\e[36m ${sys} \e[0m"
echo      Lanucher set to :-
echo -e "\e[36m ${la} \e[0m"

# set remote data path
echo  remote data path set to :-
remote_data=${remote_data_root}${man}/${sys}/data_${sys}
echo -e "\e[36m ${remote_data} \e[0m"

#set local data path
echo  local data path set to :-
local_data=${local_data_root}${man}/${sys}
echo -e "\e[36m ${local_data} \e[0m"

#set local run path
echo  local run path set to :-
local_run=${local_run_root}${man}_${sys}
echo -e "\e[36m ${local_run} \e[0m"

#set sync extension
echo  local extension set to :-
local_e=".${man}_${sys}"
echo -e "\e[36m ${local_e} \e[0m"

#check if subfolders is set in input.dat
if [ "${subfolder_check}" == "true" ]; then
echo Subfolder check
echo -e "\e[36m We are dealing with subfolders .. bah! \e[0m";
else
echo Subfolder check
echo -e "\e[36m Game data has no sub folders to worry about.... nice! \e[0m"
fi

#set exension 
echo extensions set to :-
echo -e "\e[36m $ext1 \e[0m"
echo -e "\e[36m $ext2 \e[0m"
echo -e "\e[36m $ext3 \e[0m"
echo -e "\e[36m $ext4 \e[0m"
echo -e "\e[36m $ext5 \e[0m"
echo -e "\e[36m $ext6 \e[0m"

# ==========================================
# create local paths 
# ==========================================

# create local data manafacture folder 
if [ -d "${local_data_root}${man}" ]
then
echo local data manafacture path exisits , skipping
else 
echo local data manafracture path missing , creating
mkdir ${local_data_root}${man}
fi
# create local data system folder 
if [ -d "${local_data}" ]
then
echo local data system path exisits , skipping
else 
echo local data system path missing , creating
mkdir ${local_data_root}${man}/${sys}
fi

# create local run manafacture folder 
#if [ -d "${local_run_root}${man}" ]
#then
#echo local run manafacture path exisits , skipping
#else 
#echo local run manafracture path missing , creating
#mkdir ${local_run_root}${man}
#fi
# create local data system folder 
if [ -d "${local_run}" ]
then
echo local run system path exisits , skipping
else 
echo local run system path missing , creating
mkdir ${local_run_root}${man}_${sys}
fi

# cleaning out local run folder
rm -rf ${local_run}/*

# ==========================================
# No Subfolder sync 
# ==========================================



#check if subfolders is set in input.dat
if [ "${subfolder_check}" == "false" ]; then
echo Subfolder check
echo -e "\e[37m No subfolders set - Processing remote data as a flat \e[0m"
# find data files in rom path
find "${remote_data}" -maxdepth 1 -type f -name "*.${ext1}" -o -name "*.${ext2}" -o -name "*.${ext3}" -o -name "*.${ext4}" -o -name "*.${ext5}" -o -name "*.${ext6}" | sed "s/.*\///" | while read file; do
{
cat <<EOF >${local_run}/"${file}"
#!/bin/bash
#local run file contents
if [ ! -f ../${local_data}/"${file}" ]; then
rsync -avW --progress ${remote_data}/"${file}" ../${local_data}/"${file}"
fi
${la} ../${local_data}/"${file}"

EOF
}
done
fi

# ==========================================
# fecking Subfolders to sync 
# ==========================================


#check if subfolders is set in input.dat
if [ "${subfolder_check}" == "true" ]; then
echo Subfolder check
echo -e "\e[37m Subfolders set - Processing remote data with subfolders .. arr! \e[0m"
#find remote sub folder name 
find "${remote_data}/" -maxdepth 1 -type d | sed "s/.*\///" | while read dir; do
{
cat <<EOF >${local_run}/"${dir}${local_e}"
#!/bin/bash
#local run file contents
if [ ! -d ../${local_data}/"${dir}" ]; then
rsync -avW --progress ${remote_data}/"${dir}" ../${local_data}/
fi
#set launch file from synced local directory and launch
find ../${local_data}/"${dir}"/ -maxdepth 1 -type f -name "*.${ext1}" -o -name "*.${ext2}" -o -name "*.${ext3}" -o -name "*.${ext4}" -o -name "*.${ext5}" -o -name "*.${ext6}" | sed "s/.*\///" | while read local_ext; do
${la} ../${local_data}/"${dir}"/"\${local_ext}"
done

EOF
}
done
fi


# ==========================================
# enable local run file 
# ==========================================

# set local run file as executable
chmod +x ${local_run}/*
# change file extension of local run files
rename .${ext1} ${local_e} ${local_run}/*.${ext1} 2> /dev/null
rename .${ext2} ${local_e} ${local_run}/*.${ext2} 2> /dev/null
rename .${ext3} ${local_e} ${local_run}/*.${ext3} 2> /dev/null
rename .${ext4} ${local_e} ${local_run}/*.${ext4} 2> /dev/null
rename .${ext5} ${local_e} ${local_run}/*.${ext5} 2> /dev/null
rename .${ext6} ${local_e} ${local_run}/*.${ext6} 2> /dev/null

# ==========================================
# Setup Pegasus file
# ==========================================

{
echo collection: "${man^^}" "${sys^^}"
echo extensions: ${man}_${sys}
echo launch: \"{file.path}\"
} >"${local_run_root}/${man}-${sys}.metadata.pegasus.txt"


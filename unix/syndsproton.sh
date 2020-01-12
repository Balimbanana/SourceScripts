#!/bin/bash
missingdeps() {
echo "You are missing dependencies for Steam"
echo "Use $packageinf"
echo "Then restart this script."
echo "Press enter to exit script"
read nullptr
exit
}

if [ -f /usr/bin/dpkg-query ];then
	if [[ ! $(dpkg-query -l lib32gcc1) ]];then
		if [[ $(cat /etc/os-release | grep ID=ubuntu) ]];then
			packageinf="Use sudo apt-get install lib32gcc1"
			missingdeps
		else
			packageinf="Use your package manager to install lib32gcc1"
			missingdeps
		fi
	fi
fi
if [ -f /usr/bin/dnf ];then
	if [[ ! $(dnf list glibc) ]];then missinglib=1;fi
	if [[ ! $(dnf list libstdc++) ]];then missinglib=1;fi
	if [[ ! $(dnf list glibc.i686) ]];then missinglib=1;fi
	if [[ $missinglib = "1" ]];then
		packageinf="sudo dnf install glibc libstdc++ libc.so.6"
		missingdeps
	fi
fi

start() {
if [ $PWD == $HOME/Steam ]; then
	cd ..
	if [ ! -d ./SteamCMD ]; then
		mkdir ./SteamCMD
	fi
	cd ./SteamCMD
fi
if [ ! -f ./steamcmd.sh ];then inststeam; fi
inststate=0
if [ -f ./steamapps/common/Proton\ 4.11/dist/bin/wine ];then inststate=$(($inststate+1)) ;fi
if [ -f ./drive_c/steamcmd/steamapps/common/Synergy/srcds.exe ];then inststate=$(($inststate+1)) ;fi
if [ -f ./drive_c/steamcmd/steamapps/common/Half-Life\ 2/hl2/hl2_pak_dir.vpk ];then inststate=$(($inststate+1)) ;fi
if [ $inststate == 3 ];then winestart;fi
echo "Enter your Steam username here it will be passed to SteamCMD"
echo "It will be used for installing Proton, Synergy, HL2, Episode 1, and Episode 2:"
read stusername
if [ -z $stusername ];then stusername=none ;fi
anonblck=${stusername,,}
if [ $anonblck = "anonymous" ];then noanon;fi
if [ ! -d ./steamapps/common/Proton\ 4.11/dist/bin ];then
	./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/Proton\ 4.11 +app_update 1113280 validate +quit
fi
if [ ! -d ./steamapps/common/Proton\ 4.11/dist/bin ];then
	if [ -f ./steamapps/common/Proton\ 4.11/proton_dist.tar ];then
		mkdir ./steamapps/common/Proton\ 4.11/dist
		cd ./steamapps/common/Proton\ 4.11/dist
		tar -xf ../proton_dist.tar
		cd ../../../../
	fi
	if [ ! -d ./steamapps/common/Proton\ 4.11/dist/bin ];then
		clear
		echo "Failed to install Proton, your account might be limited in some way, or an incorrect password was entered..."
		start
	fi
fi
if [ ! -d ./drive_c ];then mkdir ./drive_c ;fi
if [ ! -d ./drive_c/steamcmd ];then mkdir ./drive_c/steamcmd ;fi
if [ ! -d ./drive_c/steamcmd/steamapps ];then mkdir ./drive_c/steamcmd/steamapps ;fi
if [ ! -d ./drive_c/steamcmd/steamapps/common ];then mkdir ./drive_c/steamcmd/steamapps/common ;fi
if [ ! -d ./drive_c/steamcmd/steamapps/common/Synergy ];then
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +login $stusername +force_install_dir ./drive_c/steamcmd/steamapps/common/Synergy +app_update 17520 -beta development validate +quit
fi
if [ ! -d ./drive_c/steamcmd/steamapps/common/Half-Life\ 2/hl2 ];then
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +login $stusername +force_install_dir ./drive_c/steamcmd/steamapps/common/Half-Life\ 2 +app_update 220 +app_update 380 +app_update 420 validate +quit
fi
winestart
}

winestart() {
DISPLAY=:0 WINEPREFIX=$PWD WINEDEBUG=-all ./steamapps/common/Proton\ 4.11/dist/bin/wine start ./drive_c/steamcmd/steamapps/common/Synergy/srcds.exe -console -game synergy +map d1_trainstation_06 +maxplayers 16 +sv_lan 0 -ip 0.0.0.0 -port 27015 -nocrashdialog -insecure -nohltv
exit
}

inststeam() {
wget -nv "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"
tar -zxvf steamcmd_linux.tar.gz
if [ ! -f ./steamcmd.sh ]; then
	echo "Something went wrong in downloading/extracting SteamCMD"
	exit
fi
start
}

noanon() {
echo "You cannot use anonymous to install Synergy..."
start
}

start

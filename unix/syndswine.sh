#!/bin/bash
missingdeps() {
echo "You are missing dependencies for Steam or other operations"
echo "Use $packageinf"
echo "Then restart this script."
echo "Press enter to exit script"
read nullptr
exit
}

if [ -f /usr/bin/dpkg-query ];then
	if [[ ! $(dpkg-query -l lib32gcc1) ]];then
		if [[ $(cat /etc/os-release | grep ID=ubuntu) ]];then
			packageinf="sudo apt-get install lib32gcc1"
			missingdeps
		else
			packageinf="your package manager to install lib32gcc1"
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
if [ ! -f /usr/bin/Xvfb ];then
	packageinf="sudo apt-get install xvfb"
	missingdeps
fi
inststate=0
if [ ! -f /tmp/.X0-lock ];then
	Xvfb :0 &
fi
if [ -f /usr/bin/wine ];then inststate=$(($inststate+1)) ;fi
if [ -f ./drive_c/steamcmd/steamapps/common/Synergy/srcds.exe ];then inststate=$(($inststate+1)) ;fi
if [ -f ./drive_c/steamcmd/steamapps/common/Half-Life\ 2/hl2/hl2_pak_dir.vpk ];then inststate=$(($inststate+1)) ;fi
if [ -z $1 ];then
	if [ $1 = "sm" ];then
		if [ ! -f ./drive_c/steamcmd/steamapps/common/Synergy/synergy/addons/sourcemod.vdf ];then
			wget "https://sm.alliedmods.net/smdrop/1.11/sourcemod-latest-windows"
			fullurlcat=https://sm.alliedmods.net/smdrop/1.11/$(cat ./sourcemod-latest-windows)
			wget "$fullurlcat" -P ./drive_c/steamcmd/steamapps/common/Synergy/synergy
			if [ -f ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./sourcemod-latest-windows) ];then
				gzip -d ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./sourcemod-latest-windows)
			fi
			wget "https://mms.alliedmods.net/mmsdrop/1.11/mmsource-latest-windows"
			fullurlcat=https://sm.alliedmods.net/smdrop/1.11/$(cat ./mmsource-latest-windows)
			wget "$fullurlcat" -P ./drive_c/steamcmd/steamapps/common/Synergy/synergy
			if [ -f ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./mmsource-latest-windows) ];then
				gzip -d ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./mmsource-latest-windows)
			fi
		fi
	fi
fi
if [ $inststate == 3 ];then
	if [[ ! $(pgrep -a Steam.exe) ]];then
		DISPLAY=:0 WINEPREFIX=$PWD WINEDEBUG=-all wine start ./drive_c/steamcmd/Steam.exe
	fi
	winestart
fi
if [ ! -f /usr/bin/wine ];then
	echo "Beginning with install of Wine. Press Enter to fully install Wine development branch. This user must have access to sudo apt for this to work. Press Ctrl+C to exit if you don't want to continue."
	read opt
	echo "This will take a while..."
	sudo dpkg --add-architecture i386
	wget -nc https://dl.winehq.org/wine-builds/winehq.key
	sudo apt-key add winehq.key
	if [[ $(cat /etc/os-release | grep VERSION_ID=\"14) ]];then 
		sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ xenial main'
	fi
	if [[ $(cat /etc/os-release | grep VERSION_ID=\"16) ]];then 
		sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ xenial main'
	fi
	if [[ $(cat /etc/os-release | grep VERSION_ID=\"18) ]];then 
		sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
	fi
	if [[ $(cat /etc/os-release | grep VERSION_ID=\"19.04) ]];then 
		sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ disco main'
	fi
	if [[ $(cat /etc/os-release | grep VERSION_ID=\"19.10) ]];then 
		sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ eoan main'
	fi
	if [[ $(cat /etc/os-release | grep VERSION_CODENAME=stretch) ]];then
		wget "https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/i386/libfaudio0_20.01-0~buster_i386.deb"
		wget "https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/amd64/libfaudio0_20.01-0~buster_amd64.deb"
		sudo dpkg -i libfaudio0_20.01-0~buster_i386.deb libfaudio0_20.01-0~buster_amd64.deb
		sudo apt --fix-broken install
		sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/debian/ stretch main'
	fi
	if [[ $(cat /etc/os-release | grep VERSION_CODENAME=buster) ]];then
		wget "https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/i386/libfaudio0_20.01-0~buster_i386.deb"
		wget "https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/amd64/libfaudio0_20.01-0~buster_amd64.deb"
		sudo dpkg -i libfaudio0_20.01-0~buster_i386.deb libfaudio0_20.01-0~buster_amd64.deb
		sudo apt --fix-broken install
		sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/debian/ buster main'
	fi
	if [[ $(cat /etc/os-release | grep VERSION_CODENAME=bullseye) ]];then
		wget "https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/i386/libfaudio0_20.01-0~buster_i386.deb"
		wget "https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/amd64/libfaudio0_20.01-0~buster_amd64.deb"
		sudo dpkg -i libfaudio0_20.01-0~buster_i386.deb libfaudio0_20.01-0~buster_amd64.deb
		sudo apt --fix-broken install
		sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/debian/ bullseye main'
	fi
	sudo apt-get update
	sudo apt-get install --install-recommends winehq-devel
fi
echo "Enter your Steam username here it will be passed to SteamCMD"
echo "It will be used for installing Synergy, HL2, Episode 1, and Episode 2:"
read stusername
if [ -z $stusername ];then stusername=none ;fi
anonblck=${stusername,,}
if [ $anonblck = "anonymous" ];then noanon;fi
echo "Would you also like to install SourceMod? Y/n"
read instsm
if [ -z $instsm ];then instsm="y" ;fi
if [ ! -d ./drive_c ];then mkdir ./drive_c ;fi
if [ ! -d ./drive_c/steamcmd ];then mkdir ./drive_c/steamcmd ;fi
if [ ! -d ./drive_c/steamcmd/steamapps ];then mkdir ./drive_c/steamcmd/steamapps ;fi
if [ ! -d ./drive_c/steamcmd/steamapps/common ];then mkdir ./drive_c/steamcmd/steamapps/common ;fi
if [ ! -f ./drive_c/steamcmd/steamapps/common/Synergy/srcds.exe ];then
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +login $stusername +force_install_dir ./drive_c/steamcmd/steamapps/common/Synergy +app_update 17520 +beta development +validate +quit
fi
if [ ! -d ./drive_c/steamcmd/steamapps/common/Half-Life\ 2/hl2 ];then
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +login $stusername +force_install_dir ./drive_c/steamcmd/steamapps/common/Half-Life\ 2 +app_update 220 +app_update 380 +app_update 420 +validate +quit
fi
if [ ! -d ./drive_c/steamcmd/steamapps/common/Synergy/synergy/addons ];then mkdir ./drive_c/steamcmd/steamapps/common/Synergy/synergy/addons ;fi
if [ $instsm = "y" ];then
	if [ ! -f ./drive_c/steamcmd/steamapps/common/Synergy/synergy/addons/sourcemod.vdf ];then
		wget "https://sm.alliedmods.net/smdrop/1.11/sourcemod-latest-windows"
		fullurlcat=https://sm.alliedmods.net/smdrop/1.11/$(cat ./sourcemod-latest-windows)
		wget "$fullurlcat" -P ./drive_c/steamcmd/steamapps/common/Synergy/synergy
		if [ -f ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./sourcemod-latest-windows) ];then
			gzip -d ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./sourcemod-latest-windows)
		fi
		wget "https://mms.alliedmods.net/mmsdrop/1.11/mmsource-latest-windows"
		fullurlcat=https://sm.alliedmods.net/smdrop/1.11/$(cat ./mmsource-latest-windows)
		wget "$fullurlcat" -P ./drive_c/steamcmd/steamapps/common/Synergy/synergy
		if [ -f ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./mmsource-latest-windows) ];then
			gzip -d ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./mmsource-latest-windows)
		fi
	fi
fi
if [ ! -f ./drive_c/steamcmd/Steam.exe ];then
	wget -nv "https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe" -P ./drive_c/steamcmd
	if [ -f ./drive_c/steamcmd/SteamSetup.exe ];then
		echo "Installing Steam client for Steam server connection..."
		DISPLAY=:0 WINEPREFIX=$PWD WINEDEBUG=-all wine start ./drive_c/steamcmd/SteamSetup.exe /S /D=C:\\steamcmd
		rechecksetup
	fi
fi
if [[ ! $(pgrep -a Steam.exe) ]];then
	DISPLAY=:0 WINEPREFIX=$PWD WINEDEBUG=-all wine start ./drive_c/steamcmd/Steam.exe
fi
winestart
}

rechecksetup() {
sleep 5s
if [ -f ./drive_c/steamcmd/Steam.exe ];then
	if [[ $(pgrep -a SteamSetup.exe) ]];then
		kill $(pgrep SteamSetup.exe)
	fi
	if [[ $(pgrep -a Steam.exe) ]];then
		DISPLAY=:0 WINEPREFIX=$PWD WINEDEBUG=-all wine start ./drive_c/steamcmd/Steam.exe
	fi
fi
}

winestart() {
if [[ ! $(pgrep -a srcds.exe | grep port\ 27015) ]];then
	DISPLAY=:0 WINEPREFIX=$PWD WINEDEBUG=-all wine start ./drive_c/steamcmd/steamapps/common/Synergy/srcds.exe -console -game synergy +map d1_trainstation_06 +exec server2.cfg +maxplayers 16 +sv_lan 0 -ip 0.0.0.0 -port 27015 -nocrashdialog -insecure -nohltv
fi
echo "If there was an error binding to an interface, you will need to start a virtual screen with: Xvfb :0&"
sleep 1s
reds
exit
}

reds() {
if [[ ! $(pgrep -a srcds.exe | grep port\ 27015) ]];then
	DISPLAY=:0 WINEPREFIX=$PWD WINEDEBUG=-all wine start ./drive_c/steamcmd/steamapps/common/Synergy/srcds.exe -console -game synergy +map d1_trainstation_06 +exec server2.cfg +maxplayers 16 +sv_lan 0 -ip 0.0.0.0 -port 27015 -nocrashdialog -insecure -nohltv
fi
sleep 1s
reds
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

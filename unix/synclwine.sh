#!/bin/bash
#Skip prompts, just install/start game you will still need to put in a Steam account for downloading.
skipprompts=n

missingdeps() {
echo "You are missing dependencies for Steam or other operations"
echo "Use $packageinf"
echo "Then restart this script."
if [ $skipprompts = "y" ];then exit ;fi
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
if [ $inststate == 3 ];then
	winestart
fi
if [ ! -f /usr/bin/wine ];then
	if [ $skipprompts = "n" ];then
		echo "Beginning with install of Wine. Press Enter to fully install Wine development branch. This user must have access to sudo apt for this to work. Press Ctrl+C to exit if you don't want to continue."
		read opt
	fi
	if [ $skipprompts = "y" ];then echo "Installing Wine..." ;fi
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
if [ ! -d ./drive_c ];then mkdir ./drive_c ;fi
if [ ! -d ./drive_c/steamcmd ];then mkdir ./drive_c/steamcmd ;fi
if [ ! -d ./drive_c/steamcmd/steamapps ];then mkdir ./drive_c/steamcmd/steamapps ;fi
if [ ! -d ./drive_c/steamcmd/steamapps/common ];then mkdir ./drive_c/steamcmd/steamapps/common ;fi
if [ ! -f ./drive_c/steamcmd/steamapps/common/Synergy/srcds.exe ];then
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +login $stusername +force_install_dir ./drive_c/steamcmd/steamapps/common/Synergy +app_update 17520 beta twitch -beta twitch validate +quit
fi
if [ ! -d ./drive_c/steamcmd/steamapps/common/Half-Life\ 2/hl2 ];then
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +login $stusername +force_install_dir ./drive_c/steamcmd/steamapps/common/Half-Life\ 2 +app_update 220 +app_update 380 +app_update 420 validate +quit
fi
if [ ! -d ./drive_c/steamcmd/steamapps/common/Synergy/synergy/addons ];then mkdir ./drive_c/steamcmd/steamapps/common/Synergy/synergy/addons ;fi
if [ ! -f ./drive_c/steamcmd/Steam.exe ];then
	wget -nv "https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe" -P ./drive_c/steamcmd
	if [ -f ./drive_c/steamcmd/SteamSetup.exe ];then
		echo "Installing Steam client for Steam server connection..."
		DISPLAY=:0 WINEPREFIX=$PWD WINEDEBUG=-all wine start ./drive_c/steamcmd/SteamSetup.exe /S /D=C:\\steamcmd
	fi
fi
winestart
}

winestart() {
DISPLAY=:0 WINEPREFIX=$PWD WINEDEBUG=-all wine start ./drive_c/steamcmd/steamapps/common/Synergy/synergy.exe -game synergy -steam -windowed -noborder -w 1920 -h 1080 -novid +r_hunkalloclightmaps 0 -threads 8 -heapsize 2048000 -mem_max_heapsize 2048 -mem_max_heapsize_dedicated 512
echo "If there was an error binding to an interface, you will need to start a virtual screen with: Xvfb :0&"
sleep 1s
echo "Press enter to start Synergy again. Or use Ctrl+C to close this script."
read continuescr
winestart
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

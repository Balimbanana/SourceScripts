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
if [ $inststate == 3 ];then
	if [[ ! $(pgrep -a Steam.exe) ]];then
		DISPLAY=:0 WINEPREFIX=$PWD WINEDEBUG=-all wine start ./drive_c/steamcmd/Steam.exe
	fi
	if [ ! -f ./drive_c/steamcmd/steamapps/common/Synergy/synergy/addons/metamod/sourcemod.vdf ];then
		echo "Would you like to install SourceMod? Y/n"
		read instsm
		if [ -z $instsm ];then instsm="y" ;fi
		instsm=${instsm,,}
		if [ $instsm = "y" ];then installsm ;fi
	fi
	if [ -f ./drive_c/steamcmd/steamapps/common/Synergy/synergy/addons/metamod/sourcemod.vdf ];then
		echo "Would you like to install plugins for SourceMod? y/N"
		read instsm
		if [ -z $instsm ];then instsm="n" ;fi
		instsm=${instsm,,}
		if [ $instsm = "y" ];then instsourceplugins ;fi
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
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +login $stusername +force_install_dir ./drive_c/steamcmd/steamapps/common/Synergy +app_update 17520 beta development -beta development validate +quit
fi
if [ ! -d ./drive_c/steamcmd/steamapps/common/Half-Life\ 2/hl2 ];then
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +login $stusername +force_install_dir ./drive_c/steamcmd/steamapps/common/Half-Life\ 2 +app_update 220 +app_update 380 +app_update 420 validate +quit
fi
if [ ! -d ./drive_c/steamcmd/steamapps/common/Synergy/synergy/addons ];then mkdir ./drive_c/steamcmd/steamapps/common/Synergy/synergy/addons ;fi
if [ $instsm = "y" ];then
	installsm
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

installsm() {
wget "https://sm.alliedmods.net/smdrop/1.11/sourcemod-latest-windows"
fullurlcat=https://sm.alliedmods.net/smdrop/1.11/$(cat ./sourcemod-latest-windows)
if [ ! -f ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./sourcemod-latest-windows) ];then
	wget "$fullurlcat" -P ./drive_c/steamcmd/steamapps/common/Synergy/synergy
fi
if [ -f ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./sourcemod-latest-windows) ];then
	unzip ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./sourcemod-latest-windows) -d ./drive_c/steamcmd/steamapps/common/Synergy/synergy
fi
wget "https://mms.alliedmods.net/mmsdrop/1.11/mmsource-latest-windows"
fullurlcat=https://mms.alliedmods.net/mmsdrop/1.11/$(cat ./mmsource-latest-windows)
if [ ! -f ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./mmsource-latest-windows) ];then
	wget "$fullurlcat" -P ./drive_c/steamcmd/steamapps/common/Synergy/synergy
fi
if [ -f ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./mmsource-latest-windows) ];then
	unzip ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./mmsource-latest-windows) -d ./drive_c/steamcmd/steamapps/common/Synergy/synergy
fi
if [ -f ./drive_c/steamcmd/steamapps/common/Synergy/synergy/addons/metamod.vdf ];then
	echo "MetaMod installed!"
	if [ -f ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./mmsource-latest-windows) ];then rm ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./mmsource-latest-windows) ;fi
fi
if [ -f ./drive_c/steamcmd/steamapps/common/Synergy/synergy/addons/metamod/sourcemod.vdf ];then
	echo "SourceMod installed!"
	if [ -f ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./sourcemod-latest-windows) ];then rm ./drive_c/steamcmd/steamapps/common/Synergy/synergy/$(cat ./sourcemod-latest-windows) ;fi
fi
if [ -f ./sourcemod-latest-windows ];then rm ./sourcemod-latest-windows ;fi
if [ -f ./mmsource-latest-windows ];then rm ./mmsource-latest-windows ;fi
}

noanon() {
echo "You cannot use anonymous to install Synergy..."
start
}

instsourceplugins() {
synpath=./drive_c/steamcmd/steamapps/common/Synergy/synergy
echo "Add SP to any of the following to get the sp file of each."
echo "(M) to download fixed MapChooser  (N) to download fixed Nominations"
echo "(ML) to download ModelLoader      (GT) to download Goto"
echo "(V) to download VoteCar           (HD) to download HealthDisplay"
echo "(HYP) to download HyperSpawn      (ST) to download Save/Teleport"
echo "(SYN) to download SynFixes        (SSR) to download SynSaveRestore"
echo "(ET) to download EntTools         (FPD) to download FirstPersonDeaths"
echo "(SM) to download SynModes         (AUTO) to download AutoChangeMap"
echo "(CR) to download Synergy CrashMap (U) to download Updater with SteamWorks"
echo "(SynDev) to download SynFixes Dev needed for Black Mesa entities"
echo "(SynSweps) to download Synergy Scripted Weapons also needed for BMS"
echo "Some plugins will also require their translation files, you can get a full pack of these plugins with (FP)"
echo "(B) to go back to start"
read pluginsubstr
pluginsubstr=${pluginsubstr,,}
if [ $pluginsubstr = "m" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/mapchooser.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/mapchooser.smx;fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/mapchooser.smx" -P ./$synpath/addons/sourcemod/plugins
	if [ ! -f ./$synpath/cfg/mapcyclecfg.txt ];then
		cat ./$synpath/mapcycle.txt | grep d1>./$synpath/cfg/mapcyclecfg.txt
		cat ./$synpath/mapcycle.txt | grep d2>>./$synpath/cfg/mapcyclecfg.txt
		cat ./$synpath/mapcycle.txt | grep d3>>./$synpath/cfg/mapcyclecfg.txt
		cat ./$synpath/mapcycle.txt | grep ep1_>>./$synpath/cfg/mapcyclecfg.txt
		cat ./$synpath/mapcycle.txt | grep ep2_>>./$synpath/cfg/mapcyclecfg.txt
	fi
	echo "Installed!"
fi
if [ $pluginsubstr = "n" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/nominations.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/nominations.smx;fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/nominations.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "msp" ];then
	rm -f ./$synpath/addons/sourcemod/scripting/mapchooser.sp
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/mapchooser.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "nsp" ];then
	rm -f ./$synpath/addons/sourcemod/scripting/nominations.sp
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/nominations.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "ml" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/modelloader.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/modelloader.smx;fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/modelloader.smx" -P ./$synpath/addons/sourcemod/plugins
	if [ ! -f ./$synpath/addons/sourcemod/translations/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/chi/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/chi/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/chi ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/ar/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/ar/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/ar ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/bg/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/bg/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/bg ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/cze/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/cze/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/cze ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/da/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/da/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/da ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/de/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/de/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/de ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/el/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/el/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/el ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/es/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/es/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/es ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/fi/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/fi/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/fi ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/fr/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/fr/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/fr ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/he/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/he/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/he ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/hu/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/hu/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/hu ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/it/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/it/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/it ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/jp/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/jp/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/jp ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/ko/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/ko/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/ko ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/lt/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/lt/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/lt ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/lv/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/lv/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/lv ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/nl/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/nl/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/nl ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/no/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/no/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/no ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/pl/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/pl/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/pl ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/pt/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/pt/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/pt ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/pt_p/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/pt_p/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/pt_p ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/ro/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/ro/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/ro ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/ru/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/ru/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/ru ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/sk/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/sk/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/sk ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/sv/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/sv/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/sv ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/tr/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/tr/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/tr ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/ua/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/ua/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/ua ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/zho/modelloader.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/zho/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/zho ;fi
	if [ -f ./$synpath/addons/sourcemod/translations/modelloader.phrases.txt ];then echo "Installed!";fi
fi
if [ $pluginsubstr = "mlsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/modelloader.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "gt" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/sm_goto.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "gtsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/sm_goto.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "v" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/votecar.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/votecar.smx;fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/votecar.smx" -P ./$synpath/addons/sourcemod/plugins
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/votecar.phrases.txt" -P ./$synpath/addons/sourcemod/translations
fi
if [ $pluginsubstr = "vsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/votecar.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "fp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/archive/master.zip" -P .
	unzip -qq ./master.zip -d ./$synpath/addons/sourcemod
	rm -rf ./$synpath/addons/sourcemod/SM-Synergy-master/56.16lin
	rm -rf ./$synpath/addons/sourcemod/SM-Synergy-master/devtwitchgamedata
	rm -rf ./$synpath/addons/sourcemod/SM-Synergy-master/twitchbranchgamedata
	rm -f ./$synpath/addons/sourcemod/SM-Synergy-master/healthdisplayupdater.txt
	rm -f ./$synpath/addons/sourcemod/SM-Synergy-master/enttoolsupdater.txt
	rm -f ./$synpath/addons/sourcemod/SM-Synergy-master/modelloaderupdater.txt
	rm -f ./$synpath/addons/sourcemod/SM-Synergy-master/synbhopupdater.txt
	rm -f ./$synpath/addons/sourcemod/SM-Synergy-master/synmodesupdater.txt
	rm -f ./$synpath/addons/sourcemod/SM-Synergy-master/synfixesupdater.txt
	rm -f ./$synpath/addons/sourcemod/SM-Synergy-master/synsaverestoreupdater.txt
	rm -f ./$synpath/addons/sourcemod/SM-Synergy-master/synvehiclespawnupdater.txt
	rsync --remove-source-files -a ./$synpath/addons/sourcemod/SM-Synergy-master/* ./$synpath/addons/sourcemod
	rm -f ./master.zip
	rm -rf ./$synpath/addons/sourcemod/SM-Synergy-master
	echo "Installed!"
fi
if [ $pluginsubstr = "hd" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/healthdisplay.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/healthdisplay.smx;fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/healthdisplay.smx" -P ./$synpath/addons/sourcemod/plugins
	if [ ! -f ./$synpath/addons/sourcemod/translations/healthdisplay.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/healthdisplay.phrases.txt" -P ./$synpath/addons/sourcemod/translations ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/colors.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/colors.phrases.txt" -P ./$synpath/addons/sourcemod/translations ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/ru/healthdisplay.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/ru/healthdisplay.phrases.txt" -P ./$synpath/addons/sourcemod/translations/ru ;fi
	if [ ! -f ./$synpath/addons/sourcemod/translations/ru/colors.phrases.txt ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/ru/colors.phrases.txt" -P ./$synpath/addons/sourcemod/translations/ru ;fi
fi
if [ $pluginsubstr = "hdsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/healthdisplay.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "hyp" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/hyperspawn.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/hyperspawn.smx;fi
	wget -nv "https://github.com/Sarabveer/SM-Plugins/raw/master/hyperspawn/plugins/hyperspawn.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "hypsp" ];then
	wget -nv "https://github.com/Sarabveer/SM-Plugins/raw/master/hyperspawn/scripting/hyperspawn.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "st" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/syn_tp.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/syn_tp.smx;fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/syn_tp.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "stsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/syn_tp.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "syn" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/synfixes.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/synfixes.smx;fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/synfixes.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "synsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/synfixes.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "ssr" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/synsaverestore.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/synsaverestore.smx;fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/synsaverestore.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "ssrsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/synsaverestore.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "et" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/enttools.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/enttools.smx;fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/enttools.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "etsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/enttools.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "fpd" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/fpd.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/fpd.smx;fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/fpd.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "fpdsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/fpd.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "sm" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/synmodes.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/synmodes.smx;fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/synmodes.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "smsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/fpd.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "auto" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/autochangemap.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/autochangemap.smx;fi
	wget -nv "http://www.sourcemod.net/vbcompiler.php?file_id=23997" -P ./$synpath/addons/sourcemod/plugins
	if [ -f ./$synpath/addons/sourcemod/plugins/vbcompiler.php\?file_id\=23997 ];then mv ./$synpath/addons/sourcemod/plugins/vbcompiler.php\?file_id\=23997 ./$synpath/addons/sourcemod/plugins/autochangemap.smx ;fi
fi
if [ $pluginsubstr = "autosp" ];then
	wget -nv "https://forums.alliedmods.net/attachment.php?attachmentid=23997&d=1203936191" -P ./$synpath/addons/sourcemod/scripting
	if [ -f ./$synpath/addons/sourcemod/scripting/attachment.php\?attachmentid\=23997\&d\=1203936191 ];then mv ./$synpath/addons/sourcemod/scripting/attachment.php\?attachmentid\=23997\&d\=1203936191 ./$synpath/addons/sourcemod/scripting/autochangemap.sp ;fi
fi
if [ $pluginsubstr = "cr" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/crashmap.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/crashmap.smx;fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/crashmap.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "crsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/crashmap.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "synsweps" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/synsweps.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/synsweps.smx;fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/synsweps.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "synswepssp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/synsweps.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "syndev" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/synfixesdev.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/synfixesdev.smx;fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/synfixesdev.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "syndevsp" ];then
	echo "Too many includes to list here, check on GitHub"
fi
if [ $pluginsubstr = "u" ];then
	if [ -f ./$synpath/addons/sourcemod/plugins/updater.smx ];then rm -f ./$synpath/addons/sourcemod/plugins/updater.smx;fi
	wget -nv "https://bitbucket.org/GoD_Tony/updater/downloads/updater.smx" -P ./$synpath/addons/sourcemod/plugins
	if [ -f ./$synpath/addons/sourcemod/extensions/SteamWorks.ext.so ];then rm -f ./$synpath/addons/sourcemod/extensions/SteamWorks.ext.so;fi
	curl -sqL "https://users.alliedmods.net/~kyles/builds/SteamWorks/SteamWorks-git121-linux.tar.gz" | tar zxvf - -C ./$synpath
	if [ -f ./$synpath/addons/sourcemod/extensions/SteamWorks.ext.so ];then echo "Installed SteamWorks";fi
	if [ -f ./$synpath/addons/sourcemod/plugins/updater.smx ];then echo "Installed Updater";fi
fi
if [ $pluginsubstr = "b" ];then start;fi
instsourceplugins
}

start

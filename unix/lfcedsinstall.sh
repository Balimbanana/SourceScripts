#!/bin/bash
cldir=$HOME/.Steam/steamapps
if [ ! -d $cldir ]; then
	if [ -d /Steam/steamapps ]; then cldir=/Steam/steamapps ;fi
	if [ -d $HOME/.local/share/Steam/steamapps ]; then cldir=$HOME/.local/share/Steam/steamapps ;fi
	if [ -d $HOME/Steam/steamapps ]; then cldir=$HOME/Steam/steamapps ;fi
	if [ -d $HOME/steam/steamapps ]; then cldir=$HOME/steam/steamapps ;fi
	if [ -d $HOME/.steam/steamapps ]; then cldir=$HOME/.steam/steamapps ;fi
	if [ -d $HOME/.steam/steam/steamapps ]; then cldir=$HOME/.steam/steam/steamapps ;fi
	if [ -d $HOME/Library/Application\ Support/Steam/SteamApps ]; then cldir=$HOME/Library/Application\ Support/Steam/SteamApps ;fi
	if [ $cldir == $PWD ]; then cldir=none ;fi
	if [ ! -d $cldir ]; then cldir=none ;fi
fi

missingdeps() {
echo "You are missing dependencies for Steam"
echo "Use $packageinf"
echo "Then restart this script."
echo "Press enter to exit script"
read nullptr
exit
}

if [ -f /usr/bin/dpkg-query ];then
	if [[ ! $(dpkg-query -l lib32gcc1) ]] && [[ $(arch | grep 64) ]];then
		if [[ $(cat /etc/os-release | grep ID=ubuntu) ]];then
			if [[ $(cat /etc/os-release | grep VERSION_ID=\"22) ]];then
				if [[ ! $(dpkg-query -l lib32gcc-s1) ]];then
					packageinf="Use sudo apt-get install lib32gcc-s1"
					missingdeps
				fi
			else
				packageinf="Use sudo apt-get install lib32gcc1"
				missingdeps
			fi
		else
			packageinf="Use your package manager to install lib32gcc1"
			missingdeps
		fi
	fi
	if [[ ! $(dpkg-query -l libgcc1) ]] && [[ ! $(arch | grep 64) ]];then
		if [[ $(cat /etc/os-release | grep ID=ubuntu) ]];then
			packageinf="Use sudo apt-get install libgcc1"
			missingdeps
		else
			packageinf="Use your package manager to install libgcc1"
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

if [ ! -f /usr/bin/git ];then
	echo "You need to install git using: sudo apt install git or your environment's equivalent."
	exit
fi

updatescr() {
if [ ! -d ./tmpupd ]; then mkdir tmpupd ;fi
cd ./tmpupd
if [ -f ./lfcedsinstall.sh ]; then rm ./lfcedsinstall.sh ;fi
wget "https://github.com/Balimbanana/SourceScripts/raw/master/unix/lfcedsinstall.sh"
if [ -f ./lfcedsinstall.sh ]; then
	chmod +x ./lfcedsinstall.sh
	rm ../lfcedsinstall.sh
	mv ./lfcedsinstall.sh ../lfcedsinstall.sh
	cd ..
	echo "Updated..."
	rm -rf ./tmpupd
	./lfcedsinstall.sh
	exit
fi
echo "Failed to update..."
start
}

start() {
anonset=0
instsmset=0
if [ $PWD == $HOME/Steam ]; then
	cd ..
	if [ ! -d ./SteamCMD ]; then
		mkdir ./SteamCMD
	fi
	cd ./SteamCMD
fi
if [ ! -f ./steamcmd.sh ];then notindir; fi
echo
echo "Information: enter the letter inside the () and press enter to continue at the prompts."
echo "First (I)nstall, (U)pdate, (R)un with auto-restart"
echo "(IS) to install SourceMod."
if [ -f ./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server/fc/addons/sourcemod/configs/admins_simple.ini ]; then
	echo "(SMADMIN) to modify your SourceMod admins file."
fi
echo "(IHL2) (IEp1) (IEp2) to install/update HL2 Ep1 or Ep2. (IMods) to install Steam source mods and supports."
echo "(update) to update FC from Git."
echo "(updatescr) to update this script."
read uprun
uprun=${uprun,,}
if [ -z $uprun ];then uprun="noneselected" ;fi
if [ $uprun = "u" ]; then firstinstall;fi
if [ $uprun = "i" ]; then firstinstall;fi
if [ $uprun = "rb" ]; then srcds;fi
if [ $uprun = "rt" ]; then srcds;fi
if [ $uprun = "r" ]; then srcds;fi
if [ $uprun = "is" ]; then instsourcem;fi
if [ $uprun = "linksm" ]; then linksm;fi
if [ $uprun = "smadmin" ]; then modifysmadmin;fi
if [ $uprun = "ihl2" ]; then updhl2;fi
if [ $uprun = "iep1" ]; then updep1;fi
if [ $uprun = "iep2" ]; then updep2;fi
if [ $uprun = "imods" ]; then updmods;fi
if [ $uprun = "updatescr" ]; then updatescr;fi
if [ $uprun = "updatedev" ]; then updatedevgit;fi
if [ $uprun = "update" ]; then updategit;fi
echo "Choose an option."
start
}

updategit() {
if [ ! -d ./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server ];then firstinstall;fi
if [ ! -d ./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server/fc ];then 
	git -C ./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server clone --depth 1 "https://github.com/Lambdagon/fc.git"
else
	cd ./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server/fc
	git reset --hard
 	#git checkout main
	git pull
	cd ../../../..
fi
if [ $uprun = "i" ];then setup;fi
start
}

updatedevgit() {
if [ ! -d ./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server ];then firstinstall;fi
if [ ! -d ./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server/fc ];then 
	git -C ./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server clone --depth 1 "https://github.com/Lambdagon/fc.git"
else
	cd ./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server/fc
	git reset --hard
 	#git checkout dev
	git pull
	cd ../../../..
fi
if [ $uprun = "i" ];then setup;fi
start
}

inststeam() {
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
if [ ! -f ./steamcmd.sh ]; then
	echo "Something went wrong in downloading/extracting SteamCMD"
fi
start
}

instsourcem() {
lfcepath=steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server/fc
if [ ! -d "./$lfcepath" ];then notinstalled;fi
echo "This will direct download the required SourceMod files and then extract them."
if [ -d "./$lfcepath/addons/sourcemod/bin/sourcemod_mm.so" ];then
	echo "SourceMod is already installed, if you want to re-install, rename the current SourceMod install and re-run this script."
	read nullptr
	start
fi
curl -sqL "https://sm.alliedmods.net/smdrop/1.11/sourcemod-1.11.0-git6569-linux.tar.gz" | tar zxvf - -C "./$lfcepath"
curl -sqL "https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1130-linux.tar.gz" | tar zxvf - -C "./$lfcepath"
curl -sqL "https://users.alliedmods.net/~kyles/builds/SteamWorks/SteamWorks-git131-linux.tar.gz" | tar zxvf - -C "./$lfcepath"
#tar zxvf ./$lfcepath/addons/SM1.12-128\ Linux.tar.bz2 -C ./lfcepath/addons
if [ ! -d "./$lfcepath/addons/sourcemod" ];then
	echo "Failed to auto-install SourceMod, you may have to manually install it."
	read nullptr
	start
fi
if [ ! -f "./$lfcepath/addons/sourcemod/configs/admins_simple.ini" ];then cp ./$lfcepath/addons/sourcemod/configs/admins_simple_sample.ini ./$lfcepath/addons/sourcemod/configs/admins_simple.ini ;fi
if [ ! -f "./$lfcepath/addons/sourcemod/configs/databases.cfg" ];then cp ./$lfcepath/addons/sourcemod/configs/databases_sample.cfg ./$lfcepath/addons/sourcemod/configs/databases.cfg ;fi
if [ -f "./$lfcepath/addons/metamod_x64.vdf" ];then rm "./$lfcepath/addons/metamod_x64.vdf" ;fi
if [ -d "./$lfcepath/addons/metamod/bin/linux64" ]; then rm -rf "./$lfcepath/addons/metamod/bin/linux64" ;fi
if [ -d "./$lfcepath/addons/sourcemod/bin/x64" ]; then rm -rf "./$lfcepath/addons/sourcemod/bin/x64" ;fi
if [ -f "./$lfcepath/addons/sourcemod/plugins/updater.smx" ];then wget -nv "https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/addons/sourcemod/plugins/updater.smx" -P "./$lfcepath/addons/sourcemod/plugins" ;fi
# remove nextmap as it does not work in almost all games I have ever tried it on
rm -f "./$lfcepath/addons/sourcemod/plugins/nextmap.smx"
if [ ! -f "./$lfcepath/addons/sourcemod/extensions/dhooks.ext.so" ];then wget -nv "https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/addons/sourcemod/extensions/dhooks.ext.so" -P "./$lfcepath/addons/sourcemod/extensions" ;fi
echo "SourceMod installed, you can put plugins in ./$lfcepath/addons/sourcemod/plugins"
if [ $instsmset = "y" ];then srcds;fi
start
}

linksm() {
echo Linking.
if [ ! -d ./steamapps/common/Half-Life\ 2 ];then
	if [ -d $cldir/common/Half-Life\ 2 ];then
		ln -s $cldir/common/Half-Life\ 2 ./steamapps/common/Half-Life\ 2
		echo found cldir hl2
	fi
fi
if [ ! -d ./steamapps/sourcemods ];then
	if [ -d "$cldir/sourcemods" ];then
		ln -s $cldir/sourcemods ./steamapps/sourcemods
		echo found cldir sm
	fi
fi
echo $cldir
start
}

notindir() {
echo "This script is not being run from the SteamCMD directory"
echo "You can download SteamCMD by entering the directory you want to install it to,"
echo "or enter the full directory path where SteamCMD is here:"
echo "If you don't enter anything, it will install to where this script is being run."
read changedir
if [[ ${changedir:0:1} == "~" ]]; then
	changedir=$(echo $changedir | sed 's/.//1')
	changedir=$(echo $changedir | sed 's/.//1')
	changedir=$HOME/$changedir
	echo $changedir
fi
if [[ ${changedir:0:1} == "" ]];then
	changedir=.
	inststeam
fi
cd $changedir
if [ -f $changedir/steamcmd.sh ]; then
	start
else
	echo "Couldn't find SteamCMD in $changedir would you like to install SteamCMD here?"
	echo "y/N"
	read promptyn
	promptyn=${promptyn,,}
	if [ $promptyn = "y" ]; then
		inststeam
	else
		notindir
	fi
fi
}

firstinstall() {
lfcepath=./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server
echo "Updating/installing Source SDK Base 2013 Dedicated Server"
./steamcmd.sh +force_install_dir "./steamapps/common/Source SDK Base 2013 Dedicated Server" +login anonymous +app_update 244310 -beta public validate +quit
echo "Update/installation Complete"
echo "If there were errors above, close the script and log in to steamcmd.sh separately, then restart the script."
if [ ! -f "$lfcepath/hl2/hl2_misc_dir.vpk" ]; then
	echo "Failed to install"
	start
fi
echo "Updating/installing Team Fortress 2 Dedicated Server"
./steamcmd.sh +force_install_dir "./steamapps/common/Team Fortress 2 Dedicated Server" +login anonymous +app_update 232250 -beta public validate +quit
echo "Update/installation Complete"
updategit
if [ $uprun = "i" ];then setup;fi
srcds
}

noanon() {
if [ $anonset = 0 ];then echo "You cannot use anonymous to install this tool...";fi
if [ $anonset = 2 ];then
	echo "You cannot use anonymous to install HL2..."
	stusername=""
	anonset=0
	insthl2
fi
anonset=1
firstinstall
}

setup() {
s=1
hl=1
echo "Setting up links and first settings in server2.cfg"
if [ ! -d "$cldir/sourcemods" ];then s=0;fi
if [ ! -d "$cldir/common/Half-Life\ 2/hl2" ];then hl=0;fi
if [ hl = 0 ];then if [ -d ./steamapps/common/Half-Life\ 2/hl2 ];then hl=2;fi;fi
if [ hl = 0 ];then insthl2;fi
if [ hl = 1 ];then ln -s $cldir/common/Half-Life\ 2 ./steamapps/common/Half-Life\ 2;fi
if [ s = 0 ];then echo "sourcemods not found, not linking.";fi
if [ s = 1 ];then ln -s $cldir/sourcemods ./steamapps/sourcemods;fi
lfcepath=./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server
if [ ! -f "./$lfcepath/fc/cfg/server2.cfg" ];then
	echo hostname FC Linux Server>"$lfcepath/fc/cfg/server2.cfg"
	echo sv_lan 0 >>"$lfcepath/fc/cfg/server2.cfg"
	echo mp_friendlyfire 0 >>"$lfcepath/fc/cfg/server2.cfg"
	echo //Reloads the map when all players die>>"$lfcepath/fc/cfg/server2.cfg"
	echo mp_reset 1 >>"$lfcepath/fc/cfg/server2.cfg"
	echo mp_transition_time 45 >>"$lfcepath/fc/cfg/server2.cfg"
	echo mp_transition_percent 68 >>"$lfcepath/fc/cfg/server2.cfg"
	echo sv_vote_enable 1 >>"$lfcepath/fc/cfg/server2.cfg"
	echo sv_vote_failure_timer 300 >>"$lfcepath/fc/cfg/server2.cfg"
	echo sv_vote_interval 10 >>"$lfcepath/fc/cfg/server2.cfg"
	echo sv_vote_percent_difficulty 67 >>"$lfcepath/fc/cfg/server2.cfg"
	echo sv_vote_percent_kick 67 >>"$lfcepath/fc/cfg/server2.cfg"
	echo sv_vote_percent_map 67 >>"$lfcepath/fc/cfg/server2.cfg"
	echo sv_vote_percent_restore 67 >>"$lfcepath/fc/cfg/server2.cfg"
	echo //Change this to a different savenumber for forked servers>>"$lfcepath/fc/cfg/server2.cfg"
	echo sv_savedir save2/>>"$lfcepath/fc/cfg/server2.cfg"
fi
echo "Should be all configured for server running."
echo "Would you like to edit your server config? (y/N)"
read editconf
if [ -z $editconf ];then editconf="noneselected" ;fi
editconf=${editconf,,}
if [ $editconf = "y" ];then
	if [ ! -z $EDITOR ];then
		$EDITOR "$lfcepath/fc/cfg/server2.cfg"
	elif [ ! -z $VISUAL ];then
		$VISUAL "$lfcepath/fc/cfg/server2.cfg"
	elif [ -f /bin/nano ];then
		nano "$lfcepath/fc/cfg/server2.cfg"
	elif [ -f /usr/bin/gedit ];then
		gedit "$lfcepath/fc/cfg/server2.cfg"
	else
		vi "$lfcepath/fc/cfg/server2.cfg"
	fi
fi
echo "Would you like to install SourceMod? (y/N)"
read instsmset
if [ -z $instsmset ];then instsmset="noneselected" ;fi
instsmset=${instsmset,,}
if [ $instsmset = "y" ];then instsourcem;fi
echo "Starting server..."
srcds
}

srcds() {
lfcepath=steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server
if [ ! -f "./$lfcepath/srcds_run" ];then notinstalled;fi
if [ ! -d ./steamapps/common/Half-Life\ 2/hl2 ];then insthl2;fi
if [ ! -L "./$lfcepath/bin/libtier0.so" ];then
	mv "./$lfcepath/bin/libtier0.so" "./$lfcepath/bin/libtier0.so.bak"
	ln -s libtier0_srv.so "./$lfcepath/bin/libtier0.so"
fi
if [ ! -L "./$lfcepath/bin/libvstdlib.so" ];then
	mv "./$lfcepath/bin/libvstdlib.so" "./$lfcepath/bin/libvstdlib.so.bak"
	ln -s libvstdlib_srv.so "./$lfcepath/bin/libvstdlib.so"
fi
if [ ! -f "./$lfcepath/bin/soundemittersystem.so" ];then
	cp "./$lfcepath/bin/soundemittersystem_srv.so" "./$lfcepath/bin/soundemittersystem.so"
fi
if [ ! -f "./$lfcepath/bin/scenefilecache.so" ];then
	cp "./$lfcepath/bin/scenefilecache_srv.so" "./$lfcepath/bin/scenefilecache.so"
fi
if [ ! -f "./$lfcepath/bin/datacache.so" ];then
	cp "./$lfcepath/bin/datacache_srv.so" "./$lfcepath/bin/datacache.so"
fi
reds
}

reds() {
curdatetime=$(date -u)
echo "$curdatetime LFCEDS started."
"./$lfcepath/srcds_run" -game fc -console -norestart -maxplayers 32 +sv_lan 0 +map d1_trainstation_06 +exec server2.cfg -ip 0.0.0.0 -port 27015 -nocrashdialog -nohltv
curdatetime=$(date -u)
echo "$curdatetime WARNING: LFCEDS closed or crashed, restarting."
sleep 1
reds
}

notinstalled() {
echo "Lambda Fortress Community Edition is not installed..."
start
}

insthl2() {
echo "Half-Life 2 was not found during setup, press enter to install it, or close the script and install it manually."
echo "You can also install Ep1 with 1, Ep2 with 2 (will also install Ep1 and HL2), or 3 for HL2, Ep1, Ep2, Lost Coast, and Half-Life Source."
read hllist
hllist=${hllist,,}
re='^[0-9]+$'
if [ -z $hllist ];then hllist=0 ;fi
if ! [[ $hllist =~ $re ]];then hllist=0 ;fi
if [ -z $stusername ];then
	echo "Enter your username here:"
	read stusername
	anonset=2
	anonblck=${stusername,,}
	if [ $anonblck = "anonymous" ];then noanon;fi
fi
./steamcmd.sh +force_install_dir ./steamapps/common/Half-Life\ 2 +login $stusername +app_update 220 validate +quit
if [ $hllist > 2 ];then
	./steamcmd.sh +force_install_dir ./steamapps/common/Half-Life\ 2 +login $stusername +app_update 280 validate +quit
	./steamcmd.sh +force_install_dir ./steamapps/common/Half-Life\ 2 +login $stusername +app_update 340 validate +quit
fi
if [ $hllist > 0 ];then
	./steamcmd.sh +force_install_dir ./steamapps/common/Half-Life\ 2 +login $stusername +app_update 380 validate +quit
fi
if [ $hllist > 1 ];then
	./steamcmd.sh +force_install_dir ./steamapps/common/Half-Life\ 2 +login $stusername +app_update 420 validate +quit
fi
if [ -d ./steamapps/common/Half-Life\ 2 ];then setup;fi
echo "Something went wrong with installing HL2, restarting script."
start
}

updhl2() {
if [ -z $stusername ];then
	echo "Enter your username here:"
	read stusername
	anonset=2
	anonblck=${stusername,,}
	if [ $anonblck = "anonymous" ];then noanon;fi
fi
./steamcmd.sh +force_install_dir ./steamapps/common/Half-Life\ 2 +login $stusername +app_update 220 validate +quit
start
}

updep1() {
if [ -z $stusername ];then
	echo "Enter your username here:"
	read stusername
	anonset=2
	anonblck=${stusername,,}
	if [ $anonblck = "anonymous" ];then noanon;fi
fi
./steamcmd.sh +force_install_dir ./steamapps/common/Half-Life\ 2 +login $stusername +app_update 380 validate +quit
start
}

updep2() {
if [ -z $stusername ];then
	echo "Enter your username here:"
	read stusername
	anonset=2
	anonblck=${stusername,,}
	if [ $anonblck = "anonymous" ];then noanon;fi
fi
./steamcmd.sh +force_install_dir ./steamapps/common/Half-Life\ 2 +login $stusername +app_update 420 validate +quit
start
}

updmods() {
echo "Install Steam released mods to be used in LFCE."
echo "(yla) Year Long Alarm     (amal) Amalgam"
echo "(pros) Prospekt           (df) DownFall"
echo "(ezero) Entropy Zero      (portal) Portal"
echo "b for back to start"
read instmod
if [ -z $instmod ];then instmod=none ;fi
if [ $instmod = "b" ];then start ;fi
if [ -z $stusername ];then
	echo "Enter your username here:"
	read stusername
	anonset=2
	anonblck=${stusername,,}
	if [ $anonblck = "anonymous" ];then noanon;fi
fi
if [ $instmod = "none" ];then updmods ;fi
if [ $instmod = "yla" ];then
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir "./steamapps/common/Half-Life 2 Year Long Alarm" +login $stusername +app_update 747250 validate +quit
fi
if [ $instmod = "amal" ];then
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir ./steamapps/common/Amalgam +login $stusername +app_update 1389950 validate +quit
fi
if [ $instmod = "df" ];then
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir "./steamapps/common/Half-Life 2 DownFall" +login $stusername +app_update 587650 validate +quit
fi
if [ $instmod = "pros" ];then
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir ./steamapps/common/Prospekt +login $stusername +app_update 399120 validate +quit
fi
if [ $instmod = "ezero" ];then
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir "./steamapps/common/Entropy Zero" +login $stusername +app_update 714070 validate +quit
fi
if [ $instmod = "portal" ];then
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir "./steamapps/common/Portal" +login $stusername +app_update 400 validate +quit
fi
updmods
}

instsourcepluginstop() {
lfcepath=./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server/fc
if [ ! -d "$lfcepath" ];then notinstalled;fi
instsourceplugins
}

instsourceplugins() {
echo "Add SP to any of the following to get the sp file of each."
echo "(M) to download fixed MapChooser  (N) to download fixed Nominations"
echo "(ML) to download ModelLoader      (GT) to download Goto"
echo "(ET) to download EntTools         (FPD) to download FirstPersonDeaths"
echo "(CR) to download CrashMap         (U) to download Updater with SteamWorks"
echo "(AUTO) to download AutoChangeMap  (HD) to download HealthDisplay"
echo "(ST) to download Save/Teleport    (SSR) to download SynSaveRestore"
echo "(B) to go back to start"
read pluginsubstr
pluginsubstr=${pluginsubstr,,}
if [ $pluginsubstr = "m" ];then
	if [ -f "./$lfcepath/addons/sourcemod/plugins/mapchooser.smx" ];then rm -f "./$lfcepath/addons/sourcemod/plugins/mapchooser.smx";fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/mapchooser.smx" -P "./$lfcepath/addons/sourcemod/plugins"
	if [ ! -f "./$lfcepath/cfg/mapcyclecfg.txt" ];then
		cat "./$lfcepath/mapcycle.txt" | grep d1>"./$lfcepath/cfg/mapcyclecfg.txt"
		cat "./$lfcepath/mapcycle.txt" | grep d2>>"./$lfcepath/cfg/mapcyclecfg.txt"
		cat "./$lfcepath/mapcycle.txt" | grep d3>>"./$lfcepath/cfg/mapcyclecfg.txt"
		cat "./$lfcepath/mapcycle.txt" | grep ep1_>>"./$lfcepath/cfg/mapcyclecfg.txt"
		cat "./$lfcepath/mapcycle.txt" | grep ep2_>>"./$lfcepath/cfg/mapcyclecfg.txt"
	fi
	echo "Installed!"
fi
if [ $pluginsubstr = "n" ];then
	if [ -f "./$lfcepath/addons/sourcemod/plugins/nominations.smx" ];then rm -f "./$lfcepath/addons/sourcemod/plugins/nominations.smx";fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/nominations.smx" -P "./$lfcepath/addons/sourcemod/plugins"
fi
if [ $pluginsubstr = "msp" ];then
	rm -f "./$lfcepath/addons/sourcemod/scripting/mapchooser.sp"
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/mapchooser.sp" -P "./$lfcepath/addons/sourcemod/scripting"
fi
if [ $pluginsubstr = "nsp" ];then
	rm -f "./$lfcepath/addons/sourcemod/scripting/nominations.sp"
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/nominations.sp" -P "./$lfcepath/addons/sourcemod/scripting"
fi
if [ $pluginsubstr = "ml" ];then
	if [ -f "./$lfcepath/addons/sourcemod/plugins/modelloader.smx" ];then rm -f "./$lfcepath/addons/sourcemod/plugins/modelloader.smx";fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/modelloader.smx" -P "./$lfcepath/addons/sourcemod/plugins"
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/chi/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/chi/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/chi" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/ar/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/ar/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/ar" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/bg/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/bg/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/bg" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/cze/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/cze/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/cze" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/da/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/da/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/da" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/de/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/de/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/de" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/el/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/el/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/el" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/es/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/es/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/es" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/fi/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/fi/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/fi" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/fr/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/fr/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/fr" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/he/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/he/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/he" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/hu/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/hu/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/hu" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/it/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/it/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/it" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/jp/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/jp/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/jp" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/ko/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/ko/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/ko" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/lt/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/lt/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/lt" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/lv/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/lv/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/lv" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/nl/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/nl/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/nl" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/no/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/no/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/no" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/pl/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/pl/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/pl" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/pt/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/pt/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/pt" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/pt_p/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/pt_p/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/pt_p" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/ro/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/ro/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/ro" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/ru/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/ru/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/ru" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/sk/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/sk/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/sk" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/sv/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/sv/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/sv" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/tr/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/tr/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/tr" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/ua/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/ua/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/ua" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/zho/modelloader.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/zho/modelloader.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/zho" ;fi
	if [ -f "./$lfcepath/addons/sourcemod/translations/modelloader.phrases.txt" ];then echo "Installed!";fi
fi
if [ $pluginsubstr = "mlsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/modelloader.sp" -P "./$lfcepath/addons/sourcemod/scripting"
fi
if [ $pluginsubstr = "gt" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/sm_goto.smx" -P "./$lfcepath/addons/sourcemod/plugins"
fi
if [ $pluginsubstr = "gtsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/sm_goto.sp" -P "./$lfcepath/addons/sourcemod/scripting"
fi
if [ $pluginsubstr = "hd" ];then
	if [ -f "./$lfcepath/addons/sourcemod/plugins/healthdisplay.smx" ];then rm -f "./$lfcepath/addons/sourcemod/plugins/healthdisplay.smx";fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/healthdisplay.smx" -P "./$lfcepath/addons/sourcemod/plugins"
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/healthdisplay.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/healthdisplay.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/colors.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/colors.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/ru/healthdisplay.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/ru/healthdisplay.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/ru" ;fi
	if [ ! -f "./$lfcepath/addons/sourcemod/translations/ru/colors.phrases.txt" ];then wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/ru/colors.phrases.txt" -P "./$lfcepath/addons/sourcemod/translations/ru" ;fi
fi
if [ $pluginsubstr = "hdsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/healthdisplay.sp" -P "./$lfcepath/addons/sourcemod/scripting"
fi
if [ $pluginsubstr = "st" ];then
	if [ -f "./$lfcepath/addons/sourcemod/plugins/syn_tp.smx" ];then rm -f "./$lfcepath/addons/sourcemod/plugins/syn_tp.smx";fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/syn_tp.smx" -P "./$lfcepath/addons/sourcemod/plugins"
fi
if [ $pluginsubstr = "stsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/syn_tp.sp" -P "./$lfcepath/addons/sourcemod/scripting"
fi
if [ $pluginsubstr = "ssr" ];then
	if [ -f "./$lfcepath/addons/sourcemod/plugins/synsaverestore.smx" ];then rm -f "./$lfcepath/addons/sourcemod/plugins/synsaverestore.smx";fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/synsaverestore.smx" -P "./$lfcepath/addons/sourcemod/plugins"
fi
if [ $pluginsubstr = "ssrsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/synsaverestore.sp" -P "./$lfcepath/addons/sourcemod/scripting"
fi
if [ $pluginsubstr = "et" ];then
	if [ -f "./$lfcepath/addons/sourcemod/plugins/enttools.smx" ];then rm -f "./$lfcepath/addons/sourcemod/plugins/enttools.smx";fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/enttools.smx" -P "./$lfcepath/addons/sourcemod/plugins"
fi
if [ $pluginsubstr = "etsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/enttools.sp" -P "./$lfcepath/addons/sourcemod/scripting"
fi
if [ $pluginsubstr = "fpd" ];then
	if [ -f "./$lfcepath/addons/sourcemod/plugins/fpd.smx" ];then rm -f "./$lfcepath/addons/sourcemod/plugins/fpd.smx";fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/fpd.smx" -P "./$lfcepath/addons/sourcemod/plugins"
fi
if [ $pluginsubstr = "fpdsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/fpd.sp" -P "./$lfcepath/addons/sourcemod/scripting"
fi
if [ $pluginsubstr = "auto" ];then
	if [ -f "./$lfcepath/addons/sourcemod/plugins/autochangemap.smx" ];then rm -f "./$lfcepath/addons/sourcemod/plugins/autochangemap.smx";fi
	wget -nv "http://www.sourcemod.net/vbcompiler.php?file_id=23997" -P "./$lfcepath/addons/sourcemod/plugins"
	if [ -f "./$lfcepath/addons/sourcemod/plugins/vbcompiler.php\?file_id\=23997" ];then mv "./$lfcepath/addons/sourcemod/plugins/vbcompiler.php\?file_id\=23997" "./$lfcepath/addons/sourcemod/plugins/autochangemap.smx" ;fi
fi
if [ $pluginsubstr = "autosp" ];then
	wget -nv "https://forums.alliedmods.net/attachment.php?attachmentid=23997&d=1203936191" -P "./$lfcepath/addons/sourcemod/scripting"
	if [ -f "./$lfcepath/addons/sourcemod/scripting/attachment.php\?attachmentid\=23997\&d\=1203936191" ];then mv "./$lfcepath/addons/sourcemod/scripting/attachment.php\?attachmentid\=23997\&d\=1203936191" "./$lfcepath/addons/sourcemod/scripting/autochangemap.sp" ;fi
fi
if [ $pluginsubstr = "cr" ];then
	if [ -f "./$lfcepath/addons/sourcemod/plugins/crashmap.smx" ];then rm -f "./$lfcepath/addons/sourcemod/plugins/crashmap.smx";fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/crashmap.smx" -P "./$lfcepath/addons/sourcemod/plugins"
fi
if [ $pluginsubstr = "crsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/crashmap.sp" -P "./$lfcepath/addons/sourcemod/scripting"
fi
if [ $pluginsubstr = "u" ];then
	if [ -f "./$lfcepath/addons/sourcemod/plugins/updater.smx" ];then rm -f "./$lfcepath/addons/sourcemod/plugins/updater.smx";fi
	wget -nv "https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/addons/sourcemod/plugins/updater.smx" -P "./$lfcepath/addons/sourcemod/plugins"
	if [ -f "./$lfcepath/addons/sourcemod/extensions/SteamWorks.ext.so" ];then rm -f "./$lfcepath/addons/sourcemod/extensions/SteamWorks.ext.so";fi
	curl -sqL "https://users.alliedmods.net/~kyles/builds/SteamWorks/SteamWorks-git121-linux.tar.gz" | tar zxvf - -C "./$lfcepath"
	if [ -f "./$lfcepath/addons/sourcemod/extensions/SteamWorks.ext.so" ];then echo "Installed SteamWorks";fi
	if [ -f "./$lfcepath/addons/sourcemod/plugins/updater.smx" ];then echo "Installed Updater";fi
fi
if [ $pluginsubstr = "b" ];then start;fi
instsourceplugins
}

modifysmadmin() {
if [ ! -f "./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server/fc/addons/sourcemod/configs/admins_simple.ini" ]; then
	echo "You do not have an admins file."
	start
fi
if [ ! -z $EDITOR ];then
	$EDITOR ./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server/fc/addons/sourcemod/configs/admins_simple.ini
elif [ ! -z $VISUAL ];then
	$VISUAL ./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server/fc/addons/sourcemod/configs/admins_simple.ini
elif [ -f /bin/nano ];then
	nano ./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server/fc/addons/sourcemod/configs/admins_simple.ini
elif [ -f /usr/bin/gedit ];then
	gedit ./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server/fc/addons/sourcemod/configs/admins_simple.ini
else
	vi ./steamapps/common/Source\ SDK\ Base\ 2013\ Dedicated\ Server/fc/addons/sourcemod/configs/admins_simple.ini
fi
start
}

start

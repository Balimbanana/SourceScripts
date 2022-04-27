#!/bin/bash

# Sets your servers name
hostname="First Syn 56.16 Server"
# In order to use above 10 max players, you must have PLR enabled below
maxplayers=32
# If you want your server to be passworded, set it here
serverpassword=""
# Map to start server with
startmap="d1_trainstation_01"

# Port to host on NOTE: change savedirectory if you are running multiple servers
portnumber=27015
# Save directory, each server must have a different save directory if you are running forked servers
savedirectory="save1/"

# You cannot use anonymous to install Synergy,
# this must be a Steam account that also owns Half-Life 2 for fresh installs.
# Once the server has been fully installed, you can change this to blank.
username="ChangeMe"

# Automatically install SourceMod and MetaMod
installsm=1
# Install some base plugins like SynFixes, SynSaveRestore, and EDTRebuild
installbaseplugins=1

# Install Synergy reverse engineered fixes (requires SourceMod/MetaMod)
# When this is set to 2 it will update every time this script is started
# If set to 1, this will only install once and not update.
installutilfixes=2

# Install PLR Player Limit Remover to allow up to 64 max players
# While the server *can* start with more than 64, it will crash clients on join with bogus slot error.
installplr=1













synpath=./steamapps/common/Synergy
cldir=$HOME/.Steam/steamapps
if [ ! -d $cldir ]; then
	if [ -d /Steam/steamapps ]; then cldir=/Steam/steamapps ;fi
	if [ -d $HOME/.local/share/Steam/steamapps ]; then cldir=$HOME/.local/share/Steam/steamapps ;fi
	if [ -d $HOME/Steam/steamapps ]; then cldir=$HOME/Steam/steamapps ;fi
	if [ -d $HOME/steam/steamapps ]; then cldir=$HOME/steam/steamapps ;fi
	if [ -d $HOME/Library/Application\ Support/Steam/SteamApps ]; then cldir=$HOME/Library/Application\ Support/Steam/SteamApps ;fi
	if [ $cldir == $PWD ]; then cldir=none ;fi
	if [ ! -d $cldir ]; then cldir=none ;fi
fi

if [ -f /usr/bin/dpkg-query ];then
	if [[ ! $(dpkg-query -l lib32gcc1) ]] && [[ $(arch | grep 64) ]];then
		if [[ $(cat /etc/os-release | grep ID=ubuntu) ]];then
			echo "Attempting to install lib32gcc1 through apt-get..."
			sudo apt-get install lib32gcc1
		fi
	fi
	if [[ ! $(dpkg-query -l libgcc1) ]] && [[ ! $(arch | grep 64) ]];then
		echo "Attempting to install libgcc1 through apt-get..."
		sudo apt-get install libgcc1
	fi
fi
if [ -f /usr/bin/dnf ];then
	if [[ ! $(dnf list glibc) ]];then missinglib=1;fi
	if [[ ! $(dnf list libstdc++) ]];then missinglib=1;fi
	if [[ ! $(dnf list glibc.i686) ]];then missinglib=1;fi
	if [[ $missinglib = "1" ]];then
		echo "Attempting to install glibc, libstdc++ and libc through dnf..."
		sudo dnf install glibc libstdc++ libc.so.6
	fi
fi

inststeam() {
if [ ! -f ./steamcmd.sh ]; then curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - ;fi
if [ ! -f ./steamcmd.sh ]; then
	echo "Something went wrong in downloading/extracting SteamCMD"
	exit
fi
firstinstall
}

firstinstall() {
anonblck=${username,,}
if [ $anonblck = "anonymous" ];then noanon;fi
if [ -f $cldir/synergy/synergy_pak.vpk ]; then
	if [ ! -d $synpath ]; then mkdir $synpath ;fi
	if [ ! -d $synpath/synergy ]; then mkdir $synpath/synergy ;fi
	if [ ! -f $synpath/synergy/synergy_pak.vpk ]; then
		cp $cldir/synergy/synergy_pak.vpk $synpath/synergy/synergy_pak.vpk
	fi
fi
if [ -f $cldir/synergy/zhl2dm_materials_pak.vpk ]; then
	if [ ! -d $synpath ]; then mkdir $synpath ;fi
	if [ ! -d $synpath/synergy ]; then mkdir $synpath/synergy ;fi
	if [ ! -f $synpath/synergy/zhl2dm_materials_pak.vpk ]; then
		cp $cldir/synergy/zhl2dm_materials_pak.vpk $synpath/synergy/zhl2dm_materials_pak.vpk
	fi
fi
s=1
hl=1
if [ ! -f $synpath/synergy/synergy_pak.vpk ]; then
	echo "Updating/installing Synergy DS"
	./steamcmd.sh +force_install_dir ./steamapps/common/Synergy +login $username +app_update 17520 -beta public validate +quit
	echo "Update/installation Complete"
	echo "If there were errors above, close the script and log in to steamcmd.sh separately, then restart the script."
	
	echo "Setting up links and first settings in server2.cfg"
	if [ ! -d $cldir/sourcemods ];then s=0;fi
	if [ ! -d $cldir/common/Half-Life\ 2/hl2 ];then hl=0;fi
	if [ hl = 0 ];then if [ -d ./steamapps/common/Half-Life\ 2/hl2 ];then hl=2;fi;fi
	if [ hl = 0 ];then insthl2;fi
	if [ hl = 1 ];then ln -s $cldir/common/Half-Life\ 2 ./steamapps/common/Half-Life\ 2;fi
	if [ s = 0 ];then echo "sourcemods not found, not linking.";fi
	if [ s = 1 ];then ln -s $cldir/sourcemods ./steamapps/sourcemods;fi
	rm -f ./$synpath/synergy/scripts/weapon_betagun.txt
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripts/weapon_betagun.txt" -P ./$synpath/synergy/scripts
	if [ ! -d ./$synpath/synergy/scripts/talker ];then mkdir ./$synpath/synergy/scripts/talker ;fi
	if [ ! -d ./$synpath/synergy/scripts/talker/player ];then mkdir ./$synpath/synergy/scripts/talker/player ;fi
	wget -nv "https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/scripts/talker/player/humans.txt" -P ./$synpath/synergy/scripts/talker/player
	if [ ! -d ./$synpath/synergy/models ];then mkdir ./$synpath/synergy/models ;fi
	if [ ! -d ./$synpath/synergy/models/weapons ];then mkdir ./$synpath/synergy/models/weapons ;fi
	if [ ! -f ./$synpath/synergy/models/weapons/w_physics.phy ];then wget -nv "https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/w_physics.phy" -P ./$synpath/synergy/models/weapons ;fi
	if [ ! -f ./$synpath/synergy/cfg/server2.cfg ];then
		echo sv_lan 0 >>$synpath/synergy/cfg/server2.cfg
		echo mp_friendlyfire 0 >>$synpath/synergy/cfg/server2.cfg
		echo mp_reset 1 >>$synpath/synergy/cfg/server2.cfg
		echo mp_transition_time 45 >>$synpath/synergy/cfg/server2.cfg
		echo mp_transition_percent 68 >>$synpath/synergy/cfg/server2.cfg
		echo sv_vote_enable 1 >>$synpath/synergy/cfg/server2.cfg
		echo sv_vote_failure_timer 300 >>$synpath/synergy/cfg/server2.cfg
		echo sv_vote_interval 10 >>$synpath/synergy/cfg/server2.cfg
		echo sv_vote_percent_difficulty 67 >>$synpath/synergy/cfg/server2.cfg
		echo sv_vote_percent_kick 67 >>$synpath/synergy/cfg/server2.cfg
		echo sv_vote_percent_map 67 >>$synpath/synergy/cfg/server2.cfg
		echo sv_vote_percent_restore 67 >>$synpath/synergy/cfg/server2.cfg
	fi
	echo "Should be all configured for server running."
fi
if [ ! -f $synpath/synergy/synergy_pak.vpk ]; then
	echo "Failed to install"
	exit
fi
if [ $installsm = "1" ];then instsourcem;fi
srcds
}

instsourcem() {
if [ ! -d ./steamapps/common/Synergy/synergy ];then notinstalled;fi
if [ ! -d $synpath ];then notinstalled;fi
if [ -d ./$synpath/addons/sourcemod ];then
	srcds
fi
echo "This will direct download the required SourceMod files and then extract them."
curl -sqL "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6503-linux.tar.gz" | tar zxvf - -C ./$synpath/synergy
curl -sqL "https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1145-linux.tar.gz" | tar zxvf - -C ./$synpath/synergy
curl -sqL "https://users.alliedmods.net/~kyles/builds/SteamWorks/SteamWorks-git131-linux.tar.gz" | tar zxvf - -C ./$synpath/synergy
if [ ! -d ./$synpath/synergy/addons/sourcemod ];then
	echo "Failed to auto-install SourceMod, you may have to manually install it."
	srcds
fi
if [ -f ./$synpath/synergy/addons/metamod_x64.vdf ];then rm ./$synpath/synergy/addons/metamod_x64.vdf ;fi
if [ -d ./$synpath/synergy/addons/metamod/bin/linux64 ]; then rm -rf ./$synpath/synergy/addons/metamod/bin/linux64 ;fi
if [ -d ./$synpath/synergy/addons/sourcemod/bin/x64 ]; then rm -rf ./$synpath/synergy/addons/sourcemod/bin/x64 ;fi
if [ ! -d ./$synpath/synergy/addons/sourcemod/gamedata/sdkhooks.games/custom ];then
	mkdir ./$synpath/synergy/addons/sourcemod/gamedata/sdkhooks.games/custom
fi
if [ ! -d ./$synpath/synergy/addons/sourcemod/gamedata/sdktools.games/custom ];then
	mkdir ./$synpath/synergy/addons/sourcemod/gamedata/sdktools.games/custom
fi
wget -nv "https://raw.githubusercontent.com/Balimbanana/SM-Synergy/master/56.16lin/sdkhooks.games/custom/game.synergy.txt" -P ./$synpath/synergy/addons/sourcemod/gamedata/sdkhooks.games/custom
wget -nv "https://raw.githubusercontent.com/Balimbanana/SM-Synergy/master/56.16lin/sdktools.games/custom/game.synergy.txt" -P ./$synpath/synergy/addons/sourcemod/gamedata/sdktools.games/custom
if [ -f ./$synpath/synergy/addons/sourcemod/plugins/updater.smx ];then wget -nv "https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/addons/sourcemod/plugins/updater.smx" -P ./$synpath/synergy/addons/sourcemod/plugins ;fi
# remove nextmap as it does not work in Synergy
rm -f ./$synpath/synergy/addons/sourcemod/plugins/nextmap.smx
echo "SourceMod installed, you can put plugins in ./$synpath/addons/sourcemod/plugins"
if [ ! -d ./$synpath/synergy/addons/plr ]; then
	if [ -d ./$synpath/synergy/addons/metamod ]; then
		if [ $installplr = "1" ]; then
			if [ ! -d ./$synpath/synergy/addons/plr ]; then
				if [ -d ./$synpath/synergy/addons/metamod ]; then
					mkdir ./$synpath/synergy/addons/plr
					wget -nv "https://raw.githubusercontent.com/FoG-Plugins/Player-Limit-Remover/master/addons/plr.vdf" -P ./$synpath/synergy/addons
					wget -nv "https://github.com/FoG-Plugins/Player-Limit-Remover/raw/master/addons/plr/plr.so" -P ./$synpath/synergy/addons/plr
				fi
			fi
			if [ -f ./$synpath/synergy/addons/plr/plr.so ]; then
				if [ -f ./$synpath/synergy/addons/plr.vdf ]; then
					echo "Successfully installed PLR"
				fi
			fi
		fi
	fi
fi
if [ -d ./$synpath/synergy/addons/sourcemod/plugins ]; then
	if [ $installbaseplugins = "1" ]; then
		if [ ! -f ./$synpath/addons/sourcemod/plugins/synfixes.smx ];then
			wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/synfixes.smx" -P ./$synpath/addons/sourcemod/plugins
		fi
		if [ ! -f ./$synpath/addons/sourcemod/plugins/synsaverestore.smx ];then
			wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/synsaverestore.smx" -P ./$synpath/addons/sourcemod/plugins
		fi
		if [ ! -f ./$synpath/addons/sourcemod/plugins/edtrebuild.smx ];then
			wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/edtrebuild.smx" -P ./$synpath/addons/sourcemod/plugins
		fi
	fi
fi
srcds
}

noanon() {
echo "You cannot use anonymous to install Synergy..."
exit
}

srcds() {
if [ ! -f ./$synpath/srcds_run ];then notinstalled;fi
if [ ! -d ./steamapps/common/Half-Life\ 2/hl2 ];then insthl2;fi
if [ ! -L ./$synpath/bin/libtier0.so ];then
	mv ./$synpath/bin/libtier0.so ./$synpath/bin/libtier0.so.bak
	ln -s libtier0_srv.so ./$synpath/bin/libtier0.so
fi
if [ ! -L ./$synpath/bin/libvstdlib.so ];then
	mv ./$synpath/bin/libvstdlib.so ./$synpath/bin/libvstdlib.so.bak
	ln -s libvstdlib_srv.so ./$synpath/bin/libvstdlib.so
fi
if [ ! -L ./$synpath/bin/steamclient.so ];then
	mv ./$synpath/bin/steamclient.so ./$synpath/bin/steamclient.so.bak
	ln -s ../../../../linux32/steamclient.so ./$synpath/bin/steamclient.so
fi
if [ ! -d ./$synpath/synergy/download ];then mkdir ./$synpath/synergy/download ;fi
if [ ! -d ./$synpath/synergy/download/user_custom ];then mkdir ./$synpath/synergy/download/user_custom ;fi
if [ ! -L ./$synpath/synergy/user_custom ];then ln -s ./download/user_custom ./$synpath/synergy/user_custom ;fi

if [ $installutilfixes = "2" ]; then
	if [ -f ./$synpath/synergy/addons/sourcemod/extensions/synergy_utils.ext.so ]; then rm ./$synpath/synergy/addons/sourcemod/extensions/synergy_utils.ext.so ;fi
	installutilfixes=1
fi
if [ $installutilfixes = "1" ]; then
	if [ ! -f ./$synpath/synergy/addons/sourcemod/extensions/synergy_utils.ext.so ]; then
		if [ ! -f ./$synpath/synergy/addons/sourcemod/extensions/synergy_utils.autoload ]; then echo "" > ./$synpath/synergy/addons/sourcemod/extensions/synergy_utils.autoload ;fi
		wget -nv "https://github.com/ReservedRegister/Synergy_ReverseEngineering/raw/master/build/package/addons/sourcemod/extensions/synergy_utils.ext.2.sdk2013.so" -P ./$synpath/synergy/addons/sourcemod/extensions
mv ./$synpath/synergy/addons/sourcemod/extensions/synergy_utils.ext.2.sdk2013.so ./$synpath/synergy/addons/sourcemod/extensions/synergy_utils.ext.so
	fi
fi
reds
}

notinstalled() {
echo "Synergy install failed..."
exit
}

insthl2() {
./steamcmd.sh +force_install_dir ./steamapps/common/Half-Life\ 2 +login $username +app_update 220 validate +quit
./steamcmd.sh +force_install_dir ./steamapps/common/Half-Life\ 2 +login $username +app_update 280 validate +quit
./steamcmd.sh +force_install_dir ./steamapps/common/Half-Life\ 2 +login $username +app_update 340 validate +quit
./steamcmd.sh +force_install_dir ./steamapps/common/Half-Life\ 2 +login $username +app_update 380 validate +quit
./steamcmd.sh +force_install_dir ./steamapps/common/Half-Life\ 2 +login $username +app_update 420 validate +quit
if [ ! -f ./steamapps/common/Half-Life\ 2/hl2/hl2_misc_dir.vpk ];then
	echo "Failed to install Half-Life 2, install halted!"
	exit
fi
srcds
}

reds() {
curdatetime=$(date -u)
echo "$curdatetime SynDS started."
./$synpath/srcds_run "-game synergy -console -norestart +maxplayers $maxplayers +sv_lan 0 +hostname \"$hostname\" +map \"$startmap\" +exec server2.cfg +sv_savedir \"$savedirectory\" +sv_password \"$serverpassword\" -ip 0.0.0.0 -port \"$portnumber\" -nocrashdialog -insecure -nohltv"
curdatetime=$(date -u)
echo "$curdatetime WARNING: SynDS closed or crashed, restarting."
sleep 1
reds
}

inststeam

#!/bin/bash
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
			packageinf="Use sudo apt-get install lib32gcc1"
			missingdeps
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

updatescr() {
if [ ! -d ./tmpupd ]; then mkdir tmpupd ;fi
cd ./tmpupd
if [ -f ./syndsinstall.sh ]; then rm ./syndsinstall.sh ;fi
wget "https://github.com/Balimbanana/SourceScripts/raw/master/unix/syndsinstall.sh"
if [ -f ./syndsinstall.sh ]; then
	chmod +x ./syndsinstall.sh
	rm ../syndsinstall.sh
	mv ./syndsinstall.sh ../syndsinstall.sh
	cd ..
	echo "Updated..."
	rm -rf ./tmpupd
	./syndsinstall.sh
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
echo "Information: enter the letter inside the () and press enter to continue at the prompts."
echo "First (I)nstall, (U)pdate, (R)un with auto-restart"
echo "(RB) to run Synergy 18.x beta, (RT) to run Synergy Twitch branch."
echo "(IS) to install SourceMod."
if [ -d ./steamapps/common/Synergy/synergy/addons/sourcemod/plugins ]; then echo "(ISM) to install additional SM plugins. (IMP) to install Player Model Packs."; fi
if [ ! -d ./steamapps/common/Synergy/synergy/addons/plr ]; then
	if [ -d ./steamapps/common/Synergy/synergy/addons/metamod ]; then
		echo "(PLR) to install Player Limit Remover, allows for up to 64 players (only v56.16)"
	fi
fi
if [ -f ./steamapps/common/Synergy/synergy/addons/sourcemod/configs/admins_simple.ini ]; then
	echo "(SMADMIN) to modify your SourceMod admins file."
fi
echo "(IHL2) (IEp1) (IEp2) to install/update HL2 Ep1 or Ep2. (IMods) to install Steam source mods and supports."
echo "(update) to update this script."
read uprun
uprun=${uprun,,}
if [ -z $uprun ];then uprun="noneselected" ;fi
if [ $uprun = "u" ]; then firstinstall;fi
if [ $uprun = "i" ]; then firstinstall;fi
if [ $uprun = "rb" ]; then srcds;fi
if [ $uprun = "rt" ]; then srcds;fi
if [ $uprun = "r" ]; then srcds;fi
if [ $uprun = "is" ]; then instsourcem;fi
if [ $uprun = "ism" ]; then instsourcepluginstop;fi
if [ $uprun = "linksm" ]; then linksm;fi
if [ $uprun = "plr" ]; then instplr;fi
if [ $uprun = "imp" ]; then instpmpck;fi
if [ $uprun = "smadmin" ]; then modifysmadmin;fi
if [ $uprun = "ihl2" ]; then updhl2;fi
if [ $uprun = "iep1" ]; then updep1;fi
if [ $uprun = "iep2" ]; then updep2;fi
if [ $uprun = "imods" ]; then updmods;fi
if [ $uprun = "update" ]; then updatescr;fi
echo "Choose an option."
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
if [ ! -d ./steamapps/common/Synergy/synergy ];then notinstalled;fi
if [ $instsmset = "0" ];then
	echo "This function is designed for the current version of Synergy, the development branch may be unstable."
	echo "Install SourceMod for Regular, (B)eta, or (T)witch? (anything except b or t will do regular)"
	read betaset
	betaset=${betaset,,}
fi
if [ -z $betaset ];then betaset="r" ;fi
syntype="reg"
synpath="steamapps/common/Synergy/synergy"
if [ $betaset = "b" ];then
	synpath="steamapps/common/synbeta/synergy";
	syntype="dev"
fi
if [ $betaset = "t" ];then
	synpath="steamapps/common/syntwitch/synergy";
	syntype="twitch"
fi
if [ ! -d $synpath ];then notinstalled;fi
echo "This will direct download the required SourceMod files and then extract them."
if [ -d ./$synpath/addons/sourcemod ];then
	echo "SourceMod is already installed, if you want to re-install, rename the current SourceMod install and re-run this script."
	read nullptr
	start
fi
curl -sqL "https://sm.alliedmods.net/smdrop/1.11/sourcemod-1.11.0-git6473-linux.tar.gz" | tar zxvf - -C ./$synpath
curl -sqL "https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1128-linux.tar.gz" | tar zxvf - -C ./$synpath
curl -sqL "https://users.alliedmods.net/~kyles/builds/SteamWorks/SteamWorks-git131-linux.tar.gz" | tar zxvf - -C ./$synpath
if [ ! -d ./$synpath/addons/sourcemod ];then
	echo "Failed to auto-install SourceMod, you may have to manually install it."
	read nullptr
	start
fi
if [ -f ./$synpath/addons/metamod_x64.vdf ];then rm ./$synpath/addons/metamod_x64.vdf ;fi
if [ ! -d ./$synpath/addons/sourcemod/gamedata/sdkhooks.games/custom ];then
	mkdir ./$synpath/addons/sourcemod/gamedata/sdkhooks.games/custom
fi
if [ ! -d ./$synpath/addons/sourcemod/gamedata/sdktools.games/custom ];then
	mkdir ./$synpath/addons/sourcemod/gamedata/sdktools.games/custom
fi
if [ syntype = "dev" ];then
	wget -nv "https://raw.githubusercontent.com/Balimbanana/SM-Synergy/master/devtwitchgamedata/sdkhooks.games/custom/game.synergy.txt" -P ./$synpath/addons/sourcemod/gamedata/sdkhooks.games/custom
	wget -nv "https://raw.githubusercontent.com/Balimbanana/SM-Synergy/master/devtwitchgamedata/sdktools.games/custom/game.synergy.txt" -P ./$synpath/addons/sourcemod/gamedata/sdktools.games/custom
elif [ syntype = "twitch" ];then
	wget -nv "https://raw.githubusercontent.com/Balimbanana/SM-Synergy/master/twitchbranchgamedata/sdkhooks.games/custom/game.synergy.txt" -P ./$synpath/addons/sourcemod/gamedata/sdkhooks.games/custom
	wget -nv "https://raw.githubusercontent.com/Balimbanana/SM-Synergy/master/twitchbranchgamedata/sdktools.games/custom/game.synergy.txt" -P ./$synpath/addons/sourcemod/gamedata/sdktools.games/custom
else
	wget -nv "https://raw.githubusercontent.com/Balimbanana/SM-Synergy/master/56.16lin/sdkhooks.games/custom/game.synergy.txt" -P ./$synpath/addons/sourcemod/gamedata/sdkhooks.games/custom
	wget -nv "https://raw.githubusercontent.com/Balimbanana/SM-Synergy/master/56.16lin/sdktools.games/custom/game.synergy.txt" -P ./$synpath/addons/sourcemod/gamedata/sdktools.games/custom
fi
if [ -f ./$synpath/addons/sourcemod/plugins/updater.smx ];then wget -nv "https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/addons/sourcemod/plugins/updater.smx" -P ./$synpath/addons/sourcemod/plugins ;fi
# remove nextmap as it does not work in Synergy
rm -f ./$synpath/addons/sourcemod/plugins/nextmap.smx
echo "SourceMod installed, you can put plugins in ./$synpath/addons/sourcemod/plugins"
if [ ! -d ./steamapps/common/Synergy/synergy/addons/plr ]; then
	if [ -d ./steamapps/common/Synergy/synergy/addons/metamod ]; then
		echo "Would you like to also install Player Limit Remover? Allows for up to 64 players (only v56.16)"
		read installplr
		if [ -z $installplr ];then installplr="n" ;fi
		if [ $installplr = "y" ]; then
			if [ ! -d ./steamapps/common/Synergy/synergy/addons/plr ]; then
				if [ -d ./steamapps/common/Synergy/synergy/addons/metamod ]; then
					mkdir ./steamapps/common/Synergy/synergy/addons/plr
					wget -nv "https://raw.githubusercontent.com/FoG-Plugins/Player-Limit-Remover/master/addons/plr.vdf" -P ./steamapps/common/Synergy/synergy/addons
					wget -nv "https://github.com/FoG-Plugins/Player-Limit-Remover/raw/master/addons/plr/plr.so" -P ./steamapps/common/Synergy/synergy/addons/plr
				fi
			fi
			if [ -f ./steamapps/common/Synergy/synergy/addons/plr/plr.so ]; then
				if [ -f ./steamapps/common/Synergy/synergy/addons/plr.vdf ]; then
					echo "Successfully installed PLR"
				fi
			fi
		fi
	fi
fi
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
	if [ -d $cldir/sourcemods ];then
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
if [ $anonset = 0 ]; then
	echo "Regular, (B)eta, or (T)witch? (anything except b or t will do regular)"
	read betaset
	if [ ${#betaset} \< 1 ];then betaset=regular;fi
	betaset=${betaset,,}
fi
echo "Enter your username here:"
read stusername
anonblck=${stusername,,}
if [ $anonblck = "anonymous" ];then noanon;fi
synpath=./steamapps/common/Synergy
if [ $betaset = "b" ];then synpath="./steamapps/common/synbeta";fi
if [ $betaset = "t" ];then synpath="./steamapps/common/syntwitch";fi
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
if [ $betaset = "b" ];then betainst;fi
if [ $betaset = "t" ];then twitchinst;fi
echo "Updating/installing Synergy DS"
./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/Synergy +app_update 17520 -beta public validate +quit
echo "Update/installation Complete"
echo "If there were errors above, close the script and log in to steamcmd.sh separately, then restart the script."
if [ ! -f $synpath/synergy/synergy_pak.vpk ]; then
	echo "Failed to install"
	start
fi
if [ $uprun = "i" ];then setup;fi
srcds
}

noanon() {
if [ $anonset = 0 ];then echo "You cannot use anonymous to install Synergy...";fi
if [ $anonset = 2 ];then
	echo "You cannot use anonymous to install HL2..."
	stusername=""
	anonset=0
	insthl2
fi
anonset=1
firstinstall
}

twitchinst() {
echo "Updating/installing Synergy Twitch Branch DS"
./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/syntwitch +app_update 17520 -beta twitch -validate +quit
echo "Update/installation Complete"
echo "If there were errors above, close the script and log in to steamcmd.sh separately, then restart this script."
if [ ! -f $synpath/synergy/synergy_pak.vpk ]; then
	echo "Failed to install"
	start
fi
if [ $uprun = "i" ];then setup;fi
uprun="t"
srcds
}

betainst() {
echo "Updating/installing Synergy Beta DS"
./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/synbeta +app_update 17520 -beta development -validate +quit
echo "Update/installation Complete"
echo "If there were errors above, close the script and log in to steamcmd.sh separately, then restart this script."
if [ ! -f $synpath/synergy/synergy_pak.vpk ]; then
	echo "Failed to install"
	start
fi
if [ $uprun = "i" ];then setup;fi
uprun="b"
srcds
}

setup() {
s=1
hl=1
echo "Setting up links and first settings in server2.cfg"
if [ ! -d $cldir/sourcemods ];then s=0;fi
if [ ! -d $cldir/common/Half-Life\ 2/hl2 ];then hl=0;fi
if [ hl = 0 ];then if [ -d ./steamapps/common/Half-Life\ 2/hl2 ];then hl=2;fi;fi
if [ hl = 0 ];then insthl2;fi
if [ hl = 1 ];then ln -s $cldir/common/Half-Life\ 2 ./steamapps/common/Half-Life\ 2;fi
if [ s = 0 ];then echo "sourcemods not found, not linking.";fi
if [ s = 1 ];then ln -s $cldir/sourcemods ./steamapps/sourcemods;fi
synpath=./steamapps/common/Synergy
syntype=56.16
if [ $betaset = "b" ];then
	synpath=./steamapps/common/synbeta
	syntype=18.7
	uprun="b"
fi
if [ $betaset = "t" ];then
	synpath=./steamapps/common/syntwitch
	syntype=Twitch
	uprun="t"
fi
rm -f ./$synpath/synergy/scripts/weapon_betagun.txt
wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripts/weapon_betagun.txt" -P ./$synpath/synergy/scripts
if [ ! -d ./$synpath/synergy/scripts/talker ];then mkdir ./$synpath/synergy/scripts/talker ;fi
if [ ! -d ./$synpath/synergy/scripts/talker/player ];then mkdir ./$synpath/synergy/scripts/talker/player ;fi
wget -nv "https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/scripts/talker/player/humans.txt" -P ./$synpath/synergy/scripts/talker/player
if [ ! -d ./$synpath/synergy/models ];then mkdir ./$synpath/synergy/models ;fi
if [ ! -d ./$synpath/synergy/models/weapons ];then mkdir ./$synpath/synergy/models/weapons ;fi
if [ ! -f ./$synpath/synergy/models/weapons/w_physics.phy ];then wget -nv "https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/w_physics.phy" -P ./$synpath/synergy/models/weapons ;fi
if [ ! -f ./$synpath/synergy/cfg/server2.cfg ];then
	echo hostname First Syn $syntype Server>$synpath/synergy/cfg/server2.cfg
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
	echo //Change this to a different savenumber for forked servers>>$synpath/synergy/cfg/server2.cfg
	echo sv_savedir save2/>>$synpath/synergy/cfg/server2.cfg
fi
echo "Should be all configured for server running."
echo "Would you like to edit your server config? (y/N)"
read editconf
if [ -z $editconf ];then editconf="noneselected" ;fi
editconf=${editconf,,}
if [ $editconf = "y" ];then
	if [ ! -z $EDITOR ];then
		$EDITOR $synpath/synergy/cfg/server2.cfg
	elif [ ! -z $VISUAL ];then
		$VISUAL $synpath/synergy/cfg/server2.cfg
	elif [ -f /bin/nano ];then
		nano $synpath/synergy/cfg/server2.cfg
	elif [ -f /usr/bin/gedit ];then
		gedit $synpath/synergy/cfg/server2.cfg
	else
		vi $synpath/synergy/cfg/server2.cfg
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
synpath="steamapps/common/Synergy"
if [ $uprun = "rb" ];then synpath="steamapps/common/synbeta";fi
if [ $uprun = "b" ];then synpath="steamapps/common/synbeta";fi
if [ $uprun = "rt" ];then synpath="steamapps/common/syntwitch";fi
if [ $uprun = "t" ];then synpath="steamapps/common/syntwitch";fi
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
reds
}

reds() {
curdatetime=$(date -u)
echo "$curdatetime SynDS started."
./$synpath/srcds_run -game synergy -console -norestart +maxplayers 32 +sv_lan 0 +map d1_trainstation_06 +exec server2.cfg -ip 0.0.0.0 -port 27015 -nocrashdialog -insecure -nohltv
curdatetime=$(date -u)
echo "$curdatetime WARNING: SynDS closed or crashed, restarting."
sleep 1
reds
}

notinstalled() {
syntype="56.16"
if [ $uprun = "rb" ];then syntype="Beta";fi
if [ $uprun = "b" ];then syntype="Beta";fi
if [ $uprun = "rt" ];then syntype="Twitch branch";fi
if [ $uprun = "t" ];then syntype="Twitch branch";fi
echo "Synergy $syntype not installed."
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
./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/Half-Life\ 2 +app_update 220 validate +quit
if [ $hllist > 2 ];then
	./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/Half-Life\ 2 +app_update 280 validate +quit
	./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/Half-Life\ 2 +app_update 340 validate +quit
fi
if [ $hllist > 0 ];then
	./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/Half-Life\ 2 +app_update 380 validate +quit
fi
if [ $hllist > 1 ];then
	./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/Half-Life\ 2 +app_update 420 validate +quit
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
./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/Half-Life\ 2 +app_update 220 validate +quit
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
./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/Half-Life\ 2 +app_update 380 validate +quit
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
./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/Half-Life\ 2 +app_update 420 validate +quit
start
}

updmods() {
if [ ! -d "./steamapps/workshop" ];then mkdir "./steamapps/workshop" ;fi
if [ ! -d "./steamapps/workshop/content" ];then mkdir "./steamapps/workshop/content" ;fi
if [ ! -d "./steamapps/workshop/content/17520" ];then
	if [ ! -L "./steamapps/workshop/content/17520" ];then
		mkdir "./steamapps/workshop/content/17520"
		touch ./steamapps/workshop/content/17520/tmpfile
	fi
fi
if [ ! -L "./steamapps/workshop/content/17520" ];then
	rsync --remove-source-files -a ./steamapps/workshop/content/17520/* ./steamapps/common/Synergy/synergy/custom
	rm -rf ./steamapps/workshop/content/17520
	ln -s "../../common/Synergy/synergy/custom" "./steamapps/workshop/content/17520"
	if [ -f "./steamapps/common/Synergy/synergy/custom/tmpfile" ];then rm ./steamapps/common/Synergy/synergy/custom/tmpfile ;fi
fi
echo "Install Steam released mods and support files for Synergy."
echo "(yla) Year Long Alarm     (amal) Amalgam"
echo "(pros) Prospekt           (df) DownFall"
echo "(ezero) Entropy Zero"
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
	if [ ! -f "./steamapps/workshop/content/17520/1654962168/1654962168_pak.vpk" ];then
		./steamcmd.sh +login anonymous +workshop_download_item 17520 1654962168 +quit
		if [ ! -f "./steamapps/workshop/content/17520/1654962168/1654962168_pak.vpk" ];then
			if [ -f "$HOME/.steam/steam/steamapps/workshop/content/17520/1654962168/1654962168_pak.vpk" ];then
				if [ ! -L "$HOME/.steam/steam/steamapps/workshop/content/17520" ];then
					rsync --remove-source-files -a $HOME/.steam/steam/steamapps/workshop/content/17520/* ./steamapps/common/Synergy/synergy/custom
					rm -rf $HOME/.steam/steam/steamapps/workshop/content/17520
					ln -s "$PWD/steamapps/common/Synergy/synergy/custom" "$HOME/.steam/steam/steamapps/workshop/content/17520"
					if [ -f "./steamapps/common/Synergy/synergy/custom/tmpfile" ];then rm ./steamapps/common/Synergy/synergy/custom/tmpfile ;fi
				fi
			fi
		fi
	fi
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +login $stusername +force_install_dir ./steamapps/common/yla +app_update 747250 validate +quit
	if [ ! -f "./steamapps/common/Synergy/synergy/content/yearlongalarm.dat" ];then wget -nv "https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/yearlongalarm.dat" -P ./steamapps/common/Synergy/synergy/content ;fi
fi
if [ $instmod = "amal" ];then
	if [ ! -f "./steamapps/workshop/content/17520/2347382988/2347382988_pak.vpk" ];then
		./steamcmd.sh +login anonymous +workshop_download_item 17520 2347382988 +quit
		if [ ! -f "./steamapps/workshop/content/17520/2347382988/2347382988_pak.vpk" ];then
			if [ -f "$HOME/.steam/steam/steamapps/workshop/content/17520/2347382988/2347382988_pak.vpk" ];then
				if [ ! -L "$HOME/.steam/steam/steamapps/workshop/content/17520" ];then
					rsync --remove-source-files -a $HOME/.steam/steam/steamapps/workshop/content/17520/* ./steamapps/common/Synergy/synergy/custom
					rm -rf $HOME/.steam/steam/steamapps/workshop/content/17520
					ln -s "$PWD/steamapps/common/Synergy/synergy/custom" "$HOME/.steam/steam/steamapps/workshop/content/17520"
					if [ -f "./steamapps/common/Synergy/synergy/custom/tmpfile" ];then rm ./steamapps/common/Synergy/synergy/custom/tmpfile ;fi
				fi
			fi
		fi
	fi
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +login $stusername +force_install_dir ./steamapps/common/Amalgam +app_update 1389950 validate +quit
fi
if [ $instmod = "df" ];then
	if [ ! -f "./steamapps/workshop/content/17520/909637644/909637644_pak.vpk" ];then
		./steamcmd.sh +login anonymous +workshop_download_item 17520 909637644 +quit
		if [ ! -f "./steamapps/workshop/content/17520/909637644/909637644_pak.vpk" ];then
			if [ -f "$HOME/.steam/steam/steamapps/workshop/content/17520/909637644/909637644_pak.vpk" ];then
				if [ ! -L "$HOME/.steam/steam/steamapps/workshop/content/17520" ];then
					rsync --remove-source-files -a $HOME/.steam/steam/steamapps/workshop/content/17520/* ./steamapps/common/Synergy/synergy/custom
					rm -rf $HOME/.steam/steam/steamapps/workshop/content/17520
					ln -s "$PWD/steamapps/common/Synergy/synergy/custom" "$HOME/.steam/steam/steamapps/workshop/content/17520"
					if [ -f "./steamapps/common/Synergy/synergy/custom/tmpfile" ];then rm ./steamapps/common/Synergy/synergy/custom/tmpfile ;fi
				fi
			fi
		fi
	fi
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +login $stusername +force_install_dir ./steamapps/common/HL2DownFall +app_update 587650 validate +quit
	if [ ! -f "./steamapps/common/Synergy/synergy/content/DownFall.dat" ];then wget -nv "https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/DownFall.dat" -P ./steamapps/common/Synergy/synergy/content ;fi
fi
if [ $instmod = "pros" ];then
	if [ ! -f "./steamapps/workshop/content/17520/2338505640/2338505640_pak.vpk" ];then
		./steamcmd.sh +login anonymous +workshop_download_item 17520 2338505640 +quit
		if [ ! -f "./steamapps/workshop/content/17520/2338505640/2338505640_pak.vpk" ];then
			if [ -f "$HOME/.steam/steam/steamapps/workshop/content/17520/2338505640/2338505640_pak.vpk" ];then
				if [ ! -L "$HOME/.steam/steam/steamapps/workshop/content/17520" ];then
					rsync --remove-source-files -a $HOME/.steam/steam/steamapps/workshop/content/17520/* ./steamapps/common/Synergy/synergy/custom
					rm -rf $HOME/.steam/steam/steamapps/workshop/content/17520
					ln -s "$PWD/steamapps/common/Synergy/synergy/custom" "$HOME/.steam/steam/steamapps/workshop/content/17520"
					if [ -f "./steamapps/common/Synergy/synergy/custom/tmpfile" ];then rm ./steamapps/common/Synergy/synergy/custom/tmpfile ;fi
				fi
			fi
		fi
	fi
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +login $stusername +force_install_dir ./steamapps/common/Prospekt +app_update 399120 validate +quit
fi
if [ $instmod = "ezero" ];then
	if [ ! -f "./steamapps/workshop/content/17520/1877479381/1877479381_pak.vpk" ];then
		./steamcmd.sh +login anonymous +workshop_download_item 17520 1877479381 +quit
		if [ ! -f "./steamapps/workshop/content/17520/1877479381/1877479381_pak.vpk" ];then
			if [ -f "$HOME/.steam/steam/steamapps/workshop/content/17520/1877479381/1877479381_pak.vpk" ];then
				if [ ! -L "$HOME/.steam/steam/steamapps/workshop/content/17520" ];then
					rsync --remove-source-files -a $HOME/.steam/steam/steamapps/workshop/content/17520/* ./steamapps/common/Synergy/synergy/custom
					rm -rf $HOME/.steam/steam/steamapps/workshop/content/17520
					ln -s "$PWD/steamapps/common/Synergy/synergy/custom" "$HOME/.steam/steam/steamapps/workshop/content/17520"
					if [ -f "./steamapps/common/Synergy/synergy/custom/tmpfile" ];then rm ./steamapps/common/Synergy/synergy/custom/tmpfile ;fi
				fi
			fi
		fi
	fi
	./steamcmd.sh +@sSteamCmdForcePlatformType windows +login $stusername +force_install_dir ./steamapps/common/EZeroRen +app_update 714070 validate +quit
	if [ -d "./steamapps/common/EZeroRen/Entropy Zero/EntropyZero" ];then
		if [ ! -d "./steamapps/common/EntropyZero" ];then mkdir ./steamapps/common/EntropyZero ;fi
		mv ./steamapps/common/EZeroRen/Entropy\ Zero/EntropyZero ./steamapps/common/EntropyZero/EntropyZero
		rm -rf ./steamapps/common/EZeroRen
	fi
	if [ ! -f "./steamapps/common/Synergy/synergy/content/EntropyZero.dat" ];then wget -nv "https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/EntropyZero.dat" -P ./steamapps/common/Synergy/synergy/content ;fi
fi
updmods
}

instsourcepluginstop() {
echo "Install plugins for Regular, (B)eta, or (T)witch? (anything except b or t will do regular)"
read betaset
betaset=${betaset,,}
synpath="steamapps/common/Synergy/synergy"
if [ -z $betaset ];then betaset=reg ;fi
if [ $betaset = "b" ];then synpath="steamapps/common/synbeta/synergy";fi
if [ $betaset = "t" ];then synpath="steamapps/common/syntwitch/synergy";fi
if [ ! -d $synpath ];then notinstalled;fi
instsourceplugins
}

instsourceplugins() {
echo "Add SP to any of the following to get the sp file of each."
echo "(M) to download fixed MapChooser  (N) to download fixed Nominations"
echo "(ML) to download ModelLoader      (GT) to download Goto"
echo "(V) to download VoteCar           (HD) to download HealthDisplay"
echo "(HYP) to download HyperSpawn      (ST) to download Save/Teleport"
echo "(SYN) to download SynFixes        (SSR) to download SynSaveRestore"
echo "(ET) to download EntTools         (FPD) to download FirstPersonDeaths"
echo "(SM) to download SynModes         (AUTO) to download AutoChangeMap"
echo "(CR) to download Synergy CrashMap (U) to download Updater with SteamWorks"
echo "(EDT) to download EDTRebuild, required for some supports."
echo "(SynDev) to download SynFixes Dev needed for Black Mesa entities"
echo "(SynSweps) to download Synergy Scripted Weapons also needed for BMS"
echo "You can get a full pack of these plugins with (FP) then remove ones that you dont need."
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
if [ $pluginsubstr = "edt" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/edtrebuild.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "edtsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/edtrebuild.sp" -P ./$synpath/addons/sourcemod/scripting
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
	wget -nv "https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/addons/sourcemod/plugins/updater.smx" -P ./$synpath/addons/sourcemod/plugins
	if [ -f ./$synpath/addons/sourcemod/extensions/SteamWorks.ext.so ];then rm -f ./$synpath/addons/sourcemod/extensions/SteamWorks.ext.so;fi
	curl -sqL "https://users.alliedmods.net/~kyles/builds/SteamWorks/SteamWorks-git121-linux.tar.gz" | tar zxvf - -C ./$synpath
	if [ -f ./$synpath/addons/sourcemod/extensions/SteamWorks.ext.so ];then echo "Installed SteamWorks";fi
	if [ -f ./$synpath/addons/sourcemod/plugins/updater.smx ];then echo "Installed Updater";fi
fi
if [ $pluginsubstr = "b" ];then start;fi
instsourceplugins
}

instplr() {
if [ ! -d ./steamapps/common/Synergy/synergy/addons/plr ]; then
	if [ -d ./steamapps/common/Synergy/synergy/addons/metamod ]; then
		mkdir ./steamapps/common/Synergy/synergy/addons/plr
		wget -nv "https://raw.githubusercontent.com/FoG-Plugins/Player-Limit-Remover/master/addons/plr.vdf" -P ./steamapps/common/Synergy/synergy/addons
		wget -nv "https://github.com/FoG-Plugins/Player-Limit-Remover/raw/master/addons/plr/plr.so" -P ./steamapps/common/Synergy/synergy/addons/plr
	fi
fi
if [ -f ./steamapps/common/Synergy/synergy/addons/plr/plr.so ]; then
	if [ -f ./steamapps/common/Synergy/synergy/addons/plr.vdf ]; then
		echo "Successfully installed PLR"
	fi
fi
start
}

instpmpck() {
echo "Install Player Model Packs for Regular, (B)eta, or (T)witch? (anything except b or t will do regular)"
read betaset
betaset=${betaset,,}
if [ -z $betaset ];then betaset="regular";fi
synpath="steamapps/common/Synergy/synergy"
if [ $betaset = "b" ];then synpath="steamapps/common/synbeta/synergy";fi
if [ $betaset = "t" ];then synpath="steamapps/common/syntwitch/synergy";fi
if [ ! -d $synpath ];then notinstalled;fi
instpmpckpass
}

instpmpckpass() {
if [ ! -d "./steamapps/workshop" ];then mkdir "./steamapps/workshop" ;fi
if [ ! -d "./steamapps/workshop/content" ];then mkdir "./steamapps/workshop/content" ;fi
if [ ! -d "./steamapps/workshop/content/17520" ];then
	if [ ! -L "./steamapps/workshop/content/17520" ];then
		mkdir "./steamapps/workshop/content/17520"
		touch ./steamapps/workshop/content/17520/tmpfile
	fi
fi
if [ ! -L "./steamapps/workshop/content/17520" ];then
	rsync --remove-source-files -a ./steamapps/workshop/content/17520/* ./steamapps/common/Synergy/synergy/custom
	rm -rf ./steamapps/workshop/content/17520
	ln -s "../../common/Synergy/synergy/custom" "./steamapps/workshop/content/17520"
	if [ -f "./steamapps/common/Synergy/synergy/custom/tmpfile" ];then rm ./steamapps/common/Synergy/synergy/custom/tmpfile ;fi
fi
pmpck1="0"
pmpck2="0"
pmpck3="0"
pmpck4="0"
pmpck5="0"
if [ -f "$cldir/workshop/content/17520/646159916/646159916_pak.vpk" ];then pmpck1="1" ;fi
if [ -f "$cldir/workshop/content/17520/703682251/703682251_pak.vpk" ];then pmpck2="1" ;fi
if [ -f "$cldir/workshop/content/17520/2014781572/2014781572_pak.vpk" ];then pmpck3="1" ;fi
if [ -f "$cldir/workshop/content/17520/2014781572/2014781572_pak.vpk" ];then pmpck4="1" ;fi
if [ -f "$cldir/workshop/content/17520/1133952585/1133952585_pak.vpk" ];then pmpck5="1" ;fi
if [ -f "./steamapps/workshop/content/17520/646159916/646159916_pak.vpk" ];then pmpck1="2" ;fi
if [ -f "./steamapps/workshop/content/17520/703682251/703682251_pak.vpk" ];then pmpck2="2" ;fi
if [ -f "./steamapps/workshop/content/17520/2014781572/2014781572_pak.vpk" ];then pmpck3="2" ;fi
if [ -f "./steamapps/workshop/content/17520/2014781572/2014781572_pak.vpk" ];then pmpck4="2" ;fi
if [ -f "./steamapps/workshop/content/17520/1133952585/1133952585_pak.vpk" ];then pmpck5="2" ;fi
if [ "$pmpck1" = "1" ];then echo "Player Model Pack 1 detected in CL workshop dir.";fi
if [ "$pmpck2" = "1" ];then echo "Player Model Pack 2 detected in CL workshop dir.";fi
if [ "$pmpck3" = "1" ];then echo "Player Model Pack 3 and 4 detected in CL workshop dir.";fi
if [ "$pmpck5" = "1" ];then echo "Player Model Pack 5 detected in CL workshop dir.";fi
if [ "$pmpck1" = "2" ];then echo "Player Model Pack 1 installed.";fi
if [ "$pmpck2" = "2" ];then echo "Player Model Pack 2 installed.";fi
if [ "$pmpck3" = "2" ];then echo "Player Model Pack 3 and 4 installed.";fi
if [ "$pmpck5" = "2" ];then echo "Player Model Pack 5 installed.";fi
if [ "$pmpck1" = "1" ];then echo "(1) To install Pack 1 to your server.";fi
if [ "$pmpck2" = "1" ];then echo "(2) To install Pack 2 to your server.";fi
if [ "$pmpck3" = "1" ];then echo "(3) To install Pack 3 and 4 to your server.";fi
if [ "$pmpck5" = "1" ];then echo "(5) To install Pack 5 to your server.";fi
if [ "$pmpck1" = "0" ];then echo "(DL1) to download Pack 1.";fi
if [ "$pmpck2" = "0" ];then echo "(DL2) to download Pack 2.";fi
if [ "$pmpck3" = "0" ];then echo "(DL3) to download Pack 3 and 4.";fi
if [ "$pmpck5" = "0" ];then echo "(DL5) to download Pack 5.";fi
echo "(B) to go back to start."
read pmpckopt
if [ -z $pmpckopt ];then pmpckopt="notset";fi
pmpckopt=${pmpckopt,,}
if [ $pmpckopt = "b" ]; then start ;fi
if [ $pmpckopt = "dl1" ]; then ./steamcmd.sh +login anonymous +workshop_download_item 17520 646159916 +quit;fi
if [ $pmpckopt = "dl2" ]; then ./steamcmd.sh +login anonymous +workshop_download_item 17520 703682251 +quit;fi
if [ $pmpckopt = "dl3" ]; then ./steamcmd.sh +login anonymous +workshop_download_item 17520 2014781572 +quit;fi
if [ $pmpckopt = "dl4" ]; then ./steamcmd.sh +login anonymous +workshop_download_item 17520 2014781572 +quit;fi
if [ $pmpckopt = "dl5" ]; then ./steamcmd.sh +login anonymous +workshop_download_item 17520 1133952585 +quit;fi
if [ $pmpckopt = "1" ]; then
	if [ -f "./steamapps/workshop/content/17520/646159916/646159916_pak.vpk" ]; then
		echo "Already installed."
		instpmpckpass
	fi
	if [ ! -d "./steamapps/workshop/content/17520/646159916" ]; then mkdir "./steamapps/workshop/content/17520/646159916";fi
	cp "$cldir/workshop/content/17520/646159916/646159916_pak.vpk" "./steamapps/workshop/content/17520/646159916/646159916_pak.vpk"
fi
if [ $pmpckopt = "2" ]; then
	if [ -f "./steamapps/workshop/content/17520/703682251/703682251_pak.vpk" ]; then
		echo "Already installed."
		instpmpckpass
	fi
	if [ ! -d "./steamapps/workshop/content/17520/703682251" ]; then mkdir "./steamapps/workshop/content/17520/703682251";fi
	cp "$cldir/workshop/content/17520/703682251/703682251_pak.vpk" "./steamapps/workshop/content/17520/703682251/703682251_pak.vpk"
fi
if [ $pmpckopt = "3" ]; then
	if [ -f "./steamapps/workshop/content/17520/2014781572/2014781572_pak.vpk" ]; then
		echo "Already installed."
		instpmpckpass
	fi
	if [ ! -d "./steamapps/workshop/content/17520/2014781572" ]; then mkdir "./steamapps/workshop/content/17520/2014781572";fi
	cp "$cldir/workshop/content/17520/2014781572/2014781572_pak.vpk" "./steamapps/workshop/content/17520/2014781572/2014781572_pak.vpk"
fi
if [ $pmpckopt = "4" ]; then
	if [ -f "./steamapps/workshop/content/17520/2014781572/2014781572_pak.vpk" ]; then
		echo "Already installed."
		instpmpckpass
	fi
	if [ ! -d "./steamapps/workshop/content/17520/2014781572" ]; then mkdir "./steamapps/workshop/content/17520/2014781572";fi
	cp "$cldir/workshop/content/17520/2014781572/2014781572_pak.vpk" "./steamapps/workshop/content/17520/2014781572/2014781572_pak.vpk"
fi
if [ $pmpckopt = "5" ]; then
	if [ -f "./steamapps/workshop/content/17520/1133952585/1133952585_pak.vpk" ]; then
		echo "Already installed."
		instpmpckpass
	fi
	if [ ! -d "./steamapps/workshop/content/17520/1133952585" ]; then mkdir "./steamapps/workshop/content/17520/1133952585";fi
	cp "$cldir/workshop/content/17520/1133952585/1133952585_pak.vpk" "./steamapps/workshop/content/17520/1133952585/1133952585_pak.vpk"
fi
instpmpckpass
}

modifysmadmin() {
if [ ! -f ./steamapps/common/Synergy/synergy/addons/sourcemod/configs/admins_simple.ini ]; then
	echo "You do not have an admins file."
	start
fi
if [ ! -z $EDITOR ];then
	$EDITOR ./steamapps/common/Synergy/synergy/addons/sourcemod/configs/admins_simple.ini
elif [ ! -z $VISUAL ];then
	$VISUAL ./steamapps/common/Synergy/synergy/addons/sourcemod/configs/admins_simple.ini
elif [ -f /bin/nano ];then
	nano ./steamapps/common/Synergy/synergy/addons/sourcemod/configs/admins_simple.ini
elif [ -f /usr/bin/gedit ];then
	gedit ./steamapps/common/Synergy/synergy/addons/sourcemod/configs/admins_simple.ini
else
	vi ./steamapps/common/Synergy/synergy/addons/sourcemod/configs/admins_simple.ini
fi
start
}

start

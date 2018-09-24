#!/bin/bash
cldir=$HOME/.Steam/steamapps
if [ ! -d $cldir ]; then
	if [ -d /Steam/steamapps ]; then
		cldir=/Steam/steamapps
	fi
	if [ -d $HOME/Steam/steamapps ]; then
		cldir=$HOME/Steam/steamapps
	fi
	if [ -d $HOME/steam/steamapps ]; then
		cldir=$HOME/steam/steamapps
	fi
	if [ -d $HOME/Library/Application\ Support/Steam/SteamApps ]; then
		cldir=$HOME/Library/Application\ Support/Steam/SteamApps
	fi
	if [ ! -d $cldir ]; then
		cldir=none
	fi
fi

missingdeps() {
echo "You are missing dependencies for Steam"
echo "Use $packageinf"
echo "Then restart this script."
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
	if [[ $missinglib = "1" ]];then
		packageinf="sudo dnf install glibc libstdc++"
		missingdeps
	fi
fi

start() {
anonset=0
if [ ! -f ./steamcmd.sh ];then notindir; fi
echo "Information: enter the letter inside the () and press enter to continue at the prompts."
echo "First (I)nstall, (U)pdate, (R)un with auto-restart"
echo "(RB) to run Synergy 18.7 beta, (RT) to run Synergy Twitch branch."
echo "(IS) to install SourceMod."
if [ -d ./steamapps/common/Synergy/synergy/addons/sourcemod/plugins ]; then echo "(ISM) to install additional SourceMod plugins."; fi
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
echo "This function is designed for the current version of Synergy, the development branch may be unstable."
echo "Install SourceMod for Regular, (B)eta, or (T)witch? (anything except b or t will do regular)"
read betaset
betaset=${betaset,,}
if [ -z $betaset ];then betaset="r" ;fi
syntype="reg"
synpath="steamapps/common/Synergy/synergy"
if [ $betaset = "b" ];then
	synpath="steamapps/common/synbeta/synergy";
	syntype="nonstand"
fi
if [ $betaset = "t" ];then
	synpath="steamapps/common/syntwitch/synergy";
	syntype="nonstand"
fi
if [ ! -d $synpath ];then notinstalled;fi
echo "This will direct download the required SourceMod files and then extract them."
read nullptr
if [ -d ./$synpath/addons/sourcemod ];then
	echo "SourceMod is already installed, if you want to re-install, rename the current SourceMod install and re-run this script."
	read nullptr
	start
fi
curl -sqL "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6329-linux.tar.gz" | tar zxvf - -C ./$synpath
curl -sqL "https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git966-linux.tar.gz" | tar zxvf - -C ./$synpath
curl -sqL "https://users.alliedmods.net/~kyles/builds/SteamWorks/SteamWorks-git126-linux.tar.gz" | tar zxvf - -C ./$synpath
if [ ! -d ./$synpath/addons/sourcemod ];then
	echo "Failed to auto-install SourceMod, you may have to manually install it."
	read nullptr
	start
fi
if [ $syntype = "nonstand" ];then
	if [ ! -d ./$synpath/addons/sourcemod/gamedata/sdkhooks.games/custom ];then
		mkdir ./$synpath/addons/sourcemod/gamedata/sdkhooks.games/custom
	fi
	if [ ! -d ./$synpath/addons/sourcemod/gamedata/sdktools.games/custom ];then
		mkdir ./$synpath/addons/sourcemod/gamedata/sdktools.games/custom
	fi
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/devtwitchgamedata/sdkhooks.games/custom/game.synergy.txt" -P ./$synpath/addons/sourcemod/gamedata/sdkhooks.games/custom
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/devtwitchgamedata/sdktools.games/custom/game.synergy.txt" -P ./$synpath/addons/sourcemod/gamedata/sdktools.games/custom
fi
# remove nextmap as it does not work in Synergy
rm -f ./$synpath/addons/sourcemod/plugins/nextmap.smx
echo "SourceMod installed, you can put plugins in ./$synpath/addons/sourcemod/plugins"
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
if [ $betaset = "b" ];then betainst;fi
if [ $betaset = "t" ];then twitchinst;fi
echo "Updating/installing Synergy DS"
./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/Synergy +app_update 17520 validate +quit
echo "Update/installation Complete"
echo "If there were errors above, close the script and log in to steamcmd.sh separately, then restart the script."
if [ $uprun = "i" ];then setup;fi
srcds
}

noanon() {
echo "You cannot use anonymous to install Synergy..."
anonset=1
firstinstall
}

twitchinst() {
echo "Updating/installing Synergy Twitch Branch DS"
./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/syntwitch +app_update 17520 -beta twitch -betapassword jonnyhawtsauce -validate +quit
echo "Update/installation Complete"
echo "If there were errors above, close the script and log in to steamcmd.sh separately, then restart this script."
if [ $uprun = "i" ];then setup;fi
uprun="t"
srcds
}

betainst() {
echo "Updating/installing Synergy Beta DS"
./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/synbeta +app_update 17520 -beta development -validate +quit
echo "Update/installation Complete"
echo "If there were errors above, close the script and log in to steamcmd.sh separately, then restart this script."
if [ $uprun = "i" ];then setup;fi
uprun="b"
srcds
}

setup() {
s=1
hl=1
echo "Setting up links and first settings in server2.cfg"
if [ ! -d $cldir/sourcemods ];then s=0;fi
if [ ! -d $cldir/common/Half-Life\ 2 ];then hl=0;fi
if [ hl = 0 ];then if [ -d ./steamapps/common/Half-Life\ 2 ];then hl=2;fi;fi
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
if [ ! -f $synpath/synergy/cfg/server2.cfg ];then
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
echo "Should be all configured for server running, starting after timeout."
sleep 5
srcds
}

srcds() {
synpath="steamapps/common/Synergy"
if [ $uprun = "rb" ];then synpath="steamapps/common/synbeta";fi
if [ $uprun = "b" ];then synpath="steamapps/common/synbeta";fi
if [ $uprun = "rt" ];then synpath="steamapps/common/syntwitch";fi
if [ $uprun = "t" ];then synpath="steamapps/common/syntwitch";fi
if [ ! -f ./$synpath/srcds_run ];then notinstalled;fi
if [ ! -d ./steamapps/common/Half-Life\ 2 ];then insthl2;fi
if [ ! -L ./$synpath/bin/libtier0.so ];then
	mv ./$synpath/bin/libtier0.so ./$synpath/bin/libtier0.so.bak
	ln -s libtier0_srv.so ./$synpath/bin/libtier0.so
fi
if [ ! -L ./$synpath/bin/libvstdlib.so ];then
	mv ./$synpath/bin/libvstdlib.so ./$synpath/bin/libvstdlib.so.bak
	ln -s libvstdlib_srv.so ./$synpath/bin/libvstdlib.so
fi
reds
}

reds() {
curdatetime=$(date -u)
echo "$curdatetime SynDS started."
./$synpath/srcds_run -game synergy -console +maxplayers 10 +sv_lan 0 +map d1_trainstation_06 +exec server2.cfg -ip 0.0.0.0 -port 27015 -nocrashdialog -insecure -nohltv
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
echo "Half-Life 2 was not found during setup, press any key to install it, or close the script and install it manually."
echo "You can also install Ep1 with 1, Ep2 with 2 (will also install Ep1 and HL2), or 3 for HL2, Ep1, Ep2, and Half-Life Source."
read hllist
hllist=${hllist,,}
re='^[0-9]+$'
if [ -z $hllist ];then hllist=0 ;fi
if ! [[ $hllist =~ $re ]];then hllist=0 ;fi
./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/Half-Life\ 2 +app_update 220 validate +quit
if [ $hllist > 0 ];then
	./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/Half-Life\ 2/episodic +app_update 380 validate +quit
fi
if [ $hllist > 1 ];then
	./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/Half-Life\ 2/ep2 +app_update 420 validate +quit
fi
if [ $hllist > 2 ];then
	./steamcmd.sh +login $stusername +force_install_dir ./steamapps/common/Half-Life\ 2/hl1 +app_update 280 validate +quit
fi
if [ -d ./steamapps/common/Half-Life\ 2 ];then setup;fi
echo "Something went wrong with installing HL2, restarting script."
start
}

instsourcepluginstop() {
echo "Install plugins for Regular, (B)eta, or (T)witch? (anything except b or t will do regular)"
read betaset
betaset=${betaset,,}
synpath="steamapps/common/Synergy/synergy"
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
echo "(SYN) to download SynFixes"
echo "Some plugins will also require their translation files, you can get a full pack of these plugins with (FP)"
echo "(B) to go back to start"
read pluginsubstr
pluginsubstr=${pluginsubstr,,}
if [ $pluginsubstr = "m" ];then
	rm -f ./$synpath/addons/sourcemod/plugins/mapchooser.smx
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/mapchooser.smx" -P ./$synpath/addons/sourcemod/plugins
	if [ ! -f ./$synpath/cfg/mapcyclecfg.txt ];then
		cat ./$synpath/mapcycle.txt | grep d1>./$synpath/cfg/mapcyclecfg.txt
		cat ./$synpath/mapcycle.txt | grep d2>>./$synpath/cfg/mapcyclecfg/txt
		cat ./$synpath/mapcycle.txt | grep d3>>./$synpath/cfg/mapcyclecfg.txt
		cat ./$synpath/mapcycle.txt | grep ep1_>>./$synpath/cfg/mapcyclecfg.txt
		cat ./$synpath/mapcycle.txt | grep ep2_>>./$synpath/cfg/mapcyclecfg.txt
	fi
	echo "Installed!"
fi
if [ $pluginsubstr = "n" ];then
	rm -f ./$synpath/addons/sourcemod/plugins/nominations.smx
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
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/modelloader.smx" -P ./$synpath/addons/sourcemod/plugins
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/chi/modelloader.phrases.txt" -P ./$synpath/addons/sourcemod/translations/chi
	if [ -f ./$synpath/addons/sourcemod/translations/modelloader.phrases ];then echo "Installed!";fi
fi
if [ $pluginsubstr = "mlsp" ];then echo "SP file not available for this plugin, sorry.";fi
if [ $pluginsubstr = "gt" ];then
	wget -nv "http://www.sourcemod.net/vbcompiler.php?file_id=58625" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "gtsp" ];then
	wget -nv "http://www.forums.alliedmods.net/attachment.php?attachmentid=58625" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "v" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/votecar.smx" -P ./$synpath/addons/sourcemod/plugins
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/translations/votecar.phrases.txt" -P ./$synpath/addons/sourcemod/translations
fi
if [ $pluginsubstr = "vsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/votecar.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "fp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/archive/master.zip" -P .
	unzip -qq ./master.zip -d ./$synpath/addons/sourcemod
	rsync --remove-source-files -a ./$synpath/addons/sourcemod/SM-Synergy-master/* ./$synpath/addons/sourcemod
	rm -f ./master.zip
	rm -rf ./$synpath/addons/sourcemod/SM-Synergy-master
	echo "Installed!"
fi
if [ $pluginsubstr = "hd" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/healthdisplay.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "hdsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/healthdisplay.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "hyp" ];then
	wget -nv "https://github.com/Sarabveer/SM-Plugins/raw/master/hyperspawn/plugins/hyperspawn.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "hypsp" ];then
	wget -nv "https://github.com/Sarabveer/SM-Plugins/raw/master/hyperspawn/scripting/hyperspawn.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "st" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/syn_tp.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "stsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/syn_tp.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "syn" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/plugins/synfixes.smx" -P ./$synpath/addons/sourcemod/plugins
fi
if [ $pluginsubstr = "synsp" ];then
	wget -nv "https://github.com/Balimbanana/SM-Synergy/raw/master/scripting/synfixes.sp" -P ./$synpath/addons/sourcemod/scripting
fi
if [ $pluginsubstr = "b" ];then start;fi
instsourceplugins
}

start

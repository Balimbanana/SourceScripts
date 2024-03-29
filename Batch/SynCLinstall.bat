@echo off
rem This script was written by Balimbanana.
title SynergyCL Launcher
if EXIST "drivers\etc\hosts" cd %~dp0
if '%cd%'=='%userprofile%\Downloads' (
	if NOT EXIST SynergyCL mkdir SynergyCL
	cd SynergyCL
	if NOT EXIST SynCLinstall.bat copy ..\SynCLinstall.bat SynCLinstall.bat>NUL
)
goto setupinit
:updater
cd "%~dp0"
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://github.com/Balimbanana/SourceScripts/raw/master/Batch/SynCLinstall.bat\",\"$PWD\SynCLinstall.bat\") }"
echo Updated...
start /b "Install SourceMods" "%~dp0SynCLinstall.bat"
exit
:setupinit
set pmpck1=0
set pmpck2=0
set pmpck3=0
set pmpck4=0
set pmpck5=0
set betaset="reg"
set usrname=""
set synpath=steamapps\common\Synergy
set cldir=%programfiles(x86)%\Steam\steamapps
set betadir=%programfiles(x86)%\Steam\steamapps
set twitchdir=%programfiles(x86)%\Steam\steamapps
set devpdir=%programfiles(x86)%\Steam\steamapps
set cldir=%programfiles(x86)%\Steam\steamapps
for /f "skip=2 tokens=1,2* delims== " %%i in ('reg QUERY HKEY_CURRENT_USER\Software\Valve\Steam /f SteamPath /t REG_SZ /v') do (
	set "cldir=%%k"
	goto start
)
:start
for /f "delims=" %%V in ('powershell -command "$env:cldir.Replace(\"/\",\"\\\")"') do set "cldir=%%V"
for /f "delims=" %%V in ('powershell -command "$env:cldir.Replace(\"programfiles\",\"\Program Files\")"') do set "cldir=%%V"
if EXIST "C:\SteamLibrary\steamapps\common\Synergy\synergy" set cldir=C:\SteamLibrary
if EXIST "E:\SteamLibrary\steamapps\common\Synergy\synergy" set cldir=E:\SteamLibrary
if EXIST "D:\SteamLibrary\steamapps\common\Synergy\synergy" set cldir=D:\SteamLibrary
if EXIST "F:\SteamLibrary\steamapps\common\Synergy\synergy" set cldir=F:\SteamLibrary
if EXIST "G:\SteamLibrary\steamapps\common\Synergy\synergy" set cldir=G:\SteamLibrary
if EXIST "C:\SteamLibrary\steamapps\common\synbeta\synergy" set betadir=C:\SteamLibrary
if EXIST "E:\SteamLibrary\steamapps\common\synbeta\synergy" set betadir=E:\SteamLibrary
if EXIST "D:\SteamLibrary\steamapps\common\synbeta\synergy" set betadir=D:\SteamLibrary
if EXIST "F:\SteamLibrary\steamapps\common\synbeta\synergy" set betadir=F:\SteamLibrary
if EXIST "G:\SteamLibrary\steamapps\common\synbeta\synergy" set betadir=G:\SteamLibrary
if EXIST "C:\SteamLibrary\steamapps\common\syntwitch\synergy" set twitchdir=C:\SteamLibrary
if EXIST "E:\SteamLibrary\steamapps\common\syntwitch\synergy" set twitchdir=E:\SteamLibrary
if EXIST "D:\SteamLibrary\steamapps\common\syntwitch\synergy" set twitchdir=D:\SteamLibrary
if EXIST "F:\SteamLibrary\steamapps\common\syntwitch\synergy" set twitchdir=F:\SteamLibrary
if EXIST "G:\SteamLibrary\steamapps\common\syntwitch\synergy" set twitchdir=G:\SteamLibrary
if EXIST "C:\Steam\steamapps\common\Synergy\synergy" set cldir=C:\Steam
if EXIST "E:\Steam\steamapps\common\Synergy\synergy" set cldir=E:\Steam
if EXIST "D:\Steam\steamapps\common\Synergy\synergy" set cldir=D:\Steam
if EXIST "F:\Steam\steamapps\common\Synergy\synergy" set cldir=F:\Steam
if EXIST "G:\Steam\steamapps\common\Synergy\synergy" set cldir=G:\Steam
if EXIST "C:\Steam\steamapps\common\synbeta\synergy" set betadir=C:\Steam
if EXIST "E:\Steam\steamapps\common\synbeta\synergy" set betadir=E:\Steam
if EXIST "D:\Steam\steamapps\common\synbeta\synergy" set betadir=D:\Steam
if EXIST "F:\Steam\steamapps\common\synbeta\synergy" set betadir=F:\Steam
if EXIST "G:\Steam\steamapps\common\synbeta\synergy" set betadir=G:\Steam
if EXIST "C:\Steam\steamapps\common\syntwitch\synergy" set twitchdir=C:\Steam
if EXIST "E:\Steam\steamapps\common\syntwitch\synergy" set twitchdir=E:\Steam
if EXIST "D:\Steam\steamapps\common\syntwitch\synergy" set twitchdir=D:\Steam
if EXIST "F:\Steam\steamapps\common\syntwitch\synergy" set twitchdir=F:\Steam
if EXIST "G:\Steam\steamapps\common\syntwitch\synergy" set twitchdir=G:\Steam
if EXIST "C:\SteamLibrary\steamapps\common\syndevp\synergy" set devpdir=C:\SteamLibrary
if EXIST "E:\SteamLibrary\steamapps\common\syndevp\synergy" set devpdir=E:\SteamLibrary
if EXIST "D:\SteamLibrary\steamapps\common\syndevp\synergy" set devpdir=D:\SteamLibrary
if EXIST "F:\SteamLibrary\steamapps\common\syndevp\synergy" set devpdir=F:\SteamLibrary
if EXIST "G:\SteamLibrary\steamapps\common\syndevp\synergy" set devpdir=G:\SteamLibrary
if EXIST "C:\Steam\steamapps\common\syndevp\synergy" set devpdir=C:\Steam
if EXIST "E:\Steam\steamapps\common\syndevp\synergy" set devpdir=E:\Steam
if EXIST "D:\Steam\steamapps\common\syndevp\synergy" set devpdir=D:\Steam
if EXIST "F:\Steam\steamapps\common\syndevp\synergy" set devpdir=F:\Steam
if EXIST "G:\Steam\steamapps\common\syndevp\synergy" set devpdir=G:\Steam
if NOT EXIST "%cldir%\steamapps\common\Synergy\synergy" (
	echo ^CL Directory not found...
	set cldir=%cd%
	pause
)
if EXIST synergy.exe (if EXIST "..\..\..\steamcmd.exe" cd "..\..\.." )
set anonset=0
set linkhl=0
if NOT EXIST steamcmd.exe goto notindir
if NOT EXIST steamapps mkdir steamapps
if NOT EXIST steamapps\common mkdir steamapps\common
if NOT EXIST steamapps\common\Synergy (
	if EXIST "%cldir%\steamapps\common\Synergy" mklink /j "steamapps\common\Synergy" "%cldir%\steamapps\common\Synergy">NUL
)
if NOT EXIST steamapps\common\synbeta (
	if EXIST "%betadir%\steamapps\common\synbeta" mklink /j "steamapps\common\synbeta" "%betadir%\steamapps\common\synbeta">NUL
)
if NOT EXIST steamapps\common\syntwitch (
	if EXIST "%twitchdir%\steamapps\common\syntwitch" mklink /j "steamapps\common\syntwitch" "%twitchdir%\steamapps\common\syntwitch">NUL
)
if NOT EXIST steamapps\common\syndevp (
	if EXIST "%devpdir%\steamapps\common\syndevp" mklink /j "steamapps\common\syndevp" "%devpdir%\steamapps\common\syndevp">NUL
)
if NOT EXIST "steamapps\common\Half-Life 2" (
	if EXIST "%betadir%\steamapps\common\Half-Life 2" set linkhl=2
	if EXIST "%twitchdir%\steamapps\common\Half-Life 2" set linkhl=3
	if EXIST "%cldir%\steamapps\common\Half-Life 2" set linkhl=1
)
if '%linkhl%'=='1' mklink /j "steamapps\common\Half-Life 2" "%cldir%\steamapps\common\Half-Life 2">NUL
if '%linkhl%'=='2' mklink /j "steamapps\common\Half-Life 2" "%betadir%\steamapps\common\Half-Life 2">NUL
if '%linkhl%'=='3' mklink /j "steamapps\common\Half-Life 2" "%twitchdir%\steamapps\common\Half-Life 2">NUL
set linkhl=0
if NOT EXIST "steamapps\sourcemods" (
	if EXIST "%betadir%\steamapps\sourcemods" set linkhl=2
	if EXIST "%twitchdir%\steamapps\sourcemods" set linkhl=3
	if EXIST "%cldir%\steamapps\sourcemods" set linkhl=1
)
if '%linkhl%'=='1' mklink /j "steamapps\sourcemods" "%cldir%\steamapps\sourcemods">NUL
if '%linkhl%'=='2' mklink /j "steamapps\sourcemods" "%betadir%\steamapps\sourcemods">NUL
if '%linkhl%'=='3' mklink /j "steamapps\sourcemods" "%twitchdir%\steamapps\sourcemods">NUL
set linkhl=0
echo Information: enter the letter inside the () and press enter to continue at the prompts.
echo (U)pdate or (R)un 56.16 (RB) To run Synergy 18.x beta (RT) To run Synergy Twich branch.
echo (RP) to run Synergy Portal beta. (update) to update this script.
echo (IMP) to install the Player Model Packs
set /p uprun=
for /f "delims=" %%V in ('powershell -command "$env:uprun.ToLower()"') do set "uprun=%%V"
if "%uprun%"=="u" goto firstinstall
if "%uprun%"=="rb" goto synstart
if "%uprun%"=="rt" goto synstart
if "%uprun%"=="rp" goto synstart
if "%uprun%"=="r" goto synstart
if "%uprun%"=="imp" goto instpmpck
if "%uprun%"=="update" goto updater
echo Choose an option.
goto start

:firstinstall
if '%anonset%'=='0' (echo Regular, ^(B^)eta, ^(T^)witch, or ^(P^)ortal beta? ^(anything except b, t, or p will do regular^)
	set /p betaset=
)
for /f "delims=" %%V in ('powershell -command "$env:betaset.ToLower()"') do set "betaset=%%V"
if EXIST "%programfiles(x86)%\Steam" start /min /wait robocopy /NP /NJS /NJH /NS "%programfiles(x86)%\Steam" "." "ssfn*"
if EXIST "%cldir%" start /min /wait robocopy /NP /NJS /NJH /NS "%cldir%" "." "ssfn*"
echo Enter your username here:
set /p usrname=
set anonblck=""
for /f "delims=" %%i in ('powershell -command "$env:usrname.ToLower()"') do set anonblck=%%i
if "%anonblck%"=="anonymous" goto noanon
set synpath=steamapps\common\Synergy
if '%uprun%'=='rb' set synpath=steamapps\common\synbeta
if '%uprun%'=='rt' set synpath=steamapps\common\syntwitch
if '%uprun%'=='rp' set synpath=steamapps\common\syndevp
if '%betaset%'=='b' set synpath=steamapps\common\synbeta
if '%betaset%'=='t' set synpath=steamapps\common\syntwitch
if '%betaset%'=='p' set synpath=steamapps\common\syndevp
if NOT EXIST "%synpath%\synergy\synergy_pak.vpk" (
	if EXIST "%cldir%\steamapps\common\Synergy\synergy\synergy_pak.vpk" start /min /wait robocopy /NP /NJS /NJH /NS "%cldir%\steamapps\common\Synergy\synergy" "%synpath%\synergy" "synergy_pak.vpk"
)
if NOT EXIST "%synpath%\synergy\zhl2dm_materials_pak.vpk" (
	if EXIST "%cldir%\steamapps\common\Synergy\synergy\zhl2dm_materials_pak.vpk" start /min /wait robocopy /NP /NJS /NJH /NS "%cldir%\steamapps\common\Synergy\synergy" "%synpath%\synergy" "zhl2dm_materials_pak.vpk.vpk"
)
if NOT EXIST "%synpath%\synergy\maps" (
	if EXIST "%cldir%\steamapps\common\Synergy\synergy\maps" mklink /j "%synpath%\synergy\maps" "%cldir%\steamapps\common\Synergy\synergy\maps">NUL
)
if EXIST "%synpath%\synergy\content\aoc.dat" del "%synpath%\synergy\content\aoc.dat"
if EXIST "%synpath%\synergy\content\css.dat" del "%synpath%\synergy\content\css.dat"
if EXIST "%synpath%\synergy\content\dod.dat" del "%synpath%\synergy\content\dod.dat"
if EXIST "%synpath%\synergy\content\eternal.dat" del "%synpath%\synergy\content\eternal.dat"
if EXIST "%synpath%\synergy\content\hl2u.dat" del "%synpath%\synergy\content\hl2u.dat"
if EXIST "%synpath%\synergy\content\neotokyo.dat" del "%synpath%\synergy\content\neotokyo.dat"
if EXIST "%synpath%\synergy\content\SiN.dat" del "%synpath%\synergy\content\SiN.dat"
if EXIST "%synpath%\synergy\content\tf2.dat" del "%synpath%\synergy\content\tf2.dat"
if EXIST "%synpath%\synergy\content\zps.dat" del "%synpath%\synergy\content\zps.dat"
if '%betaset%'=='b' goto betainst
if '%betaset%'=='t' goto twitchinst
if '%betaset%'=='p' goto devpinst
if NOT EXIST steamcmd.exe goto notindir
echo Updating/installing Synergy 56.16
steamcmd.exe +login %usrname% +app_update 17520 validate +quit
if NOT EXIST steamapps\common\Synergy\synergy.exe (
	echo ^There was an error while attempting to download Synergy...
	set anonset=15
	goto firstinstall
)
echo Update/installation Complete
echo If there were errors states above, close the script and log into SteamCMD.exe separately, then restart the script.
timeout -T 10
if '%uprun%'=='i' goto setup
cls
:synstart
set synpath=steamapps\common\Synergy
if '%uprun%'=='rb' set synpath=steamapps\common\synbeta
if '%uprun%'=='rt' set synpath=steamapps\common\syntwitch
if '%uprun%'=='rp' set synpath=steamapps\common\syndevp
if '%betaset%'=='b' set synpath=steamapps\common\synbeta
if '%betaset%'=='t' set synpath=steamapps\common\syntwitch
if '%betaset%'=='p' set synpath=steamapps\common\syndevp
if NOT EXIST %synpath%\synergy.exe goto notinstalled
if NOT EXIST %synpath%\synergy\scripts\vgui_screens.txt start /min /wait powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://raw.githubusercontent.com/Balimbanana/SM-Synergy/master/scripts/vgui_screens.txt\",\"$PWD\$env:synpath\synergy\scripts\vgui_screens.txt\") }"
if NOT EXIST "steamapps\common\Half-Life 2\hl2\hl2_pak_dir.vpk" goto insthl2
ping localhost -n 1 >NUL
start /wait %synpath%\synergy.exe -game synergy -steam -novid -windowed -noborder +r_hunkalloclightmaps 0
goto start

:betainst
echo Updating/installing Synergy Beta
steamcmd.exe +login %usrname% +force_install_dir steamapps\Common\synbeta +app_update 17520 -beta development -validate +quit
if NOT EXIST steamapps\common\synbeta\synergy.exe (
	echo ^There was an error while attempting to download Synergy...
	set anonset=15
	goto firstinstall
)
echo Update/installation Complete
echo If there were errors above, close the script and log into SteamCMD.exe separately, then restart the script.
timeout -T 10
if '%uprun%'=='i' goto setup
cls
goto synstart

:twitchinst
echo Updating/installing Synergy Twitch Branch
steamcmd.exe +login %usrname% +force_install_dir steamapps\Common\syntwitch +app_update 17520 -beta twitch -validate +quit
if NOT EXIST steamapps\common\syntwitch\synergy.exe (
	echo ^There was an error while attempting to download Synergy...
	set anonset=15
	goto firstinstall
)
echo Update/installation Complete
echo If there were errors above, close the script and log into SteamCMD.exe separately, then restart the script.
timeout -T 10
if '%uprun%'=='i' goto setup
cls
goto synstart

:devpinst
echo Updating/installing Synergy Portal beta Branch
steamcmd.exe +login %usrname% +force_install_dir steamapps\Common\syndevp +app_update 17520 -beta development_portaltest -validate +quit
if NOT EXIST steamapps\common\syndevp\synergy.exe (
	echo ^There was an error while attempting to download Synergy...
	set anonset=15
	goto firstinstall
)
echo Update/installation Complete
echo If there were errors above, close the script and log into SteamCMD.exe separately, then restart the script.
timeout -T 10
if '%uprun%'=='i' goto setup
cls
goto synstart

:setup
set s=1
set hl=1
echo Setting up links and first settings
if NOT EXIST "%cldir%\steamapps\sourcemods" set s=0
if NOT EXIST "%cldir%\steamapps\common\Half-Life 2" set hl=0
if '%hl%'=='0' (if EXIST "steamapps\common\Half-Life 2" set hl=2)
if '%hl%'=='0' goto insthl2
if '%hl%'=='1' (if EXIST "steamapps\common\Half-Life 2" set hl=2)
if '%hl%'=='1' mklink /j "steamapps\common\Half-Life 2" "%cldir%\common\Half-Life 2"
if '%s%'=='0' echo sourcemods not found, not linking.
if '%s%'=='1' (if EXIST "steamapps\sourcemods" set s=2)
if '%s%'=='1' mklink /j "steamapps\sourcemods" "%cldir%\sourcemods"
set synpath=steamapps\common\Synergy
set syntype=56.16
if '%betaset%'=='b' (
	set synpath=steamapps\common\synbeta
	set syntype=18.x
)
if '%betaset%'=='t' (
	set synpath=steamapps\common\syntwitch
	set syntype=Twitch
)
if '%betaset%'=='p' (
	set synpath=steamapps\common\syndevp
	set syntype=Portal
)
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://github.com/Balimbanana/SM-Synergy/raw/master/scripts/weapon_betagun.txt\",\"$PWD\$env:synpath\synergy\scripts\weapon_betagun.txt\") }"
if NOT EXIST "%synpath%\synergy\models" mkdir "%synpath%\synergy\models"
if NOT EXIST "%synpath%\synergy\models\weapons" mkdir "%synpath%\synergy\models\weapons"
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/w_physics.phy\",\"$PWD\$env:synpath\synergy\models\weapons\w_physics.phy\") }"
if NOT EXIST "%synpath%\synergy\content" mkdir "%synpath%\synergy\content"
echo Should be all set up.
goto synstart

:insthl2
echo Half-Life 2 was not found during setup, press any key to install it first or close the script and install it manually.
pause
if EXIST "%programfiles(x86)%\Steam" start /min /wait robocopy /NP /NJS /NJH /NS "%programfiles(x86)%\Steam" "." "ssfn*"
if EXIST "%cldir%" start /min /wait robocopy /NP /NJS /NJH /NS "%cldir%" "." "ssfn*"
if '%usrname%'=='""' (
	echo ^Enter your username here:
	set /p usrname=
)
set anonblck=""
for /f "delims=" %%i in ('powershell -command "$env:usrname.ToLower()"') do set anonblck=%%i
if "%anonblck%"=="anonymous" (
	set anonset=2
	goto noanon
)
steamcmd.exe +login %usrname% +app_update 220 validate +quit
steamcmd.exe +login %usrname% +app_update 380 validate +quit
steamcmd.exe +login %usrname% +app_update 420 validate +quit
if EXIST "steamapps\common\Half-Life 2" goto setup
goto notconfigured
:notconfigured
echo Half-Life 2 directory was not found in default install location, install halted.
pause
exit
:notinstalled
set syntype=56.16
if '%uprun%'=='rb' set syntype=Beta
if '%betaset%'=='b' set syntype=Beta
if '%uprun%'=='rt' set syntype=Twitch
if '%betaset%'=='t' set syntype=Twitch
if '%uprun%'=='rp' set syntype=Portal
if '%betaset%'=='p' set syntype=Portal
echo Synergy %syntype% not installed.
pause
goto start
:notindir
set foundcmd=0
goto dlsteamcmd

:dlsteamcmd
if EXIST "%cd%\steamcmd.zip" set foundcmd=1
if EXIST "%cd%\steamcmd.zip" goto extractcmd
if EXIST "%userprofile%\downloads\steamcmd.zip" set foundcmd=2
if EXIST "%userprofile%\downloads\steamcmd.zip" goto extractcmd
if '%foundcmd%'=='0' start /wait /min powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip\",\"$PWD\steamcmd.zip\") }"
if EXIST "%cd%\steamcmd.zip" set foundcmd=1
if EXIST "%cd%\steamcmd.zip" goto extractcmd
if EXIST "%userprofile%\downloads\steamcmd.zip" set foundcmd=2
if EXIST "%userprofile%\downloads\steamcmd.zip" goto extractcmd
goto extractcmd

:extractcmd
ping localhost -n 1 >NUL
if EXIST steamcmd.exe goto start
if '%foundcmd%'=='1' start /wait /min powershell -command "& {Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory(\"$PWD\steamcmd.zip\", \"$PWD\") }"
if '%foundcmd%'=='2' start /wait /min powershell -command "& {Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory(\"$HOME\downloads\steamcmd.zip\", \"$PWD\") }"
if EXIST steamcmd.exe (
	goto start
)
if EXIST "C:\Program Files\7-Zip\7z.exe" (
	if '%foundcmd%'=='1' (
		start /min /wait "7z" "C:\Program Files\7-Zip\7z.exe" x steamcmd.zip
	)
	if '%foundcmd%'=='2' (
		start /min /wait "7z" "C:\Program Files\7-Zip\7z.exe" x "%userprofile%\downloads\steamcmd.zip"
	)
)
goto start

:instpmpck
echo Install Player Model Packs for Regular, (B)eta, (T)witch, or (P)ortal beta? (anything except b, t, or p will do regular)
set synpath=steamapps\common\Synergy
set /p betaset=
for /f "delims=" %%V in ('powershell -command "$env:betaset.ToLower()"') do set "betaset=%%V"
if '%betaset%'=='b' set synpath=steamapps\common\synbeta
if '%betaset%'=='t' set synpath=steamapps\common\syntwitch
if '%betaset%'=='p' set synpath=steamapps\common\syndevp
goto instpmpckpass

:instpmpckpass
set linkset=0
if NOT EXIST "steamapps\workshop" mkdir "steamapps\workshop"
if NOT EXIST "steamapps\workshop\content" mkdir "steamapps\workshop\content"
if NOT EXIST "steamapps\workshop\content\17520" mkdir "steamapps\workshop\content\17520"
ping localhost -n 1 >NUL
fsutil reparsepoint query "steamapps\workshop\content\17520" | find "Mount Point" >nul && set "linkset=1" || set "linkset=0"
set linkdir=%cldir%
if EXIST "%cldir%\steamapps\workshop\content\17520" set linkdir=%cldir%
if EXIST "%betadir%\steamapps\workshop\content\17520" set linkdir=%betadir%
if EXIST "%twitchdir%\steamapps\workshop\content\17520" set linkdir=%twitchdir%
if '%linkset%'=='0' (
	start /wait /min robocopy /S /NP /NJS /NJH /NS "steamapps\workshop\content\17520" "steamapps\common\Synergy\synergy\custom"
	rd /Q /S "steamapps\workshop\content\17520"
	mklink /j "steamapps\workshop\content\17520" "steamapps\common\Synergy\synergy\custom">NUL
)
if EXIST "%linkdir%\steamapps\workshop\content\17520\646159916\646159916_pak.vpk" set pmpck1=1
if EXIST "%linkdir%\steamapps\workshop\content\17520\703682251\703682251_pak.vpk" set pmpck2=1
if EXIST "%linkdir%\steamapps\workshop\content\17520\2014781572\2014781572_pak.vpk" set pmpck3=1
if EXIST "%linkdir%\steamapps\workshop\content\17520\2014781572\2014781572_pak.vpk" set pmpck4=1
if EXIST "%linkdir%\steamapps\workshop\content\17520\1133952585\1133952585_pak.vpk" set pmpck5=1
if EXIST steamapps\workshop\content\17520\646159916\646159916_pak.vpk set pmpck1=2
if EXIST steamapps\workshop\content\17520\703682251\703682251_pak.vpk set pmpck2=2
if EXIST steamapps\workshop\content\17520\2014781572\2014781572_pak.vpk set pmpck3=2
if EXIST steamapps\workshop\content\17520\2014781572\2014781572_pak.vpk set pmpck4=2
if EXIST steamapps\workshop\content\17520\1133952585\1133952585_pak.vpk set pmpck5=2
if '%pmpck1%'=='1' echo Player Model Pack 1 detected in Steam workshop dir.
if '%pmpck2%'=='1' echo Player Model Pack 2 detected in Steam workshop dir.
if '%pmpck3%'=='1' echo Player Model Pack 3 and 4 detected in Steam workshop dir.
if '%pmpck5%'=='1' echo Player Model Pack 5 detected in Steam workshop dir.
if '%pmpck1%'=='2' echo Player Model Pack 1 installed.
if '%pmpck2%'=='2' echo Player Model Pack 2 installed.
if '%pmpck3%'=='2' echo Player Model Pack 3 and 4 installed.
if '%pmpck5%'=='2' echo Player Model Pack 5 installed.
if %pmpck1% LEQ 1 echo (1) To install Pack 1 to your client (For 56.16).
if %pmpck2% LEQ 1 echo (2) To install Pack 2 to your client (For 56.16).
if %pmpck3% LEQ 1 echo (3) To install Pack 3 and 4 to your client (For 56.16).
if %pmpck5% LEQ 1 echo (5) To install Pack 5 to your client (For 56.16).
if '%pmpck1%'=='0' echo (DL1) to download Pack 1.
if '%pmpck2%'=='0' echo (DL2) to download Pack 2.
if '%pmpck3%'=='0' echo (DL3) to download Pack 3 and 4.
if '%pmpck5%'=='0' echo (DL5) to download Pack 5.
echo (B) to go back to start.
set /p pmpckopt=
for /f "delims=" %%V in ('powershell -command "$env:pmpckopt.ToLower()"') do set "pmpckopt=%%V"
if '%pmpckopt%'=='b' (
	cls
	goto ^start
)
if '%pmpckopt%'=='1' (
	if '%pmpck1%'=='1' (
		set pmpckdir=^%linkdir%\steamapps\workshop\content\17520\646159916
		set pmpckid=^646159916
		set part=^1
		set installing=^1
	) else echo ^Already installed.
)
if '%pmpckopt%'=='2' (
	if '%pmpck2%'=='1' (
		set pmpckdir=^%linkdir%\steamapps\workshop\content\17520\703682251
		set pmpckid=^703682251
		set part=^2
		set installing=^1
	) else echo ^Already installed.
)
if '%pmpckopt%'=='3' (
	if '%pmpck3%'=='1' (
		set pmpckdir=^%linkdir%\steamapps\workshop\content\17520\2014781572
		set pmpckid=^2014781572
		set part=^34
		set installing=^1
	) else echo ^Already installed.
)
if '%pmpckopt%'=='4' (
	if '%pmpck4%'=='1' (
		set pmpckdir=^%linkdir%\steamapps\workshop\content\17520\2014781572
		set pmpckid=^2014781572
		set part=^34
		set installing=^1
	) else echo ^Already installed.
)
if '%pmpckopt%'=='5' (
	if '%pmpck5%'=='1' (
		set pmpckdir=^%linkdir%\steamapps\workshop\content\17520\1133952585
		set pmpckid=^1133952585
		set part=^5
		set installing=^1
	) else echo ^Already installed.
)
if '%installing%'=='1' (
	if NOT EXIST "%pmpckdir%" echo.
	if NOT EXIST "%pmpckdir%" echo ^You do not have this part downloaded...
	if NOT EXIST "%pmpckdir%" echo.
	if NOT EXIST "%pmpckdir%" set installing=^0
	if NOT EXIST "%pmpckdir%" goto ^instpmpck
)
if '%installing%'=='1' (
	start /wait /min robocopy /S /NP /NJS /NJH /NS "%pmpckdir%" "%cd%\%synpath%\synergy\custom\%pmpckid%"
	echo.
	echo ^Completed installing Part %part%...
	echo.
	set installing=^0
	set pmpckopt=^0
)
if '%pmpckopt%'=='dl1' steamcmd.exe +login anonymous +workshop_download_item 17520 646159916 +quit
if '%pmpckopt%'=='dl2' steamcmd.exe +login anonymous +workshop_download_item 17520 703682251 +quit
if '%pmpckopt%'=='dl3' steamcmd.exe +login anonymous +workshop_download_item 17520 2014781572 +quit
if '%pmpckopt%'=='dl4' steamcmd.exe +login anonymous +workshop_download_item 17520 2014781572 +quit
if '%pmpckopt%'=='dl5' steamcmd.exe +login anonymous +workshop_download_item 17520 1133952585 +quit
ping localhost -n 3 >NUL
goto instpmpckpass

:noanon
if '%anonset%'=='2' (
	echo You cannot use anonymous to install HL2...
	set usrname=""
	goto insthl2
)
echo You cannot use anonymous to install Synergy...
set anonset=1
goto firstinstall

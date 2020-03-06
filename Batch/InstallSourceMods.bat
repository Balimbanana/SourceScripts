@echo off
rem If you are viewing this on GitHub and want to download this script, right click on "Raw" above
rem and click "Save Linked Content As" or "Save Target As".
rem This script was written by Balimbanana.
title Install SourceMods
goto startinit
:updater
cd "%~dp0"
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://github.com/Balimbanana/SourceScripts/raw/master/Batch/InstallSourceMods.bat\",\"$PWD\InstallSourceMods.bat\") }"
echo Updated...
start /b "Install SourceMods" "%~dp0InstallSourceMods.bat"
exit
:startinit
if EXIST "drivers\etc\hosts" cd "%~dp0"
set cldir=%programfiles(x86)%\Steam\steamapps
for /f "skip=2 tokens=1,3* delims== " %%i in ('reg QUERY HKEY_CURRENT_USER\Software\Valve\Steam /f SteamPath /t REG_SZ /v') do (
	set "cldir=%%j%%k"
	goto skiploop
)
:skiploop
for /f "delims=" %%V in ('powershell -command "$env:cldir.Replace(\"/\",\"\\\")"') do set "cldir=%%V"
for /f "delims=" %%V in ('powershell -command "$env:cldir.Replace(\"programfiles \",\"program files \")"') do set "cldir=%%V"
set syncust=%cldir%
if EXIST "C:\SteamLibrary\steamapps\common\Synergy\synergy" set syncust=C:\SteamLibrary\steamapps\common\Synergy\synergy\custom
if EXIST "E:\SteamLibrary\steamapps\common\Synergy\synergy" set syncust=E:\SteamLibrary\steamapps\common\Synergy\synergy\custom
if EXIST "D:\SteamLibrary\steamapps\common\Synergy\synergy" set syncust=D:\SteamLibrary\steamapps\common\Synergy\synergy\custom
if EXIST "F:\SteamLibrary\steamapps\common\Synergy\synergy" set syncust=F:\SteamLibrary\steamapps\common\Synergy\synergy\custom
if EXIST "G:\SteamLibrary\steamapps\common\Synergy\synergy" set syncust=G:\SteamLibrary\steamapps\common\Synergy\synergy\custom
if EXIST "C:\Steam\steamapps\common\Synergy\synergy" set syncust=C:\Steam\steamapps\common\Synergy\synergy\custom
if EXIST "E:\Steam\steamapps\common\Synergy\synergy" set syncust=E:\Steam\steamapps\common\Synergy\synergy\custom
if EXIST "D:\Steam\steamapps\common\Synergy\synergy" set syncust=D:\Steam\steamapps\common\Synergy\synergy\custom
if EXIST "F:\Steam\steamapps\common\Synergy\synergy" set syncust=F:\Steam\steamapps\common\Synergy\synergy\custom
if EXIST "G:\Steam\steamapps\common\Synergy\synergy" set syncust=G:\Steam\steamapps\common\Synergy\synergy\custom
set cldir=%cldir%\steamapps\sourcemods
if NOT EXIST "%cd%\installsourcemods" mkdir "%cd%\installsourcemods"
cd "%cd%\installsourcemods"
if NOT EXIST "%cd%\steamapps" mkdir steamapps
if NOT EXIST "%cd%\steamapps\workshop" mkdir steamapps\workshop
if NOT EXIST "%cd%\steamapps\workshop\content" mkdir steamapps\workshop\content
if NOT EXIST "%cd%\steamapps\workshop\content\17520" (
	if EXIST "%syncust%" mklink /j "%cd%\steamapps\workshop\content\17520" "%syncust%">NUL
)
if EXIST "%cldir%" echo Found sourcemods directory here: %cldir%
if NOT EXIST "%cldir%" if EXIST "%programfiles(x86)%\Steam\steamapps" set cldir=%programfiles(x86)%\Steam\steamapps\sourcemods
if NOT EXIST "%cldir%" (
	echo ^Could not determine sourcemods directory, checked\:
	echo "%programfiles(x86)%\Steam\steamapps and %cldir%"
	pause
	exit
)
if NOT EXIST "%cd%\7-Zip" (
	echo ^Downloading temp pre-requisite 7zip and SteamCMD for auto-extraction when done...
	goto dlsteamcmd
)
goto start
:start
echo Enter the word or letter in the () below and press enter to download/install that mod.
echo This is the list of currently supported mods to play co-op in Synergy
echo.
echo List of full auto install:
echo (Offshore) for Offshore         (CTOA) for Coastline To Atmosphere
echo (CD) for Combine Destiny        (LeonEp3) for Episode 3: The Closure
echo (MI) for Mission Improbable     (OP) for Omega Prison
echo (PRE) for Precursor             (UP) for Uncertainty Principle
echo (S2E) for Slums 2: Extended     (SN) for Spherical Nightmares
echo (STRI) for Strider Mountain     (CIT2) for The Citizen Returns
echo (LUTS) for Lost Under The Snow  (MOP) for Mistake of Pythagoras
echo (EYE) for Eye of The Storm      (MPR) for The Masked Prisoner
echo (BTI) for Below The Ice         (LLP) for Liberation aka LifeLostPrison
echo (DH) for DayHard                (R24) for Rock 24
echo (PTSD) for PTSD and PTCS        (ALC) for Alchemilla
echo (CITY7) for City7               (DW) for Dangerous World
echo (RIOT) for Riot Act             (DD) for DeepDown and Aftermath 
echo (CAL) for Calamity              (AOD) for Avenue Odessa
echo (SESC) for Silent Escape        (EXMO) for Escape by ExMo
echo.
echo Semi-Auto (download through web browser, then script will install from there).
echo (BMS) for Black Mesa Source and Improved Xen
echo.
echo Manual, download through web browser, then open sourcemods with sourcemods option below and extract to there.
echo (DF) for DownFall               (RH) for Ravenholm
echo (YLA) for Year Long Alarm       (KTM) for Kill The Monk
echo (CE) for Causality Effect       (TH) for They Hunger Again part 1
echo (PEN) for HL2 Penetration       (EZ) for Entropy Zero
echo (STTR) for SteamTracksTrouble and Riddles
echo.
echo (SourceMods) to open your sourcemods directory
echo (ModSupports) to open the Mod Support's page.
echo (update) to update this script.
echo For the manual install mods, you will need to subscribe to the Mod Support on the workshop to play it in Synergy.
echo Full Auto installs will install the Mod Support automatically as well.
rem (RANDD) for Research and Development SUPPORT NOT COMPLETED
set /p uprun=
for /f "delims=" %%V in ('powershell -command "$env:uprun.ToLower()"') do set "uprun=%%V"
if "%uprun%"=="sourcemods" (
	explorer "%cldir%"
	goto start
)
if "%uprun%"=="modsupports" (
	start steam://url/CommunityFilePage/695527798
	goto start
)
if "%uprun%"=="bms" goto blackmesa
if "%uprun%"=="up" goto up
if "%uprun%"=="offshore" goto offshore
if "%uprun%"=="ctoa" goto ctoa
if "%uprun%"=="cd" goto combinedest
if "%uprun%"=="leonep3" goto leonep3
if "%uprun%"=="mi" goto mimp
if "%uprun%"=="op" goto omegaprison
if "%uprun%"=="pre" goto precursor
if "%uprun%"=="rh" goto ravenholm
if "%uprun%"=="s2e" goto slums2
if "%uprun%"=="sn" goto spherical
if "%uprun%"=="stri" goto stridermount
if "%uprun%"=="cit2" goto cit2
if "%uprun%"=="mop" goto mop
if "%uprun%"=="th" goto theyhunger
if "%uprun%"=="ce" goto causality
if "%uprun%"=="luts" goto luts
if "%uprun%"=="eye" goto eyeofstorm
if "%uprun%"=="mpr" goto mpr
if "%uprun%"=="dd" goto ddam
if "%uprun%"=="df" goto downfall
if "%uprun%"=="bti" goto belowice
if "%uprun%"=="llp" goto llp
if "%uprun%"=="dh" goto dayhard
rem if "%uprun%"=="randd" goto randd
if "%uprun%"=="ptsd" goto ptsd
if "%uprun%"=="alc" goto alchemilla
if "%uprun%"=="yla" goto yla
if "%uprun%"=="ktm" goto ktm
if "%uprun%"=="sttr" goto sttr
if "%uprun%"=="cal" goto cal
if "%uprun%"=="city7" goto city7
if "%uprun%"=="dw" goto dw
if "%uprun%"=="meta" goto meta
if "%uprun%"=="riot" goto riot
if "%uprun%"=="r24" goto rock24
if "%uprun%"=="pen" goto pene
if "%uprun%"=="ez" goto ezero
if "%uprun%"=="aod" goto avodessa
if "%uprun%"=="sesc" goto silentesc
if "%uprun%"=="exmo" goto escbyexmo
if "%uprun%"=="update" goto updater
echo.
echo Choose an option...
echo.
goto start

:blackmesa
if EXIST "%cldir%\BMS\maps\bm_c3a2h.bsp" (
	echo ^BMS is already installed.
	echo ^Press enter to apply script fix if you need to.
	pause
	goto applyscriptfix
)
if EXIST "%cd%\bms.rar" goto startdl
if EXIST "%cd%\BMS.7z" goto startdl
if EXIST "%cd%\blackmesa.zip.001" goto startdl
if EXIST "%cd%\Black Mesa Synergy.rar" goto startdl
if EXIST "%userprofile%\Downloads\bms.rar" goto startdl
if EXIST "%userprofile%\Downloads\BMS.7z" goto startdl
if EXIST "%userprofile%\Downloads\blackmesa.zip.001" goto startdl
if EXIST "%userprofile%\Downloads\Black Mesa Synergy.rar" goto startdl
echo MegaNZ archive file size is 3.32 GB
echo MediaFire archive file size is 3.34 GB
echo ModDB archive is split, part 1 is 2.64 GB, part 2 is 1.62 GB
echo Auto is fully automatic, BMS at 3.32 GB in 8 parts and Xen at 449 MB
echo AutoV2 is fully automatic, BMS at 3.32 GB 1 piece and Xen at 449 MB
echo Warning: ModDB version has a 50/50 chance of downloading corrupted, forcing you to re-download the whole thing again.
echo It is much more reliable and a smaller download from Mega or MediaFire.
echo The Mega, Auto and AutoV2 all include VentMod 2.0 and Hazard Course included and is repacked in VPK for faster changelevel.
echo Be sure to download the archive to either your Downloads directory, or the same directory this script is being run from.
echo BMSXEN is for the Black Mesa: Improved Xen page.
echo Enter the word in the () below and press enter. The option you choose will open in your default web browser.
echo (Mega)  (MediaFire)  (ModDB)  (BMSXEN)  (Auto)  (AutoV2)
set /p installfrom=
for /f "delims=" %%V in ('powershell -command "$env:installfrom.ToLower()"') do set "installfrom=%%V"
if "%installfrom%"=="mega" (
	start /b https://mega.nz/#!Cp0TWKTL!yS8akebtqaBCLK2DCJM0G2XxC21o80d1JevCq-s9zXM
	goto downloadingpause
)
if "%installfrom%"=="mediafire" (
	start /b http://mediafire.com/file/r7dspd2m22isc8b/Black_Mesa_Synergy.rar/file
	goto downloadingpause
)
if "%installfrom%"=="moddb" (
	start /b https://www.moddb.com/mods/black-mesa/downloads/black-mesa-part-1zip
	start /b https://www.moddb.com/mods/black-mesa/downloads/black-mesa-part-2zip
	goto downloadingpause
)
if "%installfrom%"=="bmsxen" (
	if EXIST "%cldir%\xen\maps\xen_c4a1.bsp" (
		echo ^Already installed...
		pause
		goto start
	)
	start /b https://www.moddb.com/mods/black-mesa-xen-improved-maps-from-half-life/downloads/black-mesa-2012-improved-xen-v0511
	echo ^Once it has finished download, continue this script.
	pause
	if EXIST "%cd%\BMS2012_IMPROVED_XEN_Source2007.1.rar" goto extractbmsxen
	if EXIST "%userprofile%\Downloads\BMS2012_IMPROVED_XEN_Source2007.1.rar" goto extractbmsxen
	echo ^Could not find archive in current directory or downloads directory...
	goto blackmesa
)
if "%installfrom%"=="auto" (
	echo ^Beginning with Xen at 449MB
	echo ^This will take a while...
	echo ^Downloading Xen Part 1 of 2...
	if NOT EXIST xen.7z powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"http://thebdf.org/bm/xen.7z.001\",\"$PWD\xen.7z.001\") }"
	echo ^Downloading Xen Part 2 of 2...
	if NOT EXIST xen.7z powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"http://thebdf.org/bm/xen.7z.002\",\"$PWD\xen.7z.002\") }"
	echo ^Downloading BMS Part 1 of 8...
	if NOT EXIST BMS.7z.001 powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"http://thebdf.org/bm/BMS.7z.001\",\"$PWD\BMS.7z.001\") }"
	echo ^Downloading BMS Part 2 of 8...
	if NOT EXIST BMS.7z.002 powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"http://thebdf.org/bm/BMS.7z.002\",\"$PWD\BMS.7z.002\") }"
	echo ^Downloading BMS Part 3 of 8...
	if NOT EXIST BMS.7z.003 powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"http://thebdf.org/bm/BMS.7z.003\",\"$PWD\BMS.7z.003\") }"
	echo ^Downloading BMS Part 4 of 8...
	if NOT EXIST BMS.7z.004 powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"http://thebdf.org/bm/BMS.7z.004\",\"$PWD\BMS.7z.004\") }"
	echo ^Downloading BMS Part 5 of 8...
	if NOT EXIST BMS.7z.005 powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"http://thebdf.org/bm/BMS.7z.005\",\"$PWD\BMS.7z.005\") }"
	echo ^Downloading BMS Part 6 of 8...
	if NOT EXIST BMS.7z.006 powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"http://thebdf.org/bm/BMS.7z.006\",\"$PWD\BMS.7z.006\") }"
	echo ^Downloading BMS Part 7 of 8...
	if NOT EXIST BMS.7z.007 powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"http://thebdf.org/bm/BMS.7z.007\",\"$PWD\BMS.7z.007\") }"
	echo ^Downloading BMS Part 8 of 8...
	if NOT EXIST BMS.7z.008 powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"http://thebdf.org/bm/BMS.7z.008\",\"$PWD\BMS.7z.008\") }"
	echo ^Finished downloading Black Mesa and Improved Xen, extracting...
	goto alreadydownloaded
)
if "%installfrom%"=="autov2" (
	echo ^Beginning with Xen at 449MB
	echo ^This will take a while...
	echo ^Downloading Xen Part 1 of 2...
	if NOT EXIST xen.7z.001 powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"http://thebdf.org/bm/xen.7z.001\",\"$PWD\xen.7z.001\") }"
	echo ^Downloading Xen Part 2 of 2...
	if NOT EXIST xen.7z.002 powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"http://thebdf.org/bm/xen.7z.002\",\"$PWD\xen.7z.002\") }"
	echo ^Downloading BMS at 3.32GB...
	if NOT EXIST BMS.7z powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"http://bdf.crowbar.lt/Maps+modpack/BMS.7z\",\"$PWD\BMS.7z\") }"
	echo ^Finished downloading Black Mesa and Improved Xen, extracting...
	goto alreadydownloaded
)
echo Enter one of the words in the () to continue...
echo.
goto start
:downloadingpause
echo Once it has finished downloading, continue this script.
pause
goto startdl
:startdl
if NOT EXIST "%cd%\7-Zip" echo Downloading temp pre-requisite 7zip to auto-extract when done...
if NOT EXIST "%cd%\7-Zip" powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/7-Zip.zip\",\"$PWD\7zip.zip\") }"
if EXIST "%cd%\7zip.zip" start /wait /min powershell -command "& {Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory(\"$PWD\7zip.zip\", \"$PWD\") }"
if EXIST "%cd%\7zip.zip" del /Q "%cd%\7zip.zip"
if EXIST "%cd%\bms.rar" goto alreadydownloaded
if EXIST "%cd%\BMS.7z" goto alreadydownloaded
if EXIST "%cd%\blackmesa.zip.001" goto alreadydownloaded
if EXIST "%cd%\Black Mesa Synergy.rar" goto alreadydownloaded
if EXIST "%cd%\Black Mesa Synergy Mod (Still work).rar" goto alreadydownloaded
if EXIST "%cd%\Black Mesa Synergy Mod.rar" goto alreadydownloaded
if EXIST "%userprofile%\Downloads\bms.rar" goto alreadydownloaded
if EXIST "%userprofile%\Downloads\BMS.7z" goto alreadydownloaded
if EXIST "%userprofile%\Downloads\blackmesa.zip.001" goto alreadydownloaded
if EXIST "%userprofile%\Downloads\Black Mesa Synergy.rar" goto alreadydownloaded
if EXIST "%userprofile%\Downloads\Black Mesa Synergy Mod (Still work).rar" goto alreadydownloaded
rem if EXIST "%cd%\bms.rar" del /Q "%cd%\bms.rar"
if NOT EXIST "%cldir%\BMS\maps\bm_c3a2h.bsp" (
	echo ^Something went wrong with the download, possibly an interrupted connection while downloading.
	echo ^Or the file was downloaded with a different name or in a different directory.
	echo ^Press any key to restart script...
	pause
	goto start
)
goto applyscriptfix

:alreadydownloaded
echo Found Black Mesa archive.
if EXIST "%cd%\bms.rar" .\7-Zip\7z.exe x .\bms.rar -o"%cldir%"
if EXIST "%cd%\BMS.7z" .\7-Zip\7z.exe x .\BMS.7z -o"%cldir%"
if EXIST "%cd%\BMS.7z.001" .\7-Zip\7z.exe x .\BMS.7z.001 -o"%cldir%"
if EXIST "%cd%\blackmesa.zip.001" .\7-Zip\7z.exe x .\blackmesa.zip.001 -o"%cldir%"
if EXIST "%cd%\Black Mesa Synergy.rar" .\7-Zip\7z.exe x ".\Black Mesa Synergy.rar" -o"%cldir%"
if EXIST "%cd%\Black Mesa Synergy Mod (Still work).rar" .\7-Zip\7z.exe x ".\Black Mesa Synergy Mod (Still work).rar" -o"%cldir%"
if EXIST "%cd%\Black Mesa Synergy Mod.rar" .\7-Zip\7z.exe x ".\Black Mesa Synergy Mod.rar" -o"%cldir%"
if EXIST "%userprofile%\downloads\bms.rar" .\7-Zip\7z.exe x "%userprofile%\downloads\bms.rar" -o"%cldir%"
if EXIST "%userprofile%\downloads\BMS.7z" .\7-Zip\7z.exe x "%userprofile%\downloads\BMS.7z" -o"%cldir%"
if EXIST "%userprofile%\downloads\blackmesa.zip.001" .\7-Zip\7z.exe x "%userprofile%\downloads\blackmesa.zip.001" -o"%cldir%"
if EXIST "%userprofile%\downloads\Black Mesa Synergy.rar" .\7-Zip\7z.exe x "%userprofile%\downloads\Black Mesa Synergy.rar" -o"%cldir%"
if EXIST "%userprofile%\downloads\Black Mesa Synergy Mod (Still work).rar" .\7-Zip\7z.exe x "%userprofile%\downloads\Black Mesa Synergy Mod (Still work).rar" -o"%cldir%"
if EXIST "%cldir%\blackmesa\maps\bm_c3a2h.bsp" ren "%cldir%\blackmesa" BMS
if EXIST "%cd%\xen.7z" .\7-Zip\7z.exe x .\xen.7z -o"%cldir%"
if EXIST "%cd%\xen.7z.001" .\7-Zip\7z.exe x .\xen.7z.001 -o"%cldir%"
if EXIST "%cd%\BMS2012_IMPROVED_XEN_Source2007.1.rar" .\7-Zip\7z.exe x .\BMS2012_IMPROVED_XEN_Source2007.1.rar -o"%cldir%" xen
if EXIST "%userprofile%\Downloads\BMS2012_IMPROVED_XEN_Source2007.1.rar" .\7-Zip\7z.exe x "%userprofile%\Downloads\BMS2012_IMPROVED_XEN_Source2007.1.rar" -o"%cldir%" xen
if EXIST "%cldir%\BMS\maps\bm_c3a2h.bsp" echo BMS installed successfully.
if EXIST "%cldir%\xen\maps\xen_c5a1.bsp" echo Xen installed successfully.
if NOT EXIST "%cldir%\xen\maps\xen_c5a1.bsp" (
	echo ^Something went wrong with the Xen download, possibly an interrupted connection while downloading.
	echo ^Or your archive became corrupted somehow.
)
if NOT EXIST "%cldir%\BMS\maps\bm_c3a2h.bsp" (
	echo ^Something went wrong with the BMS download, possibly an interrupted connection while downloading.
	echo ^Or your archive became corrupted somehow.
	echo ^Press any key to restart script...
	pause
	goto start
)
goto applyscriptfix

:applyscriptfix
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/bmscripts.zip\",\"$PWD\bmscripts.zip\") }"
if EXIST "%cldir%\BMS\scripts" rmdir /S /Q "%cldir%\BMS\scripts"
if EXIST "%cd%\bmscripts.zip" .\7-Zip\7z.exe -aoa x .\bmscripts.zip -o"%cldir%\BMS"
if EXIST "%cd%\bmscripts.zip" del /Q "%cd%\bmscripts.zip"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\1817140991" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 1817140991 +quit
)
echo.
echo Check for any errors above, if there are any, you may need to re-run this script.
echo Finished installing/patching BMS for use in Synergy.
echo.
pause
goto start

:extractbmsxen
if EXIST "%cd%\BMS2012_IMPROVED_XEN_Source2007.1.rar" .\7-Zip\7z.exe x .\BMS2012_IMPROVED_XEN_Source2007.1.rar -o"%cldir%" xen
if EXIST "%userprofile%\Downloads\BMS2012_IMPROVED_XEN_Source2007.1.rar" .\7-Zip\7z.exe x "%userprofile%\Downloads\BMS2012_IMPROVED_XEN_Source2007.1.rar" -o"%cldir%" xen
pause
goto start

:up
if EXIST "%cldir%\uncertaintyprinciple\maps\up_retreat_a.bsp" (
	echo ^Uncertainty Principle is already installed.
	pause
	goto start
)
echo Downloading Uncertainty Principle...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=12054^&f=/hl2-ep2/hl2-ep2-sp-uncertainty-principle.7z\",\"$PWD\uncertaintyprinciple.7z\") }"
if EXIST "%cd%\uncertaintyprinciple.7z" .\7-Zip\7z.exe x .\uncertaintyprinciple.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\647128322" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 647128322 +quit
)
goto start
:offshore
if EXIST "%cldir%\Offshore\maps\islandescape.bsp" (
	echo ^Offshore is already installed.
	pause
	goto start
)
echo Downloading Offshore...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=3569^&f=/hl2-ep2/hl2-ep2-sp-offshore.7z\",\"$PWD\offshore.7z\") }"
if EXIST "%cd%\offshore.7z" .\7-Zip\7z.exe x .\offshore.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\647127451" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 647127451 +quit
)
goto start
:ctoa
if EXIST "%cldir%\Coastline_to_Atmosphere\maps\leonHL2-2.bsp" (
	echo ^Coastline To Atmosphere is already installed.
	pause
	goto start
)
echo Downloading Coastline To Atmosphere...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=2284^&f=/half-life-2/hl2-sp-coastline-to-atmosphere-fully-updated.7z\",\"$PWD\ctoa.7z\") }"
if EXIST "%cd%\ctoa.7z" .\7-Zip\7z.exe x .\ctoa.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\647128829" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 647128829 +quit
)
goto start
:combinedest
if EXIST "%cldir%\CombineDestiny\maps\cd0.bsp" (
	echo ^Combine Destiny is already installed.
	pause
	goto start
)
echo Downloading Combine Destiny...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=463^&f=/half-life-2/hl2-sp-combine-destiny-steampipe.7z\",\"$PWD\combinedestiny.7z\") }"
if EXIST "%cd%\combinedestiny.7z" .\7-Zip\7z.exe x .\combinedestiny.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\678214923" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 678214923 +quit
)
goto start
:leonep3
if EXIST "%cldir%\Halflife2-Episode3\maps\01_spymap_ep3.bsp" (
	echo ^Leon's Episode 3: The Closure is already installed.
	pause
	goto start
)
echo Downloading Leon's Episode 3: The Closure...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=12429^&f=/hl2-ep2/hl2-ep2-sp-ep3-the-closure-v2.7z\",\"$PWD\ep3theclosure.7z\") }"
if EXIST "%cd%\ep3theclosure.7z" .\7-Zip\7z.exe x .\ep3theclosure.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\664873590" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 664873590 +quit
)
goto start
:mimp
if EXIST "%cldir%\missionimprobable\maps\mimp1.bsp" (
	echo ^Mission Improbable is already installed.
	pause
	goto start
)
echo Downloading Mission Improbable...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=9865^&f=/hl2-ep2/hl2-ep2-sp-mission-improbable-sdk-base-2013-sp.7z\",\"$PWD\mimp.7z\") }"
if EXIST "%cd%\mimp.7z" .\7-Zip\7z.exe x .\mimp.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\683512034" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 683512034 +quit
)
goto start
:omegaprison
if EXIST "%cldir%\omegaprison\maps\po_map1.bsp" (
	echo ^Omega Prison is already installed.
	pause
	goto start
)
echo Downloading Omega Prison...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=12305^&f=/hl2-ep2/hl2-ep2-sp-omega-prison.7z\",\"$PWD\op.7z\") }"
if EXIST "%cd%\op.7z" .\7-Zip\7z.exe x .\op.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\682177824" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 682177824 +quit
)
goto start
:precursor
if EXIST "%cldir%\Precursor\maps\r_map1.bsp" (
	echo ^Precursor is already installed.
	pause
	goto start
)
echo Downloading Precursor...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=8043^&f=/hl2-ep2/hl2-ep2-sp-precursor-1.1c.7z\",\"$PWD\pre.7z\") }"
if EXIST "%cd%\pre.7z" .\7-Zip\7z.exe x .\pre.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\492916281" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 492916281 +quit
)
goto start
:ravenholm
echo Opening Ravenholm ModDB page...
start /b https://www.moddb.com/mods/ravenholm/downloads
goto start
:slums2
if EXIST "%cldir%\Slums 2 Extended\maps\slums_1.bsp" (
	echo ^Slums 2: Extended is already installed.
	pause
	goto start
)
echo Downloading Slums 2: Extended
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=7709^&f=/hl2-ep2/hl2-ep2-sp-slums-2-extended.7z\",\"$PWD\s2e.7z\") }"
if EXIST "%cd%\s2e.7z" .\7-Zip\7z.exe x .\s2e.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\691111508" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 691111508 +quit
)
goto start
:spherical
if EXIST "%cldir%\Spherical Nightmares\maps\sn_intro.bsp" (
	echo ^Spherical Nightmares is already installed.
	pause
	goto start
)
echo Downloading Spherical Nightmares...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=10229^&f=/hl2-ep2/hl2-ep2-sp-spherical-nightmares.7z\",\"$PWD\spherical.7z\") }"
if EXIST "%cd%\spherical.7z" .\7-Zip\7z.exe x .\spherical.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\694312354" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 694312354 +quit
)
goto start
:stridermount
if EXIST "%cldir%\Strider_Mountain_Rev3\maps\1_sm_off_course.bsp" (
	echo ^Strider Mountain is already installed.
	pause
	goto start
)
echo Downloading Strider Mountain...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=6616^&f=/half-life-2/hl2-sp-strider-mountain-v3-patched.7z\",\"$PWD\stridermountain.7z\") }"
if EXIST "%cd%\stridermountain.7z" .\7-Zip\7z.exe x .\stridermountain.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\689508204" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 689508204 +quit
)
goto start
:cit2
if EXIST "%cldir%\The Citizen Returns\maps\sp_intro.bsp" (
	echo ^The Citizen Returns is already installed.
	pause
	goto start
)
echo Downloading The Citizen Returns...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=10757^&f=/hl2-ep2/hl2-ep2-sp-the-citizen-returns.7z\",\"$PWD\cit2.7z\") }"
if EXIST "%cd%\cit2.7z" .\7-Zip\7z.exe x .\cit2.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\1917233439" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 1917233439 +quit
)
goto start
:mop
if EXIST "%cldir%\MOP\maps\ks_mop_vill1.bsp" (
	echo ^Mistake of Pythagoras is already installed.
	pause
	goto start
)
echo Downloading Mistake of Pythagoras...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=2741^&f=/sdk-2013/sdk2013-sp-mop.7z\",\"$PWD\mop.7z\") }"
if EXIST "%cd%\mop.7z" .\7-Zip\7z.exe x .\mop.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\733880910" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 733880910 +quit
)
goto start
:theyhunger
if EXIST "%cldir%\hunger\maps\th_intro.bsp" (
	echo ^They Hunger Again is already installed.
	pause
	goto start
)
echo Downloading They Hunger Again Part 1
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=12464^&f=/hl2-ep2/hl2-ep2-sp-they-hunger-again-1.2.7z\",\"$PWD\th.7z\") }"
if EXIST "%cd%\th.7z" .\7-Zip\7z.exe x .\th.7z -o"%cldir%"
if NOT EXIST "%cldir%\hunger\maps\th_intro.bsp" start /min /wait robocopy /NP /NJS /NJH /NS "%cldir%\hunger\maps" "%cldir%\hunger\maps" "intro.bsp" "th_intro.bsp"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\698969705" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 698969705 +quit
)
goto start
:causality
echo Opening Causality Effect ModDB page...
start /b https://www.moddb.com/mods/causality-effect/downloads
goto start
:luts
if EXIST "%cldir%\LostUnderTheSnow\maps\intro01.bsp" (
	echo ^Lost Under The Snow is already installed.
	pause
	goto start
)
echo Downloading Lost Under The Snow...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=9915^&f=/hl2-ep2/hl2-ep2-sp-lost-under-the-snow.7z\",\"$PWD\luts.7z\") }"
if EXIST "%cd%\luts.7z" .\7-Zip\7z.exe x .\luts.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\762217131" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 762217131 +quit
)
goto start
:eyeofstorm
if EXIST "%cldir%\eots\maps\eots_111.bsp" (
	echo ^Eye of The Storm is already installed.
	pause
	goto start
)
echo Downloading Eye of The Storm...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=4319^&f=/hl2-ep2/hl2-ep2-sp-eye-of-the-storm-ep1.7z\",\"$PWD\eye.7z\") }"
if EXIST "%cd%\eye.7z" .\7-Zip\7z.exe x .\eye.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\783933738" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 783933738 +quit
)
goto start
:mpr
if EXIST "%cldir%\themaskedprisoner\maps\mpr_010_arrival.bsp" (
	echo ^The Masked Prisoner is already installed.
	pause
	goto start
)
echo Downloading The Masked Prisoner...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=10909^&f=/hl2-ep2/hl2-ep2-sp-the-masked-prisoner.7z\",\"$PWD\mpr.7z\") }"
if EXIST "%cd%\mpr.7z" .\7-Zip\7z.exe x .\mpr.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\860392418" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 860392418 +quit
)
goto start
:ddam
if EXIST "%cldir%\Aftermath\maps\am2.bsp" (
	echo ^DeepDown and Aftermath are already installed.
	pause
	goto start
)
echo Downloading DeepDown and Aftermath...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=10437^&f=/hl2-ep2/hl2-ep2-deep-down-v1.3.7z\",\"$PWD\dd.7z\") }"
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=11753^&f=/hl2-ep2/hl2-ep2-sp-aftermath-updated.7z\",\"$PWD\am.7z\") }"
if EXIST "%cd%\dd.7z" .\7-Zip\7z.exe x .\dd.7z -o"%cldir%"
if EXIST "%cd%\am.7z" .\7-Zip\7z.exe x .\am.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\886714754" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 886714754 +quit
)
goto start
:downfall
echo Opening DownFall Steam page...
start /b http://store.steampowered.com/app/587650
goto start
:belowice
if EXIST "%cldir%\belowice\maps\belowice_intro.bsp" (
	echo ^Below The Ice is already installed.
	pause
	goto start
)
echo Downloading Below The Ice...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=11398^&f=/hl2-ep2/hl2-ep2-sp-below-the-ice.7z\",\"$PWD\bti.7z\") }"
if EXIST "%cd%\bti.7z" .\7-Zip\7z.exe x .\bti.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\918216553" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 918216553 +quit
)
goto start
:llp
if EXIST "%cldir%\Liberation\maps\lifelostprison_01.bsp" (
	echo ^Liberation is already installed.
	pause
	goto start
)
echo Downloading Life Lost Prison aka Liberation...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=10959^&f=/hl2-ep2/hl2-ep2-sp-liberation.7z\",\"$PWD\liberation.7z\") }"
if EXIST "%cd%\liberation.7z" .\7-Zip\7z.exe x .\liberation.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\931794062" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 931794062 +quit
)
goto start
:dayhard
if EXIST "%cldir%\DayHard\maps\dayhardpart1.bsp" (
	echo ^DayHard is already installed.
	pause
	goto start
)
echo Downloading DayHard...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=3008^&f=/half-life-2/hl2-sp-dayhard-complete.7z\",\"$PWD\dayhard.7z\") }"
if EXIST "%cd%\dayhard.7z" .\7-Zip\7z.exe x .\dayhard.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\1230906124" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 1230906124 +quit
)
goto start
rem :randd
rem if EXIST "%cldir%\Research and Development\maps\level_1a.bsp" (
rem 	echo ^Research and Development is already installed.
rem 	pause
rem 	goto start
rem )
rem echo Warning: Research and Development mod support for Synergy is not complete.
rem powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=6294^&f=/hl2-ep2/hl2-ep2-sp-research-and-development-sdk-base-2013-sp.7z\",\"$PWD\randd.7z\") }"
rem if EXIST "%cd%\randd.7z" .\7-Zip\7z.exe x .\randd.7z -o"%cldir%"
rem goto start
:ptsd
if EXIST "%cldir%\ptsd_festive\maps\ptsd_festive_1.bsp" (
	echo ^PTSD and PTCS are already installed.
	pause
	goto start
)
echo Downloading PTSD and PTCS...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=13438^&f=/hl2-ep2/hl2-ep2-sp-the-ptsd-mod.7z\",\"$PWD\ptsd.7z\") }"
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=14320^&f=/hl2-ep2/hl2-ep2-sp-ptcs.7z\",\"$PWD\ptcs.7z\") }"
if EXIST "%cd%\ptsd.7z" .\7-Zip\7z.exe x .\ptsd.7z -o"%cldir%"
if EXIST "%cd%\ptcs.7z" .\7-Zip\7z.exe x .\ptcs.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\1427833667" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 1427833667 +quit
)
goto start
:alchemilla
if EXIST "%cldir%\Alchemilla\maps\sh_alchemilla.bsp" (
	echo ^Silent Hill: Alchemilla is already installed.
	pause
	goto start
)
echo Downloading Silent Hill: Alchemilla...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=11169^&f=/hl2-ep2/hl2-ep2-sp-alchemilla.7z\",\"$PWD\alc.7z\") }"
if EXIST "%cd%\alc.7z" .\7-Zip\7z.exe x .\alc.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\1650998121" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 1650998121 +quit
)
goto start
:yla
echo Opening Year Long Alarm Steam page...
start /b https://store.steampowered.com/app/747250
goto start
:ezero
echo Opening Entropy Zero Steam page...
start /b https://store.steampowered.com/app/714070
goto start
:ktm
echo Opening Kill The Monk ModDB page...
start /b https://www.moddb.com/mods/kill-the-monk/downloads
goto start
:sttr
if EXIST "%cldir%\STTR_CH01_V2_01\maps\STTR_Ch1A_Set69.bsp" (
	echo ^Steam Tracks Troubles and Riddles is already installed.
	pause
	goto start
)
echo Opening Steam Tracks Troubles and Riddles ModDB page...
start /b https://www.moddb.com/mods/steam-tracks-trouble-riddles/downloads/stt-r-chapter-one-v2
rem old version
rem echo Downloading Steam Tracks Troubles and Riddles...
rem powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=10914^&f=/hl2-ep2/hl2-ep2-sp-sttr.7z\",\"$PWD\sttr.7z\") }"
rem if EXIST "%cd%\sttr.7z" .\7-Zip\7z.exe x .\sttr.7z -o"%cldir%"
if NOT EXIST "%cd%\steamapps\workshop\content\17520\1286998604" (
	echo ^Downloading Synergy Support files through SteamCMD
	steamcmd.exe +login anonymous +workshop_download_item 17520 1286998604 +quit
)
goto start
:cal
if EXIST "%cldir%\Half-Life 2 Calamity\maps\sp_c14_1.bsp" (
	echo ^Calamity is already installed.
	pause
	goto start
)
echo Downloading Calamity...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=5312^&f=/sdk-2013/sdk2013-sp-calamity.7z\",\"$PWD\cal.7z\") }"
if EXIST "%cd%\cal.7z" .\7-Zip\7z.exe x .\cal.7z -o"%cldir%"
goto start
:city7
if EXIST "%cldir%\City_7\maps\d1_trainstation_05_d_start_f.bsp" (
	echo ^City 7: Toronto Conflict is already installed.
	pause
	goto start
)
echo Downloading City 7: Toronto Conflict...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=3444^&f=/half-life-2/hl2-sp-toronto-conflict.7z\",\"$PWD\city7.7z\") }"
if EXIST "%cd%\city7.7z" .\7-Zip\7z.exe x .\city7.7z -o"%cldir%"
goto start
:dw
if EXIST "%cldir%\DangerousWorld\maps\dw_ep1_00.bsp" (
	echo ^Dangerous World is already installed.
	pause
	goto start
)
echo Downloading Dangerous World...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=7451^&f=/sdk-2013/sdk2013-sp-dangerous-world.7z\",\"$PWD\dw.7z\") }"
if EXIST "%cd%\dw.7z" .\7-Zip\7z.exe x .\dw.7z -o"%cldir%"
goto start
:meta
echo Opening Minerva: Metastasis Steam page...
start /b https://store.steampowered.com/app/747250
goto start
:riot
if EXIST "%cldir%\half-life 2 riot act\maps\ra_c1l1.bsp" (
	echo ^Riot Act is already installed.
	pause
	goto start
)
echo Downloading Riot Act...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=3307^&f=/half-life-2/hl2-sp-riot-act.7z\",\"$PWD\riotact.7z\") }"
if EXIST "%cd%\riotact.7z" .\7-Zip\7z.exe x .\riotact.7z -o"%cldir%"
goto start
:rock24
if EXIST "%cldir%\Rock 24\maps\d1_overboard_01.bsp" (
	echo ^Rock24 is already installed.
	pause
	goto start
)
echo Downloading Rock24...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=2878^&f=/sdk-2013/sdk2013-sp-rock-24.7z\",\"$PWD\rock24.7z\") }"
if EXIST "%cd%\rock24.7z" .\7-Zip\7z.exe x .\rock24.7z -o"%cldir%"
goto start
:pene
echo Opening Half-Life 2 Penetration ModDB page...
start /b https://www.moddb.com/mods/penetration/downloads
goto start
:avodessa
if EXIST "%cldir%\AvenueOdessa\maps\avenueodessa.bsp" (
	echo ^Avenue Odessa is already installed.
	pause
	goto start
)
echo Downloading Avenue Odessa...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=11593^&f=/hl2-ep2/hl2-ep2-sp-avenue-odessa-v101.7z\",\"$PWD\hl2-ep2-sp-avenue-odessa-v101.7z\") }"
echo Extracting Avenue Odessa...
if EXIST "%cd%\hl2-ep2-sp-avenue-odessa-v101.7z" .\7-Zip\7z.exe x .\hl2-ep2-sp-avenue-odessa-v101.7z -o"%cldir%"
if EXIST "%cldir%\AvenueOdessa\maps\avenueodessa.bsp" echo Completed.
goto start
:silentesc
if EXIST "%cldir%\Silent Escape\maps\silent_escape_map_01.bsp" (
	echo ^Silent Escape is already installed.
	pause
	goto start
)
echo Downloading Silent Escape...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=10069^&f=/hl2-ep2/hl2-ep2-sp-silent-escape-v1.1.7z\",\"$PWD\hl2-ep2-sp-silent-escape-v1.1.7z\") }"
echo Extracting Silent Escape...
if EXIST "%cd%\hl2-ep2-sp-silent-escape-v1.1.7z" .\7-Zip\7z.exe x .\hl2-ep2-sp-silent-escape-v1.1.7z -o"%cldir%"
if EXIST "%cldir%\Silent Escape\maps\silent_escape_map_01.bsp" echo Completed.
goto start
:escbyexmo
if EXIST "%cldir%\escape_by_ex-mo\maps\escape_map_01.bsp" (
	echo ^Silent Escape is already installed.
	pause
	goto start
)
echo Downloading Escape by ExMo...
powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://www.runthinkshootlive.com/download.php?id=5921^&f=/half-life-2/hl2-sp-escape-ex-mo-updated.7z\",\"$PWD\hl2-sp-escape-ex-mo-updated.7z\") }"
echo Extracting Escape by ExMo...
if EXIST "%cd%\hl2-sp-escape-ex-mo-updated.7z" .\7-Zip\7z.exe x .\hl2-sp-escape-ex-mo-updated.7z -o"%cldir%"
if EXIST "%cldir%\Escape\maps\escape_map_01.bsp" (
	rename "%cldir%\Escape" "escape_by_ex-mo"
)
if EXIST "%cldir%\escape_by_ex-mo\maps\escape_map_01.bsp" echo Completed.
goto start

:dlsteamcmd
if NOT EXIST "%cd%\7-Zip" powershell -command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://github.com/Balimbanana/SourceScripts/raw/master/synotherfilefixes/7-Zip.zip\",\"$PWD\7zip.zip\") }"
if EXIST "%cd%\7zip.zip" start /wait /min powershell -command "& {Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory(\"$PWD\7zip.zip\", \"$PWD\") }"
if EXIST "%cd%\7zip.zip" del /Q "%cd%\7zip.zip"
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
if EXIST "%CD%\7-Zip\7z.exe" (
	if '%foundcmd%'=='1' (
		start /min /wait "7z" "%CD%\7-Zip\7z.exe" x steamcmd.zip
	)
	if '%foundcmd%'=='2' (
		start /min /wait "7z" "%CD%\7-Zip\7z.exe" x "%userprofile%\downloads\steamcmd.zip"
	)
)
goto start

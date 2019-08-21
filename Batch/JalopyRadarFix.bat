@echo off
rem This script was written by Balimbanana.
title Synergy 56.16 Jalopy Radar Fix
set cldir=%programfiles(x86)%\Steam\steamapps
for /f "skip=2 tokens=1,3* delims== " %%i in ('reg QUERY HKEY_CURRENT_USER\Software\Valve\Steam /f SteamPath /t REG_SZ /v') do set "cldir=%%j%%k"
for /f "delims=" %%V in ('powershell -command "$env:cldir.Replace(\"/\",\"\\\")"') do set "cldir=%%V"
for /f "delims=" %%V in ('powershell -command "$env:cldir.Replace(\"programfiles\",\"\Program Files\")"') do set "cldir=%%V"
if EXIST "C:\SteamLibrary\steamapps\common\Synergy\synergy" set cldir=C:\SteamLibrary\steamapps
if EXIST "E:\SteamLibrary\steamapps\common\Synergy\synergy" set cldir=E:\SteamLibrary\steamapps
if EXIST "D:\SteamLibrary\steamapps\common\Synergy\synergy" set cldir=D:\SteamLibrary\steamapps
if EXIST "F:\SteamLibrary\steamapps\common\Synergy\synergy" set cldir=F:\SteamLibrary\steamapps
if EXIST "G:\SteamLibrary\steamapps\common\Synergy\synergy" set cldir=G:\SteamLibrary\steamapps
if EXIST "H:\SteamLibrary\steamapps\common\Synergy\synergy" set cldir=H:\SteamLibrary\steamapps
if EXIST "C:\Steam\steamapps\common\Synergy\synergy" set cldir=C:\Steam\steamapps
if EXIST "E:\Steam\steamapps\common\Synergy\synergy" set cldir=E:\Steam\steamapps
if EXIST "D:\Steam\steamapps\common\Synergy\synergy" set cldir=D:\Steam\steamapps
if EXIST "F:\Steam\steamapps\common\Synergy\synergy" set cldir=F:\Steam\steamapps
if EXIST "G:\Steam\steamapps\common\Synergy\synergy" set cldir=G:\Steam\steamapps
if EXIST "H:\Steam\steamapps\common\Synergy\synergy" set cldir=H:\Steam\steamapps
:start
if NOT EXIST "%cldir%\common\Synergy\synergy" goto notfound
if NOT EXIST "%cldir%\common\Synergy\synergy\scripts" mkdir ^"%cldir%\common\Synergy\synergy\scripts"
start /wait /min powershell -command "& {$WebClient = New-Object System.Net.WebClient; $WebClient.DownloadFile(\"https://gist.githubusercontent.com/Balimbanana/5edefbc6d9a0a7fe7c28e444547ddf65/raw/4dc290629081715ad585e31747cfbd7d8f7a83c7/vgui_screens.txt\",\"$env:cldir\common\Synergy\synergy\scripts\vgui_screens.txt\") }"
if EXIST "%cldir%\common\Synergy\synergy\scripts\vgui_screens.txt" echo ^Fixed!
pause
exit

:notfound
echo Could not find game directory...
pause

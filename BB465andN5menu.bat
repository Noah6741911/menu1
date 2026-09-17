@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
chcp 65001 >nul 2>&1
title BB465 and N5 menu
color 1

rem Run the former dev.py setup first. Once the expected layout exists,
rem this deliberately skips all changes on later launches.
set "GAME_DIR=C:\Program Files (x86)\Steam\steamapps\common\Animal Company"
set "EAC_EXE=%GAME_DIR%\EACLauncher.exe"
set "GAME_EXE=%GAME_DIR%\AnimalCompany.exe"
set "EAC_DATA=%GAME_DIR%\EACLauncher_Data"
set "GAME_DATA=%GAME_DIR%\AnimalCompany_Data"

echo.
echo ===========================================
echo   Checking Animal Company setup...
echo ===========================================

if not exist "!GAME_DIR!\" (
    echo [ERROR] Game folder was not found:
    echo !GAME_DIR!\
    echo Install the game at that location, or update GAME_DIR in this file.
    goto :end
)

if exist "!EAC_DATA!\" if not exist "!GAME_DATA!\" (
    echo [OK] Setup is already complete. Skipping setup.
    goto :downloads
)

echo [*] Applying one-time setup...
rem Confirm both replacement sources before deleting or renaming anything.
if not exist "!GAME_EXE!" (
    echo [ERROR] Old.exe was not found. No files were changed.
    goto :end
)
if not exist "!GAME_DATA!\" (
    echo [ERROR] Old_Data was not found. No files were changed.
    goto :end
)

if exist "!EAC_EXE!" (
    del /q "!EAC_EXE!"
    if exist "!EAC_EXE!" (
        echo [ERROR] Could not remove EACLauncher.exe. Close the game and try again.
        goto :end
    )
)

ren "!GAME_EXE!" "EACLauncher.exe"

if exist "!EAC_DATA!\" (
    rmdir /s /q "!EAC_DATA!"
    if exist "!EAC_DATA!\" (
        echo [ERROR] Could not remove New_Data. Close the game and try again.
        goto :end
    )
)

ren "!GAME_DATA!" "New_Data"
echo [OK] Setup complete.

:downloads
echo.
echo Downloading ac_bridge.js...
powershell -NoProfile -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-WebRequest -UseBasicParsing -MaximumRedirection 10 -Uri 'https://raw.githubusercontent.com/Banban465-tech/ac-symbols/refs/heads/main/ac_bridge.js' -OutFile 'ac_bridge.js'"
if errorlevel 1 curl.exe -L -o "ac_bridge.js" "https://raw.githubusercontent.com/Banban465-tech/ac-symbols/refs/heads/main/ac_bridge.js"
if errorlevel 1 echo [WARNING] ac_bridge.js could not be downloaded. Continuing with any local copy.

echo Downloading symbols.ts...
powershell -NoProfile -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-WebRequest -UseBasicParsing -MaximumRedirection 10 -Uri 'https://bit.ly/4xy9RAt' -OutFile 'symbols.ts'"
if errorlevel 1 curl.exe -L -o "symbols.ts" "https://bit.ly/4xy9RAt"
if errorlevel 1 echo [WARNING] symbols.ts could not be downloaded. Continuing with any local copy.

cls
for /F "delims=" %%E in ('echo prompt $E ^| cmd') do set "ESC=%%E"
set "ESC=!ESC: =!"
echo !ESC![38;2;100;210;255m===========================================
echo !ESC![38;2;0;220;255m ____  ____  _  _    __  ____  _
echo !ESC![38;2;0;185;235m^| __ ^)^| __ ^)^| ^|^| ^|  / /_^| ___^|^| ^|_ ___
echo !ESC![38;2;0;150;215m^|  _ \^|  _ \^| ^|^| ^|_^| '_ \___ \^| __/ __^|
echo !ESC![38;2;0;115;195m^| ^|_^)^| ^|_^)^|__   _^| (_) ^|__) ^| ^|_\__ \
echo !ESC![38;2;0;80;175m^|____/^|____/   ^|_^|  \___/____^(_)__^|___/
echo !ESC![38;2;0;60;140m===========================================
echo !ESC![0m
echo !ESC![38;5;4m

set "RP_CHOICE=n"
if exist "rp_setting.txt" set /p RP_CHOICE=<"rp_setting.txt"
if not exist "rp_setting.txt" (
    set /p RP_CHOICE="Enable Discord Rich Presence? (y/n): "
    if /I not "!RP_CHOICE!"=="y" set "RP_CHOICE=n"
    >"rp_setting.txt" echo !RP_CHOICE!
)
if /I "%RP_CHOICE%"=="y" if exist "rich_presence.py" start "Discord Rich Presence" python "rich_presence.py"

set "FB_CHOICE=n"
if exist "fb_setting.txt" set /p FB_CHOICE=<"fb_setting.txt"
if not exist "fb_setting.txt" (
    set /p FB_CHOICE="Disable frame booster and optimizations? (y/n): "
    if /I not "!FB_CHOICE!"=="y" set "FB_CHOICE=n"
    >"fb_setting.txt" echo !FB_CHOICE!
)
if exist "fb_setting.txt" if exist "%USERPROFILE%\Documents\N5Presets\" copy /y "fb_setting.txt" "%USERPROFILE%\Documents\N5Presets\fb_setting.txt" >nul

echo.
echo yuhhhhhhhh
echo vers 1.5
echo click any button to run script ^(do it at wooster games screen^)
echo i luv yall :3
pause >nul

rem Only these two project files are loaded by Frida.
frida -l ac_bridge.js -l n5.ts "EACLauncher.exe"

:end
echo.
pause
endlocal

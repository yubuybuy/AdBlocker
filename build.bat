@echo off
echo ========================================
echo   AdBlocker Build Tool
echo ========================================
echo.

REM Check WSL
wsl --list >nul 2>&1
if errorlevel 1 (
    echo [ERROR] WSL not found
    echo.
    echo Installing WSL...
    powershell -Command "Start-Process wsl -ArgumentList '--install' -Verb RunAs"
    echo.
    echo Please restart your computer after installation
    pause
    exit /b
)

echo [OK] WSL detected
echo.

REM Check Ubuntu
wsl -l -v 2>nul | findstr /i "Ubuntu" >nul 2>&1
if errorlevel 1 (
    echo [INFO] Ubuntu not found, installing...
    echo.
    echo This will take 2-5 minutes...
    wsl --install -d Ubuntu-24.04

    echo.
    echo ========================================
    echo   Ubuntu installed!
    echo ========================================
    echo.
    echo IMPORTANT: Ubuntu will start now
    echo Please set username and password
    echo Then close Ubuntu and run this script again
    echo.
    pause

    REM Start Ubuntu for first-time setup
    wsl -d Ubuntu-24.04
    exit /b
)

echo [OK] Ubuntu detected
echo.

REM Check Theos
wsl bash -c "test -d /opt/theos" >nul 2>&1
if errorlevel 1 (
    echo [INFO] Installing Theos...
    echo.
    wsl bash -c "sudo apt update && sudo apt install -y git curl build-essential fakeroot perl libarchive-tools"
    wsl bash -c "sudo git clone --recursive https://github.com/theos/theos.git /opt/theos"
    wsl bash -c "echo 'export THEOS=/opt/theos' >> ~/.bashrc"

    echo [INFO] Downloading iOS SDK...
    wsl bash -c "cd /opt/theos/sdks && sudo curl -LO https://github.com/xybp888/iOS-SDKs/raw/master/iPhoneOS16.5.sdk.tar.xz && sudo tar -xf iPhoneOS16.5.sdk.tar.xz"

    echo [OK] Theos installed
    echo.
)

echo [OK] Theos ready
echo.

REM Convert path
set "CURRENT_DIR=%CD%"
set "WSL_PATH=%CURRENT_DIR:\=/%"
set "WSL_PATH=/mnt/c%WSL_PATH:C:=%"

echo Building project...
echo Path: %WSL_PATH%
echo.

REM Build
wsl bash -c "cd '%WSL_PATH%' && export THEOS=/opt/theos && make clean && make package"

if errorlevel 1 (
    echo.
    echo [ERROR] Build failed
    echo.
    echo Check:
    echo 1. Tweak.x syntax
    echo 2. SDK installation
    echo 3. Error messages above
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Build SUCCESS!
echo ========================================
echo.

REM Find deb file
for /f "delims=" %%i in ('dir /b /o-d packages\*.deb 2^>nul') do (
    set "DEB_FILE=%%i"
    goto :found
)

echo [ERROR] DEB file not found
pause
exit /b

:found
echo Package: packages\%DEB_FILE%
echo.
echo Next steps:
echo 1. Transfer packages\%DEB_FILE% to your jailbroken iPhone
echo 2. Install with Filza or: dpkg -i xxx.deb
echo 3. Respring: killall -9 SpringBoard
echo.

REM Open packages folder
explorer packages

pause

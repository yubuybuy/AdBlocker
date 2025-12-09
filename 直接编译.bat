@echo off
echo ========================================
echo   AdBlocker - Direct Build
echo ========================================
echo.

echo Checking Theos installation...
wsl bash -c "test -d /opt/theos" >nul 2>&1
if errorlevel 1 (
    echo Installing Theos...
    echo This may take 5-10 minutes on first run
    echo.

    echo [1/4] Updating package list...
    wsl bash -c "sudo apt update"

    echo [2/4] Installing dependencies...
    wsl bash -c "sudo apt install -y git curl build-essential fakeroot perl libarchive-tools"

    echo [3/4] Cloning Theos...
    wsl bash -c "sudo git clone --recursive https://github.com/theos/theos.git /opt/theos"

    echo [4/4] Downloading iOS SDK...
    wsl bash -c "cd /opt/theos/sdks && sudo curl -LO https://github.com/xybp888/iOS-SDKs/raw/master/iPhoneOS16.5.sdk.tar.xz && sudo tar -xf iPhoneOS16.5.sdk.tar.xz"

    echo.
    echo Theos installed successfully!
    echo.
) else (
    echo Theos already installed
    echo.
)

REM Convert Windows path to WSL path
set "CURRENT_DIR=%CD%"
set "WSL_PATH=%CURRENT_DIR:\=/%"
set "WSL_PATH=/mnt/c%WSL_PATH:C:=%"

echo Building project...
echo Path: %WSL_PATH%
echo.

wsl bash -c "cd '%WSL_PATH%' && export THEOS=/opt/theos && make clean && make package"

if errorlevel 1 (
    echo.
    echo ========================================
    echo   BUILD FAILED
    echo ========================================
    echo.
    echo Please check error messages above
    pause
    exit /b 1
)

echo.
echo ========================================
echo   BUILD SUCCESS!
echo ========================================
echo.

for /f "delims=" %%i in ('dir /b /o-d packages\*.deb 2^>nul') do (
    set "DEB_FILE=%%i"
    goto :found
)

echo ERROR: DEB file not found
pause
exit /b

:found
echo Generated: packages\%DEB_FILE%
echo.
echo Next: Transfer to iPhone and install with Filza
echo   or: dpkg -i xxx.deb
echo.

explorer packages
pause

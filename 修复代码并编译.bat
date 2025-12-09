@echo off
echo ========================================
echo   Fix Tweak.x Code Error
echo ========================================
echo.

echo Adding WebKit import...
wsl bash -c "cd '/mnt/c/Users/gao-huan/Desktop/AdBlockerTweak' && sed -i '7i #import <WebKit/WebKit.h>' Tweak.x"

echo.
echo Building project...
wsl bash -c "cd '/mnt/c/Users/gao-huan/Desktop/AdBlockerTweak' && export THEOS=/opt/theos && make clean && make package"

if errorlevel 1 (
    echo.
    echo ========================================
    echo   BUILD FAILED
    echo ========================================
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
echo.
echo ========================================
echo   SUCCESS! Package created!
echo ========================================
echo.
echo Package: packages\%DEB_FILE%
echo.
echo Installation:
echo 1. Transfer to iPhone
echo 2. Install with Filza: dpkg -i xxx.deb
echo 3. Respring: killall -9 SpringBoard
echo.

explorer packages
pause

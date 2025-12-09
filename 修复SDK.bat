@echo off
echo ========================================
echo   Fix Theos SDK
echo ========================================
echo.

echo Checking SDK directory...
wsl bash -c "sudo ls -la /opt/theos/sdks/"

echo.
echo Installing iOS SDK...
echo This may take 2-5 minutes to download...
echo.

REM Method 1: Try official SDK
wsl bash -c "cd /opt/theos/sdks && sudo rm -rf *.sdk* && sudo curl -LO https://github.com/theos/sdks/archive/master.zip && sudo apt install -y unzip && sudo unzip -q master.zip && sudo cp -r sdks-master/* . && sudo rm -rf sdks-master master.zip"

echo.
echo Verifying SDK installation...
wsl bash -c "ls -la /opt/theos/sdks/"

echo.
echo ========================================
echo   SDK installation complete!
echo ========================================
echo.
echo Now run: 直接编译.bat
pause

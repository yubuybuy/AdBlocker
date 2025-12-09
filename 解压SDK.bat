@echo off
echo ========================================
echo   Extract SDK
echo ========================================
echo.

echo Extracting iPhoneOS SDK...
wsl bash -c "cd /opt/theos/sdks && sudo tar -xf iPhoneOS16.5.sdk.tar.xz && sudo rm iPhoneOS16.5.sdk.tar.xz"

echo.
echo Checking installed SDKs...
wsl bash -c "ls -la /opt/theos/sdks/"

echo.
echo ========================================
echo   Done! Now run: 直接编译.bat
echo ========================================
pause

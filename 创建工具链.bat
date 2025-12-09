@echo off
echo ========================================
echo   Create Toolchain Symlinks
echo ========================================
echo.

echo Creating toolchain directory structure...
wsl bash -c "sudo mkdir -p /opt/theos/toolchain/linux/iphone/bin"

echo Creating symlinks to system clang...
wsl bash -c "sudo ln -sf /usr/bin/clang /opt/theos/toolchain/linux/iphone/bin/clang"
wsl bash -c "sudo ln -sf /usr/bin/clang++ /opt/theos/toolchain/linux/iphone/bin/clang++"
wsl bash -c "sudo ln -sf /usr/bin/ld.lld /opt/theos/toolchain/linux/iphone/bin/ld"
wsl bash -c "sudo ln -sf /usr/bin/ar /opt/theos/toolchain/linux/iphone/bin/ar"
wsl bash -c "sudo ln -sf /usr/bin/strip /opt/theos/toolchain/linux/iphone/bin/strip"

echo.
echo Verifying toolchain...
wsl bash -c "ls -la /opt/theos/toolchain/linux/iphone/bin/"

echo.
echo ========================================
echo   Toolchain ready!
echo ========================================
echo.
echo Now run: 直接编译.bat
pause

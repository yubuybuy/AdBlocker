@echo off
echo ========================================
echo   Install Compiler Toolchain
echo ========================================
echo.

echo Installing clang and build tools...
echo This will take 2-5 minutes...
echo.

wsl bash -c "sudo apt update && sudo apt install -y clang llvm lld"

echo.
echo Verifying installation...
wsl bash -c "which clang && clang --version"

echo.
echo ========================================
echo   Toolchain installed!
echo ========================================
echo.
echo Now run: 直接编译.bat
pause

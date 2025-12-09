@echo off
echo ========================================
echo   Fix Makefile and Build
echo ========================================
echo.

echo Updating Makefile to use system clang...
copy /Y Makefile.new Makefile

echo.
echo Building project...
echo.

wsl bash -c "cd '/mnt/c/Users/gao-huan/Desktop/AdBlockerTweak' && export THEOS=/opt/theos && export PREFIX=/usr && make clean && make package"

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
echo Generated: packages\%DEB_FILE%
echo.

explorer packages
pause

@echo off
echo ========================================
echo   Download Compiled DEB from GitHub
echo ========================================
echo.

cd "C:\Users\gao-huan\Desktop\AdBlockerTweak"

echo Checking latest build status...
gh run list --limit 1

echo.
echo Downloading latest artifact...
gh run download

echo.
echo ========================================
echo   Download complete!
echo ========================================
echo.

for /f "delims=" %%i in ('dir /b /s *.deb 2^>nul') do (
    echo Found: %%i
    explorer "%%~dpi"
    goto :end
)

echo No DEB file found. Please check if build completed successfully.
echo Visit: https://github.com/yubuybuy/AdBlocker/actions

:end
pause

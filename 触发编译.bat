@echo off
echo ========================================
echo   Manual Trigger GitHub Workflow
echo ========================================
echo.

cd "C:\Users\gao-huan\Desktop\AdBlockerTweak"

echo Attempting to trigger workflow manually...
gh workflow run build.yml 2>&1

if errorlevel 1 (
    echo.
    echo Could not trigger automatically.
    echo Please enable Actions in GitHub settings first.
    echo.
    echo Visit: https://github.com/yubuybuy/AdBlocker/settings/actions
    echo Then select: "Allow all actions and reusable workflows"
    echo.
) else (
    echo.
    echo Workflow triggered!
    echo Check status at: https://github.com/yubuybuy/AdBlocker/actions
    start https://github.com/yubuybuy/AdBlocker/actions
)

pause

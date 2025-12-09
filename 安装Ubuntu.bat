@echo off
chcp 65001 >nul
echo ========================================
echo   安装 WSL Ubuntu
echo ========================================
echo.
echo 正在安装 Ubuntu...
echo 这可能需要几分钟，请耐心等待...
echo.

wsl --install -d Ubuntu-24.04

if errorlevel 1 (
    echo.
    echo [X] 安装失败！
    echo.
    echo 请尝试手动安装：
    echo 1. 以管理员身份运行 PowerShell
    echo 2. 输入: wsl --install -d Ubuntu-24.04
    pause
    exit /b 1
)

echo.
echo ========================================
echo   [√] 安装成功！
echo ========================================
echo.
echo 下一步：
echo 1. 首次启动会要求设置用户名和密码
echo 2. 设置完成后，重新运行 "一键编译.bat"
echo.
pause

wsl -d Ubuntu-24.04

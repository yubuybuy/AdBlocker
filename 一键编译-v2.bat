@echo off
chcp 65001 >nul
echo ========================================
echo   AdBlocker - Windows 快速编译工具
echo ========================================
echo.

REM 检查 WSL 是否安装
wsl --list >nul 2>&1
if errorlevel 1 (
    echo [X] 未检测到 WSL
    echo.
    echo 正在安装 WSL...
    echo 请在弹出的管理员窗口中��认
    powershell -Command "Start-Process wsl -ArgumentList '--install' -Verb RunAs"
    echo.
    echo 安装完成后需要重启电脑！
    echo 重启后再次运行此脚本。
    pause
    exit /b
)

echo [√] 检测到 WSL
echo.

REM 检查是否安装了 Ubuntu
wsl -l -v 2>nul | findstr /i "Ubuntu" >nul 2>&1
if errorlevel 1 (
    echo [X] 未检测到 Ubuntu 发行版
    echo.
    echo 请先安装 Ubuntu：
    echo 1. 双击运行 "安装Ubuntu.bat"
    echo    或
    echo 2. 在 PowerShell 管理员中运行: wsl --install -d Ubuntu-24.04
    echo.
    pause
    exit /b
)

echo [√] 检测到 Ubuntu
echo.

REM 检查 Theos 是否安装
wsl bash -c "test -d /opt/theos" >nul 2>&1
if errorlevel 1 (
    echo [!] 未检测到 Theos，正在安装...
    echo.
    wsl bash -c "sudo apt update && sudo apt install -y git curl build-essential fakeroot perl libarchive-tools"
    wsl bash -c "sudo git clone --recursive https://github.com/theos/theos.git /opt/theos"
    wsl bash -c "echo 'export THEOS=/opt/theos' >> ~/.bashrc"

    echo [!] 正在下载 iOS SDK...
    wsl bash -c "cd /opt/theos/sdks && sudo curl -LO https://github.com/xybp888/iOS-SDKs/raw/master/iPhoneOS16.5.sdk.tar.xz && sudo tar -xf iPhoneOS16.5.sdk.tar.xz"

    echo [√] Theos 安装完成！
    echo.
)

echo [√] Theos 已就绪
echo.

REM 转换 Windows 路径到 WSL 路径
set "CURRENT_DIR=%CD%"
set "WSL_PATH=%CURRENT_DIR:\=/%"
set "WSL_PATH=/mnt/c%WSL_PATH:C:=%"

echo 开始编译...
echo 项目路径: %WSL_PATH%
echo.

REM 编译
wsl bash -c "cd '%WSL_PATH%' && export THEOS=/opt/theos && make clean && make package"

if errorlevel 1 (
    echo.
    echo [X] 编译失败！
    echo.
    echo 请检查：
    echo 1. Tweak.x 语法是否正确
    echo 2. SDK 是否正确安装
    echo 3. 查看上方错误信息
    pause
    exit /b 1
)

echo.
echo ========================================
echo   [√] 编译成功！
echo ========================================
echo.

REM 查找生成的 deb 文件
for /f "delims=" %%i in ('dir /b /o-d packages\*.deb 2^>nul') do (
    set "DEB_FILE=%%i"
    goto :found
)

echo [!] 未找到 deb 文件
pause
exit /b

:found
echo 生成的包: packages\%DEB_FILE%
echo.
echo 下一步：
echo 1. 将 packages\%DEB_FILE% 传输到越狱设备
echo 2. 使用 Filza 安装，或通过 SSH: dpkg -i xxx.deb
echo 3. 重启 SpringBoard
echo.

REM 打开 packages 目录
explorer packages

pause

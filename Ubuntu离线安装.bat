@echo off
echo ========================================
echo   Ubuntu 离线安装指南
echo ========================================
echo.
echo 如果在线安装失败，请尝试：
echo.
echo 方法 1: Microsoft Store (推荐)
echo   1. 打开 Microsoft Store
echo   2. 搜索 "Ubuntu"
echo   3. 点击 "安装"
echo.
echo 方法 2: 手动下载安装包
echo   1. 访问: https://aka.ms/wslubuntu2204
echo   2. 下载 .appx 文件
echo   3. 双击安装
echo.
echo 方法 3: 检查网络
echo   - 关闭 VPN/代理
echo   - 检查防火墙设置
echo   - 尝试切换网络
echo.
echo 方法 4: 使用 GitHub Actions 云端编译
echo   - 无需安装任何东西
echo   - 完全在云端完成
echo   - 查看: 其他编译方案.md
echo.
pause

echo.
echo 是否打开 Microsoft Store Ubuntu 下载页? (Y/N)
set /p choice=

if /i "%choice%"=="Y" (
    start ms-windows-store://pdp/?ProductId=9NZ3KLHXDJP5
)

pause

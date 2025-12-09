@echo off
echo ========================================
echo   Install Apple Toolchain (cctools)
echo ========================================
echo.

echo This will install Apple's linker for cross-compilation...
echo It may take 10-15 minutes...
echo.

wsl bash -c "cd /tmp && sudo apt install -y git cmake ninja-build libssl-dev libxml2-dev uuid-dev libbsd-dev zlib1g-dev && git clone https://github.com/tpoechtrager/apple-libtapi.git && cd apple-libtapi && ./build.sh && sudo ./install.sh && cd .. && git clone https://github.com/tpoechtrager/cctools-port.git && cd cctools-port/cctools && ./configure --prefix=/opt/theos/toolchain/linux/iphone --target=arm-apple-darwin14 && make && sudo make install"

echo.
echo ========================================
echo   Toolchain installed!
echo ========================================
pause

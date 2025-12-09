#!/bin/bash

echo "========================================"
echo "  Theos SDK Installation"
echo "========================================"
echo

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

echo "Creating SDK directory..."
$SUDO mkdir -p /opt/theos/sdks
cd /opt/theos/sdks

echo "Cleaning old SDKs..."
$SUDO rm -rf *.sdk *.tar.* *.zip

echo
echo "Downloading iOS SDK..."
echo "Method 1: Trying theos/sdks repository..."

if $SUDO curl -LO https://github.com/theos/sdks/archive/master.zip; then
    echo "Download successful, extracting..."
    $SUDO apt install -y unzip 2>/dev/null || sudo apt install -y unzip
    $SUDO unzip -q master.zip
    $SUDO mv sdks-master/* .
    $SUDO rm -rf sdks-master master.zip
    echo "✓ SDK installed from theos/sdks"
else
    echo "Method 1 failed, trying alternative source..."

    # Method 2: Try specific SDK version
    if $SUDO curl -LO https://github.com/xybp888/iOS-SDKs/raw/master/iPhoneOS16.5.sdk.tar.xz; then
        echo "Download successful, extracting..."
        $SUDO tar -xf iPhoneOS16.5.sdk.tar.xz
        $SUDO rm iPhoneOS16.5.sdk.tar.xz
        echo "✓ SDK installed from alternative source"
    else
        echo "✗ Failed to download SDK"
        echo
        echo "Please check your internet connection"
        exit 1
    fi
fi

echo
echo "Installed SDKs:"
ls -la /opt/theos/sdks/

echo
echo "========================================"
echo "  SDK Installation Complete!"
echo "========================================"
echo
echo "Found SDKs:"
ls -d /opt/theos/sdks/*.sdk 2>/dev/null || echo "No .sdk directories found, but files are present"

echo
echo "You can now run the build script"

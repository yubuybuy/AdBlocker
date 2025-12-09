#!/bin/bash

# AdBlocker 快速编译脚本

echo "========================================="
echo "   AdBlocker - 开始编译"
echo "========================================="

# 检查 THEOS 环境
if [ -z "$THEOS" ]; then
    if [ -d "/opt/theos" ]; then
        export THEOS=/opt/theos
        echo "✓ 使用 THEOS: /opt/theos"
    else
        echo "✗ 错误: 未找到 Theos"
        echo "  请先安装 Theos: https://theos.dev/docs/installation"
        exit 1
    fi
fi

# 清理旧文件
echo ""
echo "→ 清理旧文件..."
make clean

# 编译
echo ""
echo "→ 开始编译..."
if make package; then
    echo ""
    echo "========================================="
    echo "   ✓ 编译成功!"
    echo "========================================="
    echo ""

    # 找到生成的 deb 包
    DEB_FILE=$(ls -t packages/*.deb 2>/dev/null | head -n 1)

    if [ -n "$DEB_FILE" ]; then
        echo "📦 生成的包: $DEB_FILE"
        echo "📊 包大小: $(du -h "$DEB_FILE" | cut -f1)"
        echo ""

        # 显示安装命令
        echo "安装方法:"
        echo "  1. 本地安装: make install"
        echo "  2. 手动安装: dpkg -i $DEB_FILE"
        echo ""

        # 询问是否安装
        read -p "是否立即安装到设备? (需要设备 IP) [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            read -p "请输入设备 IP: " DEVICE_IP
            if [ -n "$DEVICE_IP" ]; then
                export THEOS_DEVICE_IP=$DEVICE_IP
                make install
            fi
        fi
    fi
else
    echo ""
    echo "========================================="
    echo "   ✗ 编译失败"
    echo "========================================="
    exit 1
fi

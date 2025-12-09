# Windows WSL 编译 iOS Tweak 教程

## 第一步：安装 WSL

```powershell
# 在 PowerShell（管理员）中运行：
wsl --install

# 重启电脑后，WSL Ubuntu 会自动打开
# 设置用户名和密码
```

## 第二步：在 WSL 中安装 Theos

```bash
# 1. 更新系统
sudo apt update
sudo apt upgrade -y

# 2. 安装依赖
sudo apt install -y git curl build-essential fakeroot perl libarchive-tools

# 3. 安装 Theos
sudo git clone --recursive https://github.com/theos/theos.git /opt/theos

# 4. 设置环境变量
echo "export THEOS=/opt/theos" >> ~/.bashrc
echo "export PATH=\$THEOS/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc

# 5. 安装 iOS SDK（选择一个）
# 方法A：自动下载（推荐）
curl -LO https://github.com/theos/sdks/archive/master.zip
sudo unzip master.zip -d /opt/theos/sdks
sudo mv /opt/theos/sdks/sdks-master/* /opt/theos/sdks/
sudo rm -rf /opt/theos/sdks/sdks-master

# 方法B：手动指定版本
cd /opt/theos/sdks
sudo git clone https://github.com/theos/sdks.git
```

## 第三步：访问 Windows 文件

```bash
# WSL 可以直接访问 Windows 文件系统
# Windows 的 C:\ 对应 WSL 的 /mnt/c/

# 进入项目目录
cd /mnt/c/Users/gao-huan/Desktop/AdBlockerTweak

# 查看文件
ls -la
```

## 第四步：编译

```bash
# 1. 清理
make clean

# 2. 编译打包
make package

# 3. 查看生成的 deb 包
ls -lh packages/*.deb
```

## 第五步：获取 deb 文件

编译成功后，deb 包位于：
- **WSL 路径**: `~/packages/`
- **Windows 路径**: `C:\Users\gao-huan\Desktop\AdBlockerTweak\packages\`

直接在 Windows 资源管理器中就能看到！

## 常见问题

### Q: WSL 访问文件很慢？
```bash
# 建议把项目复制到 WSL 内部
cp -r /mnt/c/Users/gao-huan/Desktop/AdBlockerTweak ~/
cd ~/AdBlockerTweak
make package

# 编译后复制回 Windows
cp packages/*.deb /mnt/c/Users/gao-huan/Desktop/
```

### Q: 权限错误？
```bash
# 给脚本执行权限
chmod +x build.sh

# 修复文件权限
chmod 644 Makefile control *.plist
chmod 644 Tweak.x
```

### Q: 缺少 SDK？
```bash
# 检查 SDK
ls /opt/theos/sdks/

# 如果为空，重新下载
cd /opt/theos/sdks
sudo curl -LO https://github.com/xybp888/iOS-SDKs/raw/master/iPhoneOS16.5.sdk.tar.xz
sudo tar -xf iPhoneOS16.5.sdk.tar.xz
```

## 完整命令（复制粘贴）

```bash
# 一键安装 Theos（在 WSL Ubuntu 中）
sudo apt update && \
sudo apt install -y git curl build-essential fakeroot perl libarchive-tools && \
sudo git clone --recursive https://github.com/theos/theos.git /opt/theos && \
echo "export THEOS=/opt/theos" >> ~/.bashrc && \
source ~/.bashrc && \
cd /opt/theos/sdks && \
sudo curl -LO https://github.com/xybp888/iOS-SDKs/raw/master/iPhoneOS16.5.sdk.tar.xz && \
sudo tar -xf iPhoneOS16.5.sdk.tar.xz && \
echo "✓ Theos 安装完成！"

# 进入项目编译
cd /mnt/c/Users/gao-huan/Desktop/AdBlockerTweak
make package
```

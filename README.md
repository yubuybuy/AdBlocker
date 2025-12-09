# AdBlocker - iOS 广告拦截插件

## ⚠️ 重要说明

- **仅用于学习和研究目的**
- 需要**越狱设备** (checkra1n, unc0ver, Taurine 等)
- 需要安装 **Theos 开发环境**
- 请尊重开发者，支持正版应用

## 📋 功能特性

✅ 拦截主流广告 SDK：
- Google AdMob (Banner, 插屏, 激励视频)
- 穿山甲/Pangle (字节跳动)
- 优量汇 (腾讯广告)
- 通用广告视图检测

✅ 网络层拦截：
- NSURLSession 请求拦截
- WKWebView 广告过滤
- 常见广告域名黑名单

✅ 视图层处理：
- 自动隐藏广告视图
- CSS 注入屏蔽网页广告

## 🛠️ 编译环境要求

### macOS / Linux:
```bash
# 安装 Theos
sudo git clone --recursive https://github.com/theos/theos.git /opt/theos
export THEOS=/opt/theos

# 安装依赖
brew install ldid  # macOS
sudo apt install fakeroot  # Linux
```

### Windows (WSL):
```bash
# 使用 WSL Ubuntu
sudo apt update
sudo apt install git perl fakeroot

# 安装 Theos
sudo git clone --recursive https://github.com/theos/theos.git /opt/theos
echo "export THEOS=/opt/theos" >> ~/.bashrc
source ~/.bashrc
```

## 📦 编译步骤

```bash
# 1. 进入项目目录
cd AdBlockerTweak

# 2. 编译
make clean
make package

# 3. 生成的 deb 包位于：
# packages/com.example.adblocker_1.0.0_iphoneos-arm.deb
```

## 📲 安装方法

### 方法一：直接安装到设备
```bash
# 通过 SSH 安装 (需要设备在同一网络)
export THEOS_DEVICE_IP=192.168.1.100  # 你的设备 IP
export THEOS_DEVICE_PORT=22
make install
```

### 方法二：手动安装
```bash
# 1. 将 deb 包传输到设备
scp packages/*.deb root@192.168.1.100:/tmp/

# 2. SSH 登录设备
ssh root@192.168.1.100

# 3. 安装
dpkg -i /tmp/com.example.adblocker_*.deb

# 4. 注销重启 SpringBoard
killall -9 SpringBoard
```

### 方法三：使用 Filza
1. 将 `.deb` 文件通过 AirDrop/iTunes 传到设备
2. 用 Filza 打开
3. 点击右上角"安装"
4. 重启 SpringBoard

## 🎯 自定义配置

### 针对特定应用
编辑 `AdBlocker.plist`：

```xml
<key>Bundles</key>
<array>
    <!-- 只在这些应用中启用 -->
    <string>com.tencent.xin</string>        <!-- 微信 -->
    <string>com.tencent.mqq</string>        <!-- QQ -->
    <string>com.ss.iphone.ugc.Aweme</string> <!-- 抖音 -->
</array>
```

### 添加自定义广告域名
编辑 `Tweak.x` 中的 `adDomains` 数组：

```objc
NSArray *adDomains = @[
    @"your-ad-domain.com",
    @"another-ad.net"
];
```

### 添加自定义广告 SDK
```objc
%hook YourCustomAdClass

- (void)loadAd {
    NSLog(@"[AdBlocker] 拦截自定义广告");
    // 不调用 %orig
}

%end
```

## 🔍 调试日志

使用 Console.app 或 SSH 查看日志：

```bash
# 实时查看日志
ssh root@device-ip
tail -f /var/log/syslog | grep AdBlocker

# 或使用
log stream --predicate 'process == "YourApp"' | grep AdBlocker
```

## 📂 项目结构

```
AdBlockerTweak/
├── Makefile              # 编译配置
├── Tweak.x               # 主要 Hook 代码
├── control               # 包信息
├── AdBlocker.plist       # 过滤规则
└── packages/             # 生成的 deb 包
```

## 🔧 常见问题

### Q: 编译失败 "theos not found"
```bash
# 设置 THEOS 环境变量
export THEOS=/opt/theos
```

### Q: 安装后无效果
```bash
# 1. 检查是否正确重启
killall -9 SpringBoard

# 2. 检查插件是否加载
ls /Library/MobileSubstrate/DynamicLibraries/

# 3. 查看日志
log stream --predicate 'eventMessage contains "AdBlocker"'
```

### Q: 某些应用崩溃
编辑 `AdBlocker.plist` 将该应用加入排除列表：

```xml
<key>Executables</key>
<array>
    <string>problematic-app-name</string>
</array>
```

### Q: 如何卸载
```bash
# SSH 登录设备
dpkg -r com.example.adblocker
killall -9 SpringBoard
```

## 🎓 学习资源

- [Theos 官方文档](https://theos.dev)
- [Logos 语法参考](https://theos.dev/docs/logos-syntax)
- [iOS App Reverse Engineering](https://github.com/iosre/iOSAppReverseEngineering)
- [r/jailbreakdevelopers](https://reddit.com/r/jailbreakdevelopers)

## ⚖️ 法律声明

- 本项目仅供**学习和研究**使用
- 请遵守当地法律法规
- 不得用于商业用途
- 请支持正版应用开发者

## 🔄 更新日志

**v1.0.0** (2025-12-01)
- ✨ 初始版本
- ✅ 支持 AdMob, 穿山甲, 优量汇
- ✅ WKWebView 广告过滤
- ✅ 网络请求拦截

## 📝 License

MIT License - 仅限教育用途

---

**开发者**: Your Name
**联系**: your@email.com
**版本**: 1.0.0

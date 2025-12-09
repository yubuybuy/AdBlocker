# ✅ GitHub 仓库创建成功！

## 🎉 仓库地址
https://github.com/yubuybuy/AdBlocker

## 📋 下一步操作

### 1. 查看编译状态
访问：https://github.com/yubuybuy/AdBlocker/actions

- 点击最新的 workflow run
- 等待 2-3 分钟编译完成
- 状态变成 ✅ 绿色勾表示成功

### 2. 下载 .deb 文件

编译成功后：
1. 点击完成的构建任务
2. 滚动到页面底部 "Artifacts" 部分
3. 下载 **AdBlocker-DEB.zip**
4. 解压得到 `.deb` 文件

### 3. 安装到越狱 iPhone

**方法 A：Filza**
1. 通过 AirDrop 传输 `.deb` 到 iPhone
2. Filza 打开
3. 点击右上角"安装"
4. 重启 SpringBoard

**方法 B：SSH**
```bash
# 传输文件
scp com.example.adblocker_*.deb root@iPhone-IP:/tmp/

# SSH 登录
ssh root@iPhone-IP

# 安装
dpkg -i /tmp/com.example.adblocker_*.deb

# 重启 SpringBoard
killall -9 SpringBoard
```

## 🔄 修改代码后重新编译

1. 在本地修改 `Tweak.x`
2. 运行：
```bash
cd C:/Users/gao-huan/Desktop/AdBlockerTweak
git add .
git commit -m "Update tweak code"
git push
```
3. GitHub Actions 会自动重新编译

## 🎯 快捷命令

在项目目录下打开 PowerShell：

```powershell
# 查看编译状态
gh run list

# 查看最新构建日志
gh run view --log

# 下载最新的 artifact
gh run download

# 打开 Actions 页面
gh repo view --web
```

---

**现在浏览器应该已打开仓库页面，点击顶部的 "Actions" 查看编译进度！**

# 超简单 3 步教程

## 第 1 步：双击运行
```
build.bat
```

## 第 2 步：等待自动安装

脚本会自动：
1. 检测 WSL ✓
2. 发现缺少 Ubuntu
3. **自动安装 Ubuntu**（2-5 分钟）
4. 弹出 Ubuntu 窗口

## 第 3 步：设置用户名密码

Ubuntu 窗口会显示：
```
Enter new UNIX username:
```

- 输入：`user`（或任意名字）
- 按回车
- 输入密码（不显示是正常的）
- 再次输入密码确认

完成后**关闭 Ubuntu 窗口**，再次运行 `build.bat`

---

## 一次性命令（复制粘贴到 PowerShell）

如果你更喜欢命令行：

```powershell
# 安装 Ubuntu
wsl --install -d Ubuntu-24.04

# 等待安装完成，设置用户名密码后
cd C:\Users\gao-huan\Desktop\AdBlockerTweak
.\build.bat
```

---

## 常见问题

**Q: 需要管理员权限吗？**
首次安装 Ubuntu 需要，脚本会自动请求

**Q: 用户名密码是什么？**
随便设，例如用户名 `user`，密码 `123456`

**Q: 密码输入时没反应？**
Linux 特性，输入时不显示任何字符，直接输入完按回车即可

---

**立即开始：双击 `build.bat`**

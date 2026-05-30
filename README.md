# 安装环境联网
```bash
eject /dev/sr0
nmcli device wifi connect "SSID名称" password "密码"
```

# 检查gpu顺序

```bash
vulkaninfo --summary | grep -E "GPU[0-9]|deviceName"
```

# 手动残余

1. Discover中安装QQ、微信
2. KWalletManager密码库管理器 → 更改密码

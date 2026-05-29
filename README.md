# 安装环境联网
```bash
eject /dev/sr0
nmcli device wifi connect "SSID名称" password "密码"
```

# flake版本更新

```bash
cd /etc/nixos
sudo nix flake update
sudo nixos-rebuild switch --flake .#laurel
```

# MMDB

```bash
wget -P /var/lib/mihomo https://hub.keccak.top/MetaCubeX/meta-rules-dat/releases/download/latest/country.mmdb
```

# 新增配置

```bash
xxx="xxx"
sudo touch /etc/nixos/${xxx}.nix
sudo chown root:wheel -R /etc/nixos/${xxx}.nix
sudo chmod g+rwX /etc/nixos/${xxx}.nix
```

# flathub更新

可能需要代理

```bash
flatpak update
```

# 检查gpu顺序

```bash
vulkaninfo --summary | grep -E "GPU[0-9]|deviceName"
```

# 新建开发环境

```bash
nix develop ~/py --profile ~/py/profile
nix flake update ~/py  # 更新
```

# 手动残余

1. 设置->键盘->虚拟键盘->Fcitx 5.
2. Discover中安装微信
3. KWalletManager密码库管理器 → 更改密码

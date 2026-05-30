# 安装环境联网
```bash
eject /dev/sr0
nmcli device wifi connect "SSID名称" password "密码"
```

# btrfs子卷挂载

```bash
TARGET=/dev/nvme1n1p2
sudo mount -o subvol=@,compress=zstd:3,noatime $TARGET /mnt
sudo mount -o subvol=@home,compress=zstd:3,noatime $TARGET /mnt/home
sudo mount -o subvol=@nix,compress=zstd:3,noatime $TARGET /mnt/nix
sudo mount -o subvol=@log,compress=zstd:3,noatime $TARGET /mnt/var/log
```

# 通过镜像源安装

```bash
sudo nixos-install --root /mnt --flake /mnt/home/sakura/nixos#laurel --option substituters https://mirrors.ustc.edu.cn/nix-channels/store
```

# 检查
1. hardware-configuration.nix是否更新
2. password-hash文件是否放置妥当；必须放在系统所在卷下，否则系统启动时可能读取不到: 

```bash
# 生成
mkpasswd > sakura-password-hash
# 验证是否生效
sudo awk -F: '/^(root|sakura):/ { print $1 ":" $2 }' /mnt/etc/shadow
```

# 检查gpu顺序

```bash
vulkaninfo --summary | grep -E "GPU[0-9]|deviceName"
```

# 手动残余

1. Discover中安装QQ、微信
2. KWalletManager密码库管理器 → 更改密码

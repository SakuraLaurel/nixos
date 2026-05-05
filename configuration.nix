{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.usb-modeswitch.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  nixpkgs.config.allowUnfree = true; # WPS 需要；wpsoffice-cn 是 unfree 包

  networking.hostName = "laurel";

  # 如果你是新装系统，按 nixos-generate-config 生成的值保留；
  # 以后升级 NixOS 不要随便改 system.stateVersion。
  system.stateVersion = "25.11";

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.supportedLocales = [
    "zh_CN.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  users.users.sakura = {
    isNormalUser = true;
    description = "Sakura";
    extraGroups = [ "wheel" "video" "audio" "input" ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Btrfs：hardware-configuration.nix 负责 UUID 和 subvol；
  # 这里补充挂载选项。nixos-generate-config 不会自动识别这些选项。
  fileSystems."/" = {
    options = [ "compress=zstd:3" "noatime" ];
  };

  fileSystems."/home" = {
    options = [ "compress=zstd:3" "noatime" ];
  };

  fileSystems."/nix" = {
    options = [ "compress=zstd:3" "noatime" ];
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  # AMD RX 6400 / RDNA2：amdgpu 开源驱动，桌面通常开 graphics 即可。
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  boot.initrd.kernelModules = [ "amdgpu" ];

  # systemd-networkd：适合固定网络；如果你经常切 Wi-Fi，NetworkManager 更舒服。
  networking.useDHCP = false;
  networking.networkmanager.enable = false;
  services.resolved.enable = true;

  systemd.network = {
    enable = true;

    networks."10-ethernet" = {
      matchConfig.Type = "ether";
      networkConfig.DHCP = "yes";
      linkConfig.RequiredForOnline = "no";
    };

    # 如果要用 Wi-Fi + iwd，把下面两段打开。
    networks."20-wlan" = {
      matchConfig.Type = "wlan";
      networkConfig.DHCP = "yes";
    };
  };

  networking.wireless.iwd.enable = true;

  # KDE Plasma 6 + SDDM
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };

  # 声音
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # OpenSSH / sshd
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true; # 配好 SSH key 后建议改 false
    };
  };

  # 中文输入法：不要把 fcitx5 本体放进 environment.systemPackages。
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-gtk
        qt6Packages.fcitx5-qt
      ];
    };
  };

  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      source-han-sans
      source-han-serif
      wqy_microhei
    ];
  };

  # mihomo：配置文件建议放在 /etc/mihomo/config.yaml，
  # 不要把机场订阅、密钥直接写进 flake，因为 flake 内容会进 Nix store。
  services.mihomo = {
    enable = true;
    configFile = "/etc/mihomo/config.yaml";
    tunMode = true;
    processesInfo = true;
    webui = pkgs.metacubexd;
  };

  networking.firewall.enable = true;

  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    # 基础工具
    git
    curl
    wget
    vim
    btrfs-progs

    # KDE 常用应用
    kdePackages.dolphin
    kdePackages.konsole
    kdePackages.ark
    kdePackages.spectacle
    kdePackages.fcitx5-configtool
    kdePackages.discover

    # 桌面软件
    chromium
    vlc
    wpsoffice-cn

    # mihomo CLI
    mihomo

    # Python 基础；项目依赖建议走 nix develop / uv
    python3
    uv

    vscode.fhs
  ];

  programs.git.enable = true;

  services.printing.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}

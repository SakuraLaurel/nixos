{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./usb-modeswitch.nix
    ./locale.nix
    ./users.nix
    ./networking.nix
    ./softwares.nix
  ];

  nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  networking.hostName = "laurel";
  system.stateVersion = "25.11";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  hardware.graphics.enable = true;
  hardware.amdgpu.initrd.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true; # 配好 SSH key 后建议改 false
    };
  };

  environment.shellAliases = {
    nrs = "sudo nixos-rebuild switch --flake /etc/nixos#laurel";
    ncg = "sudo nix-collect-garbage -d && sudo nixos-rebuild boot --flake /etc/nixos";
    proxy-on = "export https_proxy=\"http://127.0.0.1:7890\" && export http_proxy=\"http://127.0.0.1:7890\"";
    proxy-off = "unset https_proxy http_proxy";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}

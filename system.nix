{ pkgs, ... }:

{
  nix.settings = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store?priority=10"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=20"
      "https://mirror.sjtu.edu.cn/nix-channels/store?priority=30"
      "https://cache.nixos.org/?priority=40"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWryvZl6K7CNmQmAX4KAaFh7a3Q9E="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    experimental-features = [
      "nix-command"
      "flakes"
    ];

    auto-optimise-store = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  system.stateVersion = "26.11";

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  fileSystems."/" = {
    options = [
      "compress=zstd:3"
      "noatime"
    ];
  };

  fileSystems."/home" = {
    options = [
      "compress=zstd:3"
      "noatime"
    ];
  };

  fileSystems."/nix" = {
    options = [
      "compress=zstd:3"
      "noatime"
    ];
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}

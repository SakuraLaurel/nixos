{ pkgs, ... }:

{
  nix.settings = {
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}

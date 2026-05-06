{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  services.flatpak.enable = true;
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    btrfs-progs
    kdePackages.dolphin
    kdePackages.konsole
    kdePackages.ark
    kdePackages.spectacle
    kdePackages.discover
    chromium
    vscode.fhs
    wpsoffice-cn
    vlc
    mihomo
  ];
}

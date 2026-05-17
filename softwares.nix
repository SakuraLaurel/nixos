{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  services.flatpak.enable = true;
  system.activationScripts.flatpakFlathubMirror.text = ''
    ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
    ${pkgs.flatpak}/bin/flatpak remote-modify flathub --url=https://mirrors.ustc.edu.cn/flathub || true
  '';
  environment.systemPackages = with pkgs; [
    git
    cmake
    curl
    wget
    vim
    htop
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
    qq

    intel-gpu-tools
    amdgpu_top
    vulkan-loader
    vulkan-tools
    llama-cpp-vulkan
  ];
}

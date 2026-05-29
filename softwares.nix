{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  services.flatpak.enable = true;
  system.activationScripts.flatpakFlathubMirror.text = ''
    ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
    ${pkgs.flatpak}/bin/flatpak remote-modify flathub --url=https://mirrors.ustc.edu.cn/flathub || true
  '';
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;
  };
  environment.systemPackages = with pkgs; [
    git
    cmake
    curl
    wget
    htop
    btrfs-progs
    kdePackages.dolphin
    kdePackages.konsole
    kdePackages.ark
    kdePackages.spectacle
    kdePackages.discover
    google-chrome
    vlc
    mihomo
    qq
    # vscode.fhs
    # wpsoffice-cn

    dmidecode
    intel-gpu-tools
    # vulkan跑AI
    # amdgpu_top
    # vulkan-loader
    # vulkan-tools
    # llama-cpp-vulkan
  ];
}

{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    cmake
    curl
    wget
    htop
    dmidecode
    mihomo
    google-chrome
  ];

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

  services.flatpak.enable = true;
  system.activationScripts.flatpakFlathubMirror.text = ''
    ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
    ${pkgs.flatpak}/bin/flatpak remote-modify flathub --url=https://mirrors.ustc.edu.cn/flathub || true
  '';
}

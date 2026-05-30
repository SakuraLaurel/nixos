{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
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
      nerd-fonts.jetbrains-mono  # 拉丁字母 + 终端 / nixvim 图标
      noto-fonts-cjk-sans  # 中文 / 日文 / 韩文，接近系统 UI 的无衬线风格
      noto-fonts-color-emoji  # emoji
    ];
  };

  services.flatpak.enable = true;
}

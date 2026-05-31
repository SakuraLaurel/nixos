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
    fontconfig = {
      enable = true;

      defaultFonts = {
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK TC"
          "Noto Sans CJK SC"
          "Noto Color Emoji"
        ];

        serif = [
          "Noto Serif"
          "Noto Serif CJK TC"
          "Noto Serif CJK SC"
          "Noto Color Emoji"
        ];

        monospace = [
          "JetBrainsMono Nerd Font"
          "Noto Sans Mono CJK TC"
          "Noto Sans Mono CJK SC"
          "Noto Color Emoji"
        ];

        emoji = [
          "Noto Color Emoji"
        ];
      };
    };

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
    ];
  };

  services.flatpak.enable = true;
}

{ pkgs, ... }:

{
  programs.konsole = {
    enable = true;
    defaultProfile = "main";
    customColorSchemes = {
      "rose-pine-dawn" = ./rose-pine-dawn.colorscheme;
    };

    profiles.main = {
      colorScheme = "rose-pine-dawn";
      font.size = 14;
    };
  };
}

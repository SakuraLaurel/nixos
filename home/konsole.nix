{ pkgs, ... }:

{
  programs.konsole = {
    enable = true;
    defaultProfile = "GreenWhite";
    customColorSchemes.GreenWhite = pkgs.writeText "GreenWhite.colorscheme" ''
      [Background]
      Color=0,80,0

      [BackgroundIntense]
      Color=0,100,0

      [Foreground]
      Color=255,255,255

      [ForegroundIntense]
      Bold=true
      Color=255,255,255

      [Color0]
      Color=0,0,0

      [Color0Intense]
      Color=85,85,85

      [Color1]
      Color=255,80,80

      [Color1Intense]
      Color=255,120,120

      [Color2]
      Color=120,255,120

      [Color2Intense]
      Color=180,255,180

      [Color3]
      Color=255,255,120

      [Color3Intense]
      Color=255,255,180

      [Color4]
      Color=120,180,255

      [Color4Intense]
      Color=180,220,255

      [Color5]
      Color=255,120,255

      [Color5Intense]
      Color=255,180,255

      [Color6]
      Color=120,255,255

      [Color6Intense]
      Color=180,255,255

      [Color7]
      Color=230,230,230

      [Color7Intense]
      Color=255,255,255

      [General]
      Description=Green White
      Opacity=1
      Wallpaper=
    '';

    profiles.GreenWhite = {
      colorScheme = "GreenWhite";
    };
  };
}

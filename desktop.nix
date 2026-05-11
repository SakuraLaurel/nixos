{ inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.sharedModules = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];
  home-manager.users.sakura = {
    home.stateVersion = "25.11";

    programs.plasma = {
      enable = true;

      configFile.kwinrc = {
      # Plasma 6 默认左上角“概览/Overview”热角
      "Effect-overview"."BorderActivate" = 9;

      # 兼容/清掉旧的 Present Windows / Desktop Grid 边缘触发
      "Effect-PresentWindows" = {
        BorderActivate = 9;
        BorderActivateAll = 9;
        BorderActivateClass = 9;
      };

      "Effect-DesktopGrid"."BorderActivate" = 9;

      # 清空 8 个屏幕边缘/角落
      ElectricBorders = {
        Top = "None";
        TopRight = "None";
        Right = "None";
        BottomRight = "None";
        Bottom = "None";
        BottomLeft = "None";
        Left = "None";
        TopLeft = "None";
       };
      };

      shortcuts = {
        "org.kde.spectacle.desktop" = {
          "FullScreenScreenShot" = "Alt+%";
          "ActiveWindowScreenShot" = "Alt+#";
          "RectangularRegionScreenShot" = "Alt+$";
        };
      };

      configFile."spectaclerc"."General" = {
        autoSaveImage = true;
        copyImageToClipboard = true;
      };

      kscreenlocker = {
        autoLock = false;
        lockOnResume = false;
        timeout = 114514;
      };

      powerdevil.AC = {
        turnOffDisplay.idleTimeout = "never";
        autoSuspend.action = "nothing";
        dimDisplay.enable = false;
      };
    };
  };
}
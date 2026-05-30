{
  programs.plasma = {
    enable = true;

    configFile = {
      kwinrc = {
        "Effect-overview"."BorderActivate" = 9;
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
	Wayland.InputMethod = {
          value = "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";
          shellExpand = true;
        };
      };
      kcminputrc.Keyboard.NumLock = 0;
      spectaclerc.General = {
        autoSaveImage = true;
	clipboardGroup = "PostScreenshotCopyImage";
      };
    };

    shortcuts = {
      "org.kde.spectacle.desktop" = {
        "FullScreenScreenShot" = "Alt+%";
        "ActiveWindowScreenShot" = "Alt+#";
        "RectangularRegionScreenShot" = "Alt+$";
      };
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
}

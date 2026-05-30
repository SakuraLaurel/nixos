{ pkgs, ... }:

{
  time.timeZone = "Asia/Shanghai";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "zh_CN.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];

    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
      LC_MESSAGES = "zh_CN.UTF-8";
    };

    inputMethod = {
      type = "fcitx5";
      enable = true;

      fcitx5 = {
        waylandFrontend = true;
        ignoreUserConfig = true;

        addons = with pkgs; [
          kdePackages.fcitx5-chinese-addons
          kdePackages.fcitx5-qt
          fcitx5-gtk
        ];

        settings = {
          inputMethod = {
            GroupOrder."0" = "Default";

            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "pinyin";
            };

            "Groups/0/Items/0".Name = "keyboard-us";
            "Groups/0/Items/1".Name = "pinyin";
          };
        };
      };
    };
  };
}

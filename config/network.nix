{ pkgs, ... }:

{
  hardware.usb-modeswitch.enable = true;
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", ATTR{idProduct}=="2870", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -K -v 0e8d -p 2870"
  '';

  networking = {
    hostName = "laurel";
    useDHCP = false;
    firewall.enable = true;
    wireless.iwd.enable = true;
  };

  systemd.network = {
    enable = true;
    wait-online.enable = false;
    networks = {
      "10-ethernet" = {
        matchConfig.Type = "ether";
        networkConfig.DHCP = "yes";
        linkConfig.RequiredForOnline = "no";
      };
      "20-wlan" = {
        matchConfig.Type = "wlan";
        networkConfig.DHCP = "yes";
        linkConfig.RequiredForOnline = "no";
      };
    };
  };

  services = {
    resolved.enable = true;
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true; # 配好 SSH key 后建议改 false
      };
    };
  };
}

{ pkgs, ... }:

{
  networking.hostName = "laurel";
  networking.useDHCP = false;
  networking.firewall.enable = true;
  networking.wireless.iwd.enable = true;
  systemd.network = {
    enable = true;

    networks."10-ethernet" = {
      matchConfig.Type = "ether";
      networkConfig.DHCP = "yes";
      linkConfig.RequiredForOnline = "no";
    };

    networks."20-wlan" = {
      matchConfig.Type = "wlan";
      networkConfig.DHCP = "yes";
      linkConfig.RequiredForOnline = "no";
    };
  };
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true; # 配好 SSH key 后建议改 false
    };
  };
  services.resolved.enable = true;
  services.mihomo = {
    enable = true;
    configFile = "/var/lib/mihomo/config.yaml";
    tunMode = true;
    processesInfo = true;
    webui = pkgs.metacubexd;
  };
}

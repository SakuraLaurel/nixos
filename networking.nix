{ pkgs, ... }:

{
  services.resolved.enable = true;
  networking.useDHCP = false;
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
    };
  };

  services.mihomo = {
    enable = true;
    configFile = "/var/lib/mihomo/config.yaml";
    tunMode = true;
    processesInfo = true;
    webui = pkgs.metacubexd;
  };

  networking.firewall.enable = true;
}

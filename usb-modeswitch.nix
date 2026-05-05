{ pkgs, ... }:

{
  hardware.usb-modeswitch.enable = true;
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", ATTR{idProduct}=="2870", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -K -v 0e8d -p 2870"
  '';
}
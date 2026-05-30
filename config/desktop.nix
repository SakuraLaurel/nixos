{
  services = {
    xserver.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
      };
      autoLogin = {
        enable = true;
        user = "sakura";
      };
    };
    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  security.rtkit.enable = true;
}

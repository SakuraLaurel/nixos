{
  users.mutableUsers = false;
  users.users.root.hashedPasswordFile = "/etc/nixos/root-password-hash";
  users.users.sakura = {
    isNormalUser = true;
    description = "Sakura";
    extraGroups = [ "wheel" "video" "audio" "input" ];
    hashedPasswordFile = "/etc/nixos/sakura-password-hash";
  };
  security.sudo.wheelNeedsPassword = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "sakura";
  };
  programs.git = {
    enable = true;
    config = {
      user.name = "SakuraLaurel";
      user.email = "1700012467@pku.edu.cn";
    };
  };
}

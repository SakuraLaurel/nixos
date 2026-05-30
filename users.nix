{
  users.mutableUsers = false;
  users.users.root.hashedPasswordFile = "/etc/nixos/sakura-password-hash";
  users.users.sakura = {
    isNormalUser = true;
    description = "Sakura";
    extraGroups = [ "wheel" "video" "audio" "input" ];
    hashedPasswordFile = "/etc/nixos/sakura-password-hash";
  };
  security.sudo.wheelNeedsPassword = true;
}

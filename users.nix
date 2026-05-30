{
  users.mutableUsers = false;
  users.users.root.hashedPasswordFile = "$HOME/sakura/nixos/root-password-hash";
  users.users.sakura = {
    isNormalUser = true;
    description = "Sakura";
    extraGroups = [ "wheel" "video" "audio" "input" ];
    hashedPasswordFile = "$HOME/sakura/nixos/sakura-password-hash";
  };
  security.sudo.wheelNeedsPassword = true;
}

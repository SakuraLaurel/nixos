{ config, pkgs, ... }:

{
  imports = [
    ./config/desktop.nix
    ./config/locale.nix
    ./config/network.nix
    ./graphic.nix
    ./hardware-configuration.nix
    ./shell.nix
    ./software.nix
    ./system.nix
    ./users.nix
  ];
}

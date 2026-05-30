{ pkgs, ... }:

{
  imports = [
    ./plasma.nix
    ./konsole.nix
    ./neovim.nix
  ];

  home.stateVersion = "26.11";
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "SakuraLaurel";
          email = "brynhild@pku.edu.cn";
        };
      };
    };
  };
  home.activation.addUserFlathub = ''
    ${pkgs.flatpak}/bin/flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    ${pkgs.flatpak}/bin/flatpak --user remote-modify flathub --url=https://mirrors.ustc.edu.cn/flathub
  '';
}

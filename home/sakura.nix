{ pkgs, ... }:

{
  imports = [
    ./plasma.nix
    ./konsole.nix
    ./nixvim.nix
  ];

  home.stateVersion = "26.05";

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

  home.packages = with pkgs; [
    cmake
    ninja
    gcc
    clang-tools
    pyright
    ruff
    (python314.withPackages (
      ps: with ps; [
        pytest
        requests
        numpy
        matplotlib
      ]
    ))
  ];
}

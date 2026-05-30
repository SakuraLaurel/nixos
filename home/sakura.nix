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
}

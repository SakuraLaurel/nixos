{
  description = "Nixos configuration of SakuraLaurel";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ nixpkgs, ... }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    pythonEnv = pkgs.python313.withPackages (ps: with ps; [
      numpy
      matplotlib
      requests
    ]);
  in
  {
    nixosConfigurations.laurel = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
      ];
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pythonEnv
      ];
    };
  };
}

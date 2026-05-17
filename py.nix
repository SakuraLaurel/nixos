{
  description = "Standalone Python development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      pythonEnv = pkgs.python313.withPackages (ps: with ps; [
        numpy
        matplotlib
        requests
      ]);
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
            pythonEnv
        ];
      };
    };
}

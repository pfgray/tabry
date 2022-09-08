{
  description = "Tabry";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
        let
          pkgs = nixpkgs.legacyPackages."${system}";
          tabry = import ./default.nix pkgs;
        in {
          packages = {
            default = tabry;
            tabry = tabry;
          };
        }
    );
}
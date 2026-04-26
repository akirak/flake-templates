# SPDX-License-Identifier: Unlicense
{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # systems.url = "github:nix-systems/default";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system: f system nixpkgs.legacyPackages.${system}
        );
    in
    {
      packages = eachSystem (_system: pkgs: {
        hello = pkgs.hello;
      });

      devShells = eachSystem (_system: pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Add development dependencies here
          ];
        };
      });
    };
}

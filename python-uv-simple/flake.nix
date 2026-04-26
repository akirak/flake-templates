# SPDX-License-Identifier: Unlicense
{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # systems.url = "github:nix-systems/default";
  };

  outputs =
    { nixpkgs, ... }:
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system: f system nixpkgs.legacyPackages.${system}
        );
    in
    {
      devShells = eachSystem (_system: pkgs: {
        default = pkgs.mkShell {
          buildInputs = [
            pkgs.python3
            pkgs.uv
            pkgs.basedpyright
          ];
        };
      });
    };
}

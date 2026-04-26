# SPDX-FileCopyrightText: 2024-2025 Akira Komamura
# SPDX-License-Identifier: MIT
{
  inputs = {
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      systems,
      treefmt-nix,
      nixpkgs,
      self,
      ...
    }:
    let
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f system nixpkgs.legacyPackages.${system});

      treefmtEval = eachSystem (_system: pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      devShells = eachSystem (_system: pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.nodejs
            pkgs.corepack
            pkgs.typescript-go
          ];
        };
      });

      formatter = eachSystem (system: _pkgs: treefmtEval.${system}.config.build.wrapper);

      checks = eachSystem (system: _pkgs: {
        treefmt = treefmtEval.${system}.config.build.check self;
      });
    };
}

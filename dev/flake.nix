# SPDX-FileCopyrightText: 2023-2026 Akira Komamura
# SPDX-License-Identifier: MIT
{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # To be overridden during execution
    src.url = "github:akirak/flake-templates";
  };

  outputs =
    {
      self,
      systems,
      nixpkgs,
      treefmt-nix,
      ...
    }@inputs:
    let
      eachSystem =
        f: nixpkgs.lib.genAttrs (import systems) (system: f system nixpkgs.legacyPackages.${system});

      treefmtEval = eachSystem (
        system: pkgs:
        treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs.nixfmt.enable = true;
        }
      );
    in
    {
      formatter = eachSystem (system: pkgs: treefmtEval.${system}.config.build.wrapper);

      checks = eachSystem (
        system: pkgs: {
          treefmt = treefmtEval.${system}.config.build.check self;
        }
      );
    };
}

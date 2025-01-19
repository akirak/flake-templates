# SPDX-FileCopyrightText: 2021-2025 Akira Komamura
# SPDX-License-Identifier: Unlicense
{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      systems,
      pre-commit-hooks,
    }:
    flake-utils.lib.eachSystem (import systems) (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        packages = flake-utils.lib.flattenTree { hello = pkgs.hello; };
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt.enable = true;
              # statix.enable = false;
            };
          };
        };
        devShells.default = pkgs.mkShell { inherit (self.checks.${system}.pre-commit-check) shellHook; };
      }
    );
}

# SPDX-License-Identifier: Unlicense
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    # treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        # inputs.flake-parts.flakeModules.partitions
        # inputs.treefmt-nix.flakeModule
      ];

      # partitions.dev = {
      #   extraInputsFlake = ./dev;
      #   module = {
      #     imports = [ ./dev/flake-module.nix ];
      #   };
      # };

      # partitionedAttrs = {
      #   checks = "dev";
      #   devShells = "dev";
      # };

      perSystem =
        {
          system,
          pkgs,
          inputs',
          ...
        }:
        {
          # You can use `extend' to extend the packages with an overlay (or use
          # `import inputs.nixpkgs { ... }`).
          _module.args.pkgs = inputs.nixpkgs.legacyPackages.${system};

          devShells.default = pkgs.mkShell {
            packages = [ ];
          };
        };
    };
}

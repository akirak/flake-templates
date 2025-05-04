# SPDX-License-Identifier: Unlicense
{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      ...
    }@inputs:
    let
      eachSystem = f: nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: f nixpkgs.legacyPackages.${system});

      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      packages = eachSystem (pkgs: {
        # default = pkgs.hello;
      });

      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell (
          with pkgs;
          {
            buildInputs = [
              # Add development dependencies here
            ];
          }
        );
      });

      # Run `nix fmt [FILE_OR_DIR]...` to execute formatters configured in treefmt.nix.
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      checks = eachSystem (pkgs: {
        # Throws an error if any of the source files are not correctly formatted
        # when you run `nix flake check --print-build-logs`. Useful for CI
        treefmt = treefmtEval.${pkgs.system}.config.build.check self;
      });
    };
}

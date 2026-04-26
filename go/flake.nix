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

  # Configure a binary cache for your executable(s).
  # nixConfig = {
  #   extra-substituters =
  #     [
  #     ];
  #   extra-trusted-public-keys =
  #     [
  #     ];
  # };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      eachSystem =
        f:
        lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: f system nixpkgs.legacyPackages.${system});

      treefmtEval = eachSystem (_system: pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      # Build executables. See https://nixos.org/manual/nixpkgs/stable/#sec-language-go
      packages = eachSystem (
        system: pkgs: {
          # default = pkgs.buildGoModule {
          #   pname = "hello";
          #   version = builtins.substring 0 8 (self.lastModifiedDate or "19700101");
          #   src = self.outPath;
          #   vendorHash = lib.fakeHash;
          #   meta = { };
          # };
        }
      );

      devShells = eachSystem (
        system: pkgs: {
          default = pkgs.mkShell {
            packages = [
              pkgs.go
              pkgs.gopls
            ];
          };
        }
      );

      formatter = eachSystem (system: pkgs: treefmtEval.${system}.config.build.wrapper);

      checks = eachSystem (
        system: pkgs: {
          treefmt = treefmtEval.${system}.config.build.check self;
        }
      );
    };
}

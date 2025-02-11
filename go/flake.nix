# SPDX-FileCopyrightText: 2024 Akira Komamura
# SPDX-License-Identifier: Unlicense
{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
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
      systems,
      nixpkgs,
      treefmt-nix,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      eachSystem = f: lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});

      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      # Build executables. See https://nixos.org/manual/nixpkgs/stable/#sec-language-go
      packages = eachSystem (pkgs: {
        # default = pkgs.buildGoModule {
        #   pname = "hello";
        #   version = builtins.substring 0 8 (self.lastModifiedDate or "19700101");
        #   src = self.outPath;
        #   vendorHash = lib.fakeHash;
        #   meta = { };
        # };
      });

      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.go
            pkgs.gopls
          ];
        };
      });

      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      checks = eachSystem (pkgs: {
        treefmt = treefmtEval.${pkgs.system}.config.build.check self;
      });
    };
}

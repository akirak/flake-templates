# SPDX-License-Identifier: Unlicense
{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # systems.url = "github:nix-systems/default";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;

      eachSystem =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system: f system nixpkgs.legacyPackages.${system}
        );

      beamVersion = "beam28Packages";
    in
    {
      packages = eachSystem (_system: pkgs: { });

      devShells = eachSystem (
        _system: pkgs: {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.gleam
              pkgs.${beamVersion}.erlang
              pkgs.${beamVersion}.rebar3
              pkgs.nodejs
              pkgs.corepack
              pkgs.typescript-go
            ]
            ++ lib.optional pkgs.stdenv.isLinux pkgs.inotify-tools
            ++ (lib.optionals pkgs.stdenv.isDarwin (
              with pkgs.darwin.apple_sdk.frameworks;
              [
                CoreFoundation
                CoreServices
              ]
            ));
          };
        }
      );
    };
}

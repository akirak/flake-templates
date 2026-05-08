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

      beamVersion = "beam28Packages";
    in
    {
      packages = eachSystem (_system: pkgs: { });

      devShells = eachSystem (
        _system: pkgs: {
          default = pkgs.mkShell {
            buildInputs =
              let
                beamPackages = pkgs.${beamVersion};
              in
              with pkgs;
              (
                [
                  gleam
                  beamPackages.erlang
                  beamPackages.rebar3
                ]
                ++ lib.optional stdenv.isLinux inotify-tools
                ++ (lib.optionals stdenv.isDarwin (
                  with darwin.apple_sdk.frameworks;
                  [
                    CoreFoundation
                    CoreServices
                  ]
                ))
              );
          };
        }
      );
    };
}

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
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: f nixpkgs.legacyPackages.${system});

      erlang_version = "erlang_27";
    in
    {
      packages = eachSystem (pkgs: { });

      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          buildInputs =
            with pkgs;
            (
              [
                gleam
                beam.interpreters.${erlang_version}
                beam.packages.${erlang_version}.rebar3
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
      });
    };
}

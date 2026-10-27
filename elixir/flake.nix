# SPDX-License-Identifier: Unlicense
{
  inputs = {
    # nixpkgs.url = "nixpkgs-unstable";
    # systems.url = "github:nix-systems/default";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;

      # Set the Erlang version
      beamVersion = "beam28Packages";
      # Set the Elixir version
      elixirVersion = "elixir_1_20";

      eachSystem =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system:
          f system (
            import nixpkgs {
              inherit system;
              overlays = [
                (
                  final: _:
                  let
                    beamPackages = final.${beamVersion}.overrideScope (
                      _: prev: {
                        elixir = prev.${elixirVersion};
                      }
                    );
                  in
                  {
                    inherit (beamPackages) erlang elixir;
                    inherit beamPackages;
                  }
                )
              ];
            }
          )
        );
    in
    {
      # packages = eachSystem (_system: pkgs:
      # );

      devShells = eachSystem (
        _system: pkgs: {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              erlang
              elixir
              beamPackages.expert
            ];
          };
        }
      );
    };
}

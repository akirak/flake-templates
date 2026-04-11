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

      # Set the Erlang version
      beamVersion = "beam28Packages";
      # Set the Elixir version
      elixirVersion = "elixir_1_20";

      eachSystem =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system:
          f (
            import nixpkgs {
              inherit system;
              overlays = [
                (
                  final: _:
                  let
                    beamPackages = final.${beamVersion};
                    erlang = beamPackages.erlang;
                    elixir = beamPackages.${elixirVersion};
                  in
                  {
                    inherit erlang elixir;
                    inherit (beamPackages) elixir-ls hex;
                  }
                )
              ];
            }
          )
        );
    in
    {
      # packages = eachSystem (pkgs:
      # );

      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            erlang
            elixir
            elixir-ls
          ];
        };
      });
    };
}

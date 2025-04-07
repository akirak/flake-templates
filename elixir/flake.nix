# SPDX-FileCopyrightText: 2021-2025 Akira Komamura
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
      erlangVersion = "erlang_27";
      # Set the Elixir version
      elixirVersion = "elixir_1_18";

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
                    erlang = final.beam.interpreters.${erlangVersion};
                    beamPackages = final.beam.packages.${erlangVersion};
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

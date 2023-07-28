{
  inputs.systems.url = "github:nix-systems/default";

  outputs = {
    self,
    nixpkgs,
    systems,
    flake-utils,
  }:
    flake-utils.lib.eachSystem (import systems)
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };

        # Set the Erlang version
        erlangVersion = "erlangR25";
        # Set the Elixir version
        elixirVersion = "elixir_1_15";

        erlang = pkgs.beam.interpreters.${erlangVersion};
        beamPackages = pkgs.beam.packages.${erlangVersion};
        elixir = beamPackages.${elixirVersion};
      in rec {
        # TODO: Add your Elixir package
        # packages = flake-utils.lib.flattenTree {
        # } ;

        devShells.default = pkgs.mkShell {
          buildInputs = [
            erlang
            elixir
            beamPackages.elixir-ls
          ];
        };
      }
    );
}

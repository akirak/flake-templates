{
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };

        # Set the Erlang version
        erlangVersion = "erlangR25";
        # Set the Elixir version
        elixirVersion = "elixir_1_14";

        erlang = pkgs.beam.interpreters.${erlangVersion};
        elixir = pkgs.beam.packages.${erlangVersion}.${elixirVersion};
        elixir-ls = pkgs.beam.packages.${erlangVersion}.elixir-ls;
      in rec {
        # TODO: Add your Elixir package
        # packages = flake-utils.lib.flattenTree {
        # } ;

        devShells.default = pkgs.mkShell {
          buildInputs = [
            erlang
            elixir
            elixir-ls
          ];
        };
      }
    );
}

{
  inputs = {
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    nixpkgs,
    systems,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;

    # Set the Erlang version
    erlangVersion = "erlang_25";
    # Set the Elixir version
    elixirVersion = "elixir_1_15";

    eachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (
        system:
          f (import nixpkgs {
            inherit system;
            overlays = [
              (final: _: let
                erlang = final.beam.interpreters.${erlangVersion};
                beamPackages = final.beam.packages.${erlangVersion};
                elixir = beamPackages.${elixirVersion};
              in {
                inherit erlang elixir;
                inherit (beamPackages) elixir-ls hex;
              })
            ];
          })
      );
  in {
    # packages = eachSystem (pkgs:
    # );

    devShells = eachSystem (
      pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            erlang
            elixir
            elixir-ls
          ];
        };
      }
    );
  };
}

{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    systems,
    nixpkgs,
    ...
  } @ inputs: let
    eachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (
        system:
          f nixpkgs.legacyPackages.${system}
      );

    erlang_version = "erlang_25";
  in {
    packages =
      eachSystem (pkgs: {
      });

    devShells = eachSystem (pkgs: {
      default = pkgs.mkShell {
        buildInputs = [
          pkgs.gleam
          pkgs.beam.interpreters.${erlang_version}
          pkgs.beam.packages.${erlang_version}.rebar3
        ];
      };
    });
  };
}

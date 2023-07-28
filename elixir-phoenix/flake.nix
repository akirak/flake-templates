{
  inputs.pre-commit-hooks = {
    url = "github:cachix/pre-commit-hooks.nix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };
  inputs.systems.url = "github:nix-systems/default";

  outputs = {
    self,
    nixpkgs,
    systems,
    flake-utils,
    pre-commit-hooks,
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

        inherit (pkgs.lib) optional optionals;

        fileWatchers = with pkgs; (optional stdenv.isLinux inotify-tools
        ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
          CoreFoundation
          CoreServices
        ]));
      in rec {
        # TODO: Add your Elixir package
        # packages = flake-utils.lib.flattenTree {
        # } ;

        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              # TODO: Add a linter for Elixir
            };
          };
        };
        devShells.default = nixpkgs.legacyPackages.${system}.mkShell {
          buildInputs =
            [
              erlang
              elixir
              beamPackages.elixir-ls
            ]
            ++ (with pkgs; [
              nodejs
            ])
            ++ fileWatchers;

          inherit (self.checks.${system}.pre-commit-check) shellHook;

          LANG = "C.UTF-8";
          ERL_AFLAGS = "-kernel shell_history enabled";
        };
      }
    );
}

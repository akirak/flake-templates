{
  description = "A Phoenix project";

  inputs.pre-commit-hooks = {
    url = "github:cachix/pre-commit-hooks.nix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pre-commit-hooks,
  }:
    flake-utils.lib.eachSystem [
      # TODO: Configure your supported system here.
      "x86_64-linux"
      "aarch64-linux"
      "i686-linux"
      "x86_64-darwin"
    ]
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
        elixir_ls = pkgs.beam.packages.${erlangVersion}.elixir_ls;

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
              elixir_ls
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

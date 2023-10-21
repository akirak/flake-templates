{
  inputs = {
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    pre-commit-hooks,
    ...
  }: let
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
    # TODO: Add your Elixir package
    # packages = flake-utils.lib.flattenTree {
    # } ;

    checks = eachSystem (pkgs: {
      pre-commit-check = pre-commit-hooks.lib.${pkgs.system}.run {
        src = ./.;
        hooks = {
          # TODO: Add a linter for Elixir
        };
      };
    });

    devShells = eachSystem (pkgs: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; (
          [
            erlang
            elixir
            elixir-ls
            nodejs
          ]
          ++ lib.optional stdenv.isLinux inotify-tools
          ++ (
            lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
              CoreFoundation
              CoreServices
            ])
          )
        );

        inherit (self.checks.${pkgs.system}.pre-commit-check) shellHook;

        ERL_AFLAGS = "-kernel shell_history enabled";
      };
    });
  };
}

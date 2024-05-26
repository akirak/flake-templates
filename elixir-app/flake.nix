{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    # Lexical is an alternative LSP server. There are several options for Elixir
    # LSP. See https://gist.github.com/Nezteb/dc63f1d5ad9d88907dd103da2ca000b1
    lexical.url = "github:lexical-lsp/lexical";
    # Use process-compose to manage background processes during development
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    flake-parts,
    ...
  } @ inputs: let
    # Set the Erlang version
    erlangVersion = "erlang_25";
    # Set the Elixir version
    elixirVersion = "elixir_1_15";
  in
    flake-parts.lib.mkFlake {
      inherit inputs;
    } {
      systems = import systems;

      imports = [
        inputs.process-compose-flake.flakeModule
      ];

      perSystem = {
        # self',
        config,
        system,
        pkgs,
        lib,
        ...
      }: {
        # Define a consistent package set for development, testing, and
        # production.
        _module.args.pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: _: let
              erlang = final.beam.interpreters.${erlangVersion};
              beamPackages = final.beam.packages.${erlangVersion};
              elixir = beamPackages.${elixirVersion};
            in {
              inherit erlang elixir;
              # Hex is not used in the devShell.
              # inherit (beamPackages) hex;
            })
          ];
        };

        # You can build your Elixir application using mixRelease.
        # packages.default = { };

        # Add dependencies to develop your application using Mix.
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; (
            [
              erlang
              elixir
              # You are likely to need Node.js if you develop a Phoenix
              # application.
              nodejs
              # Add the language server of your choice.
              inputs.lexical.packages.${system}.default
              # I once added Hex via a Nix development shell, but now I install
              # and upgrade it using Mix. Hex installed using Nix can cause an
              # issue if you manage Elixir dependencies using Mix.
            ]
            # Add a dependency for a file watcher if you develop a Phoenix
            # application.
            ++ lib.optional stdenv.isLinux inotify-tools
            ++ (
              lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
                CoreFoundation
                CoreServices
              ])
            )
          );
        };

        # You can define background processes in Nix using
        # process-compose-flake.
        process-compose.example = {
          settings = {
            processes = {
              ponysay.command = ''
                while true; do
                  ${lib.getExe pkgs.ponysay} "Enjoy our ponysay demo!"
                  sleep 2
                done
              '';
            };
          };
        };
      };
    };
}

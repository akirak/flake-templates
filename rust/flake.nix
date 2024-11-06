{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    rust-overlay.url = "github:oxalica/rust-overlay";
    crane.url = "github:ipetkov/crane";
  };

  # Add settings for your binary cache.
  nixConfig =
    {
    };

  outputs =
    inputs@{ nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          config,
          system,
          pkgs,
          lib,
          craneLib,
          commonArgs,
          ...
        }:
        {
          _module.args = {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ inputs.rust-overlay.overlays.default ];
            };
            craneLib = (inputs.crane.mkLib pkgs).overrideToolchain (pkgs: pkgs.rust-bin.stable.latest.default);
            commonArgs = {
              # Depending on your code base, you may have to customize the
              # source filtering to include non-standard files during the build.
              # See
              # https://crane.dev/source-filtering.html?highlight=source#source-filtering
              src = craneLib.cleanCargoSource (craneLib.path ./.);

              # nativeBuildInputs = with pkgs; [
              #   pkg-config
              # ];

              # buildInputs = with pkgs; [
              #   openssl
              # ];
            };
          };

          # Build the executable package.
          packages.default = craneLib.buildPackage (
            commonArgs
            // {
              cargoArtifacts = craneLib.buildDepsOnly commonArgs;
            }
          );

          devShells.default = craneLib.devShell {
            packages =
              (commonArgs.nativeBuildInputs or [ ])
              ++ (commonArgs.buildInputs or [ ])
              ++ [ pkgs.rust-analyzer-unwrapped ];

            RUST_SRC_PATH = "${pkgs.rust-bin.stable.latest.rust-src}/lib/rustlib/src/rust/library";
          };

          treefmt = {
            projectRootFile = "Cargo.toml";
            programs = {
              actionlint.enable = true;
              nixfmt.enable = true;
              rustfmt.enable = true;
            };
          };
        };
    };
}

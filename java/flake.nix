# SPDX-License-Identifier: Unlicense
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = import inputs.systems;

      perSystem =
        {
          system,
          pkgs,
          inputs',
          ...
        }:
        let
          # Set this to the JDK version you want to use.
          jdk = pkgs.openjdk21_headless;

          maven = pkgs.maven.override {
            jdk_headless = jdk;
          };

          # The gradle version depends on the JDK version.
          gradle = pkgs.gradle_8;
        in
        {
          # You can use `extend' to extend the packages with an overlay (or use
          # `import inputs.nixpkgs { ... }`).
          # _module.args.pkgs = inputs.nixpkgs.legacyPackages.${system};

          devShells.default = pkgs.mkShell {
            packages = [
              jdk

              (pkgs.jdt-language-server.override {
                inherit jdk;
              })

              # Add this if you use Gradle Kotlin DSL.
              (pkgs.kotlin-language-server.override {
                openjdk = jdk;
                inherit maven gradle;
              })
            ];
          };
        };

    };
}

{
  description = "A collection of project templates";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/master";
  inputs.pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pre-commit-hooks,
    ...
  }:
    {
      templates = {
        meta = {
          path = ./meta;
          description = "Miscellaneous files for GitHub projects";
        };
        dir-locals = {
          path = ./dir-locals;
          description = "An opinionated .dir-locals.el for Emacs users";
        };
        minimal = {
          path = ./minimal;
          description = "Minimal boilerplate with flake-utils";
        };
        pre-commit = {
          path = ./pre-commit;
          description = "Basic flake with pre-commit check";
        };
        node-typescript = {
          path = ./node-typescript;
          description = "Toolchain for TypeScript frontend projects";
        };
        elixir = {
          path = ./elixir;
          description = "Simple Elixir project";
        };
        elixir-phoenix = {
          path = ./elixir-phoenix;
          description = "Elixir Phoenix project where you use Mix";
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        apps.update-beam = {
          type = "app";
          program = "${pkgs.callPackage ./updater.nix {}}";
        };

        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              alejandra.enable = true;
            };
          };
        };
        devShells.default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
      }
    );
}

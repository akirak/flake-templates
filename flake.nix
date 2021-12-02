{
  description = "Personal collection of flake templates";

  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.pre-commit-hooks = {
    url = "github:cachix/pre-commit-hooks.nix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , pre-commit-hooks
    }:
    {
      templates = {
        minimal = {
          path = ./minimal;
          description = "Minimal boilerplate with flake-utils";
        };
        pre-commit = {
          path = ./pre-commit;
          description = "Basic flake with pre-commit check";
        };
        elixir-phoenix = {
          path = ./elixir-phoenix;
          description = "Elixir Phoenix project where you use Mix";
        };
      };
    } //
    (flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
              nix-linter.enable = true;
            };
          };
        };
        devShell = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
      }));
}

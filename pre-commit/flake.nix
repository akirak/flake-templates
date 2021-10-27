{
  description = "Basic project with pre-commit check";

  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.pre-commit-hooks = {
    url = "github:cachix/pre-commit-hooks.nix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };
  inputs.gitignore = {
    url = "github:hercules-ci/gitignore.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , pre-commit-hooks
    , gitignore
    }:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs { inherit system; };

        inherit (gitignore.lib) gitignoreSource;
      in
      rec {
        packages = flake-utils.lib.flattenTree {
          hello = pkgs.hello;
        };
        # defaultPackage = packages.hello;
        # apps.hello = flake-utils.lib.mkApp { drv = packages.hello; };
        # defaultApp = apps.hello;
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = gitignoreSource ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
              nix-linter.enable = true;
            };
          };
        };
        devShell = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
      });
}

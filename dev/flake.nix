{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    # To be overridden during execution
    src.url = "github:akirak/flake-templates";
  };

  outputs = {
    self,
    systems,
    nixpkgs,
    pre-commit-hooks,
    ...
  } @ inputs: let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
  in {
    packages = eachSystem (system: {
      update-beam = nixpkgs.legacyPackages.${system}.callPackage ./update-beam.nix {};
    });

    checks = eachSystem (system: {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = inputs.src.outPath;
        hooks = {
          actionlint.enable = true;
          alejandra.enable = true;
          markdownlint.enable = true;
        };
      };
    });

    devShells = eachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };
    });
  };
}

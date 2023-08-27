{
  inputs.systems.url = "github:nix-systems/default";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    systems,
  }:
    flake-utils.lib.eachSystem (import systems)
    (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # packages = flake-utils.lib.flattenTree {
      # };

      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          pulumi
          pulumiPackages.pulumi-language-nodejs
          nodePackages.typescript-language-server
        ];
      };
    });
}

{
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      packages = flake-utils.lib.flattenTree {
        inherit (pkgs) hello;
      };

      # devShells.default = pkgs.mkShell {
      #   buildInputs = [
      #   ];
      # };
    });
}

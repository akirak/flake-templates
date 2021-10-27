{
  description = "Minimal flake project";

  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    }:
    flake-utils.lib.eachDefaultSystem
      (system:
      rec {
        packages = flake-utils.lib.flattenTree {
          hello = nixpkgs.legacyPackages.${system}.hello;
        };
        # defaultPackage = packages.hello;
        # apps.hello = flake-utils.lib.mkApp { drv = packages.hello; };
        # defaultApp = apps.hello;
      });
}

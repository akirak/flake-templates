{
  inputs = {
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    systems,
    nixpkgs,
    ...
  } @ inputs: let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
  in {
    packages = eachSystem (system: {
      hello = nixpkgs.legacyPackages.${system}.hello;
    });
  };
}

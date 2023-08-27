{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/master";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    systems,
    nixpkgs,
    ...
  } @ inputs: let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsFor = system: nixpkgs.legacyPackages.${system};
  in {
    packages = eachSystem (system: {
      hello = (pkgsFor system).hello;
    });

    devShells = eachSystem (system: {
      default = (pkgsFor system).mkShell {
        buildInputs = with (pkgsFor system); [
          # Add development dependencies here
        ];
      };
    });
  };
}

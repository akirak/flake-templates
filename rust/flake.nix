{
  inputs = {
    rust-overlay.url = "github:oxalica/rust-overlay";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    systems,
    nixpkgs,
    ...
  } @ inputs: let
    eachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (
        system:
          f (import nixpkgs {
            inherit system;
            overlays = [inputs.rust-overlay.overlays.default];
          })
      );
  in {
    devShells = eachSystem (pkgs: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          rust-bin.stable.latest.default
          cargo
          # pkg-config
          # openssl
        ];
      };
    });
  };
}

{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";

    # crane = {
    #   url = "github:ipetkov/crane";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    systems,
    nixpkgs,
    treefmt-nix,
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

    rustToolchain = eachSystem (pkgs: pkgs.rust-bin.stable.latest);

    treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
  in {
    # You can use crane to build the Rust application with Nix

    # packages = eachSystem (pkgs: let
    #   craneLib = inputs.crane.lib.${pkgs.system};
    # in {
    #   default = craneLib.buildPackage {
    #     src = craneLib.cleanCargoSource (craneLib.path ./.);
    #   };
    # });

    devShells = eachSystem (pkgs: {
      # Based on a discussion at https://github.com/oxalica/rust-overlay/issues/129
      default = pkgs.mkShell (with pkgs; {
        nativeBuildInputs = [
          clang
          # Use mold when we are runnning in Linux
          (lib.optionals stdenv.isLinux mold)
        ];
        buildInputs = [
          rustToolchain.${pkgs.system}.default
          rust-analyzer-unwrapped
          cargo
          # pkg-config
          # openssl
        ];
        RUST_SRC_PATH = "${
          rustToolchain.${pkgs.system}.rust-src
        }/lib/rustlib/src/rust/library";
      });
    });

    formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

    checks = eachSystem (pkgs: {
      formatting = treefmtEval.${pkgs.system}.config.build.check self;
    });
  };
}

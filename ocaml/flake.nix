{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";

    ocaml-overlays.url = "github:nix-ocaml/nix-overlays";
    ocaml-overlays.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    systems,
    nixpkgs,
    ocaml-overlays,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;

    eachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (
        system: let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ocaml-overlays.overlays.default];
          };
        in
          f
          {
            inherit pkgs system;
            ocamlPackages = pkgs.ocaml-ng.ocamlPackages_latest;
          }
      );
  in {
    ocamlPackages = eachSystem ({ocamlPackages, ...}: ocamlPackages);

    packages = eachSystem ({
      pkgs,
      ocamlPackages,
      ...
    }: {
      default = ocamlPackages.buildDunePackage {
        pname = throw "Name your OCaml package";
        version = throw "Version your OCaml package";
        duneVersion = "3";
        src = self.outPath;

        # Add ocamlPackages.dream if you need the executable of dream_eml during
        # build

        buildInputs = with ocamlPackages; [
          ocaml-syntax-shims
        ];

        propagatedBuildInputs = with ocamlPackages; [
          # Add OCaml dependencies required for your project

          # Jane Street
          base
          core
          core_unix

          # Some common dependencies
          # eio
          # eio_main
          # yojson
          # ppx_yojson_conv
        ];
      };
    });

    devShells = eachSystem ({
      pkgs,
      ocamlPackages,
      ...
    }: {
      default = pkgs.mkShell {
        inputsFrom = [self.packages.${pkgs.system}.default];
        buildInputs =
          lib.optional pkgs.stdenv.isLinux pkgs.inotify-tools
          ++ (with ocamlPackages; [
            ocaml-lsp
            ocamlformat
            ocp-indent
            utop
            # Needed for generating documentation
            opam
            odoc
            odig
            (sherlodoc.override {enableServe = true;})
          ]);
        shellHook = ''
          export OCAMLRUNPARAM=b
        '';
      };
    });
  };
}

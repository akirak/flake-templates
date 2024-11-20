{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";

    ocaml-overlays.url = "github:nix-ocaml/nix-overlays";
  };

  outputs =
    {
      self,
      systems,
      nixpkgs,
      ocaml-overlays,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      eachSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system:
          let
            pkgs = nixpkgs.legacyPackages.${system}.extend ocaml-overlays.overlays.default;
          in
          f {
            inherit pkgs system;
            # You can set the OCaml version to a particular release. Also, you
            # may have to pin some packages to a particular revision if the
            # devshell fail to build. This should be resolved in the upstream.
            ocamlPackages = pkgs.ocaml-ng.ocamlPackages_latest;
          }
        );
    in
    {
      ocamlPackages = eachSystem ({ ocamlPackages, ... }: ocamlPackages);

      packages = eachSystem (
        { pkgs, ocamlPackages, ... }:
        {
          default = ocamlPackages.buildDunePackage {
            pname = throw "Name your OCaml package";
            version = throw "Version your OCaml package";
            duneVersion = "3";
            src = self.outPath;

            # Uncomment if you need the executable of dream_eml during build
            # nativeBuildInputs = [
            #   ocamlPackages.dream
            # ];

            buildInputs = with ocamlPackages; [ ocaml-syntax-shims ];

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
        }
      );

      devShells = eachSystem (
        { pkgs, ocamlPackages, ... }:
        {
          default = pkgs.mkShell {
            inputsFrom = [ self.packages.${pkgs.system}.default ];
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
                # This may fail to build, so it is turned off by default.
                # (sherlodoc.override { enableServe = true; })
              ]);
          };
        }
      );
    };
}

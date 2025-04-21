{
  inputs.nixpkgs.url = "github:nix-ocaml/nix-overlays";

  outputs =
    {
      nixpkgs,
      self,
      ...
    }:
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system:
          f (
            nixpkgs.legacyPackages.${system}.extend (
              _self: super: {
                # You can set the OCaml version to a particular release. Also, you
                # may have to pin some packages to a particular revision if the
                # devshell fail to build. This should be resolved in the upstream.
                ocamlPackages = super.ocaml-ng.ocamlPackages_latest;
              }
            )
          )
        );
    in
    {
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          # If your project isn't using dune, it probably still depends on make,
          # opam, or something else.
          packages = (
            (with pkgs.ocamlPackages; [
              ocaml
              ocaml-lsp
              ocamlformat
              ocp-indent
              utop
              # Optional; Enable one of these dependencies if your project uses
              # it.
              # ocamlbuild
              # opam
            ])
            # Although Make isn't a strict requirement for development with
            # OCaml, many projects uses it as the build system.
            # ++ [
            #   pkgs.gnumake
            #   pkgs.gdb
            # ]
          );
        };
      });
    };
}

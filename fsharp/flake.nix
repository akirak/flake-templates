{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      systems,
      nixpkgs,
      treefmt-nix,
      ...
    }:
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system:
          f (
            import nixpkgs {
              inherit system;
              config.permittedInsecurePackages = [
                "dotnet-core-combined"
                "dotnet-runtime-6.0.36"
                "dotnet-sdk-6.0.428"
                "dotnet-sdk-7.0.410"
                "dotnet-sdk-wrapped-6.0.428"
              ];
            }
          )
        );

      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      packages = eachSystem (pkgs: {
        # default = pkgs.hello;
      });

      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            dotnetCorePackages.sdk_9_0
            fsautocomplete
            msbuild
          ];
        };
      });

      # Run `nix fmt [FILE_OR_DIR]...` to execute formatters configured in treefmt.nix.
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      checks = eachSystem (pkgs: {
        # Throws an error if any of the source files are not correctly formatted
        # when you run `nix flake check --print-build-logs`. Useful for CI
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });
    };
}

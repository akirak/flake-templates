# SPDX-License-Identifier: Unlicense
{
  inputs = {
    tsgo-effect.url = "github:Effect-TS/tsgo";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;

      eachSystem =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system: f system nixpkgs.legacyPackages.${system}
        );
    in
    {
      devShells = eachSystem (
        system: pkgs:
        let
          buildDeps = [
            pkgs.nodejs
            pkgs.corepack
          ];

          enablePlaywright = false;

          playwright-browsers = pkgs.playwright-driver.browsers.override {
            withFirefox = false;
            withWebkit = false;
            withFfmpeg = false;
            # fontconfig_file = { fontDirectories = []; };
          };

          browserProgram = if pkgs.stdenv.targetPlatform.isLinux then "chrome" else "Chromium";
        in
        {
          default = pkgs.mkShell {
            packages =
              buildDeps
              ++ [
                pkgs.typescript
                inputs.tsgo-effect.packages.${system}.default
              ]
              ++
                # For e2e testing
                lib.optional enablePlaywright playwright-browsers;

            shellHook = lib.optionalString enablePlaywright ''
              browser_executable="$(find -L '${playwright-browsers}' -name ${browserProgram} -type f)"

              export PLAYWRIGHT_LAUNCH_OPTIONS_EXECUTABLE_PATH="''${browser_executable}"
            '';
          };
        }
      );
    };
}

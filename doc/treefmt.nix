{
  projectRootFile = "treefmt.nix";

  # See
  # https://github.com/numtide/treefmt-nix?tab=readme-ov-file#supported-programs
  # for supported programs

  # Nix
  programs.nixfmt.enable = true;

  # JavaScript and JSON
  programs.biome = {
    enable = true;
    settings =
      let
        shared = {
          indentStyle = "space";
          indentWidth = 2;
          lineEnding = "lf";
          lineWidth = 86;
        };
      in
      {
        javascript = {
          formatter = {
            enabled = true;
            quoteStyle = "double";
            trailingComma = "all";
            semicolons = "always";
          } // shared;
        };

        json.formatter = shared;
      };
  };

  # GitHub Actions
  programs.actionlint.enable = true;
}

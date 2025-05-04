# SPDX-License-Identifier: Unlicense
{
  projectRootFile = "treefmt.nix";

  # You can add formatters for your languages.
  # See https://github.com/numtide/treefmt-nix#supported-programs

  # Nix
  programs.nixfmt.enable = true;

  # GitHub Actions
  programs.yamlfmt.enable = true;
  programs.actionlint.enable = true;

  # Markdown
  programs.mdformat.enable = true;
}

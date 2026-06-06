# SPDX-License-Identifier: Unlicense
{
  projectRootFile = "treefmt.nix";

  programs.zig.enable = true;

  # GitHub Actions
  programs.zizmor.enable = true;

  # Markdown
  programs.mdformat.enable = true;

  # Nix
  programs.nixfmt.enable = true;
}

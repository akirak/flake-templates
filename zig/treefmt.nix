{
  projectRootFile = "treefmt.nix";

  programs.zig.enable = true;

  # GitHub Actions
  programs.yamlfmt.enable = true;
  programs.actionlint.enable = true;

  # Markdown
  programs.mdformat.enable = true;

  # Nix
  programs.nixfmt.enable = true;
}

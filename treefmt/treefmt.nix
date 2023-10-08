{
  projectRootFile = "treefmt.nix";

  # Format Nix
  programs.alejandra.enable = true;

  # You can add formatters for your languages.
  # See https://github.com/numtide/treefmt-nix#supported-programs
}

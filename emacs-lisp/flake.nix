{
  outputs = {...}: {
    elisp-rice = {
      packages =
        builtins.trace
        "[1;31mwarning: To use rice-config, please set the package name(s) in flake.nix[0m"
        [
          (abort "Please set the package name (without .el)")
        ];
    };
  };
}

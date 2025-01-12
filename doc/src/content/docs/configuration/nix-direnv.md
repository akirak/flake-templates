---
title: Enable nix-direnv
description: How to set up nix-direnv
---

A recommended way to integrate Nix into your environment is via
[nix-direnv](https://github.com/nix-community/nix-direnv).
Both NixOS and home-manager provide options for running nix-direnv.

[NixOS](https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=nix-direnv):

```nix
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
```

or [home-manager](https://nix-community.github.io/home-manager/options.xhtml):

```nix
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
```

## Further reading

- [nix-direnv](https://github.com/nix-community/nix-direnv)
- [Effortless dev environments with Nix and direnv](https://determinate.systems/posts/nix-direnv/)

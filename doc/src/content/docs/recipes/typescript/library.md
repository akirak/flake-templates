---
title: Developing a TypeScript library
description: How to develop a TypeScript library with a Nix flake template
---

## Initialize a new project

We will be using a framework-specific scaffolder to initialize a project.

First, we need one of `npm`, `yarn`, `pnpm`, or `bun`. Both `npm` and `bun` are
available directly from Nixpkgs, so you can use `nix shell`:

```shell
nix shell nixpkgs#nodejs
```

```shell
nix shell nixpkgs#bun
```

If you prefer `yarn` or `pnpm`, you will probably need both `yarn`/`pnpm` and
`npm`. You can use a devshell in [my
repository](https://github.com/akirak/flake-pins/):

```shell
nix shell github:akirak/flake-pins#yarn
```

```shell
nix shell github:akirak/flake-pins#pnpm
```

or use classic `nix-shell` command:

```shell
nix-shell -p yarn -p nodejs
```

```shell
nix-shell -p pnpm -p nodejs
```

## Add flake.nix to the project

From the top-level of the project directory, run:

```shell
nix flake init github:akirak/flake-templates#node-typescript
```

Open `flake.nix` and comment out `yarn`, `pnpm`, or `bun` in the `buildInputs`
field of the default shell, depending on the package manager of your choice.

Add `.envrc`:

```
use flake
```

Allow direnv:

```shell
direnv allow
```

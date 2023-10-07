# Flake Templates

This is a collection of [Nix flake](https://nixos.wiki/wiki/Flakes) templates I
use in my personal projects. They mostly provide development shells (i.e.
`devShells.*`), but I may add further instructions for production builds in the
future.

For maintaining a complex flake configuration, I would suggest use of
[flake-parts](https://github.com/hercules-ci/flake-parts/) instead.

## List of templates in this repository

### [minimal](minimal/flake.nix)

This is a minimal project boilerplate which depends only on
[nix-systems](https://github.com/nix-systems/nix-systems) and nixpkgs.

``` bash
nix flake init -t github:akirak/flake-templates#minimal
```

### [flake-utils](flake-utils/flake.nix)

This is another minimal project boilerplate with
[flake-utils](https://github.com/numtide/flake-utils). It adds a
`flake-utils` dependency but can be more convenient if you plan to
provide multiple types of outputs from your flake:

``` bash
nix flake init -t github:akirak/flake-templates#flake-utils
```

### [pre-commit](pre-commit/flake.nix)

This is a basic project boilerplate with
[pre-commit-hooks.nix](https://github.com/cachix/pre-commit-hooks.nix)
to run linters.

``` bash
nix flake init -t github:akirak/flake-templates#pre-commit
```

Alternatively, you can set up a pre-commit hook without adding a
boilerplate by running `nix develop` as in
[akirak/git-hooks](https://github.com/akirak/git-hooks).

### [node-typescript](node-typescript/)

This is based on `minimal` but bundles opinionated settings for web
development in TypeScript. You can add it to an existing code base to
start coding without global dependencies.

``` bash
nix flake init -t github:akirak/flake-templates#node-typescript
```

It includes Node, pnpm, TypeScript, and typescript-language-server as
`buildInputs` of the development shell. You can tweak these settings
after initialization, e.g. to use yarn instead of pnpm.

It uses the master branch of NixPkgs to install a recent set of node
packages.

### [elixir](elixir/)

This is a simplified flake.nix for Elixir.

``` bash
nix flake init -t github:akirak/flake-templates#elixir
```

Once you enter the devShell, you can initialize a project by running
`mix`:

``` bash
mix new . --app hello
```

### [elixir-phoenix](elixir-phoenix/flake.nix) (work in progress)

**This is a work in progress.** At present, I have no experience with
Phoenix in production.

This is a boilerplate for developing a web application using Elixir
Phoenix. You won't use Nix to build Elixir applications, but you will
use Mix for your workflow. You may be able to use
[serokell/mix-to-nix](https://github.com/serokell/mix-to-nix) for
building Elixir applications using Nix, but I haven't tried it out yet.

``` bash
nix flake init -t github:akirak/flake-templates#elixir-phoenix
```

### [pulumi-ts](pulumi-ts/flake.nix)

[Pulumi](https://www.pulumi.com/b/), the Node.js language plugin, and
`typescript-language-server` for development.

``` bash
nix flake init -t github:akirak/flake-templates#pulumi-ts
```

### [meta](meta/)

This is a set of common metadata files for GitHub projects, such as
`.gitignore`, `dependabot.yml`, etc.

``` bash
nix flake init -t github:akirak/flake-templates#meta
```

## Editor integration

### Emacs

To turn on a LSP client and linters inside Emacs, a recommended way is
to set `.dir-locals`. I have the following configuration in my
`init.el`:

``` elisp
(let ((prettier '((eval . (prettier-on-save-mode t))))
      (lsp '((eval . (eglot-ensure))))
      (flymake-eslint '((eval . (flymake-eslint-enable)))))
  (dir-locals-set-class-variables
   'default
   `((web-mode . (,@prettier ,@lsp))
     (css-mode . (,@prettier ,@lsp))
     (svelte-mode . (,@prettier ,@lsp ,@flymake-eslint))
     (elixir-ts-mode . (,@lsp))
     (tsx-ts-mode . (,@prettier ,@lsp))
     (typescript-ts-mode . (,@prettier ,@lsp))
     (tuareg-mode . (,@lsp))
     (haskell-mode . (,@lsp)))))

;; Apply the settings to only relevant organizations
(dir-locals-set-directory-class "~/work/my-org/" 'default)
```

For details, see [elisp#Directory Local
Variables](info:elisp#Directory Local Variables) info manual.

Th above settings depend on the following packages:

- `eglot`, a LSP client for Emacs, which is built-in from Emacs 29
- [reformatter](https://github.com/purcell/emacs-reformatter) for
    defining a formatter. See [this comparison
    table](https://docs.google.com/document/d/1bIURUdHqlkF8QfFDnOP4ZOHXADkEtB_mbzMVoBQEBSw/edit)
    for alternatives
- [flymake-eslint](https://github.com/orzechowskid/flymake-eslint) for
    running eslint alongside the syntax checker provided by the running
    language server

`prettier-on-save-mode` become available when you define `prettier`
formatter using `reformatter` as follows:

``` elisp
(reformatter-define prettier
  :program "prettier"
  :args (list (concat "--plugin-search-dir="
                      (expand-file-name
                       (locate-dominating-file default-directory "package.json")))
              "--stdin-filepath" (buffer-file-name)))
```

Also see [nix3.el](https://github.com/emacs-twist/nix3.el), which
provides `nix3-flake-new` and `nix3-flake-init` commands for running a
flake template quickly from inside Emacs.

## Other template repositories and alternatives

The following is a list of template repositories I found on GitHub:

- [NixOS](https://github.com/nixos/templates)
- [serokell](https://github.com/serokell/templates)
- [johnae](https://github.com/johnae/nix-flake-templates)

[devenv](https://devenv.sh/) is a convenient tool that lets you set up a
Nix-based development environment quickly.

[nix-init](https://github.com/nix-community/nix-init) is a program that
interactively generates a Nix expression to build a project at a URL.

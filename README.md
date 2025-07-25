# Nix Flake Templates

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/akirak/flake-templates)

This is a collection of [Nix flake](https://nixos.wiki/wiki/Flakes) templates I
use in my personal projects. Each template basically provides a development
shell. Some additionally provide a formatter that can be used on CI. There is [a
companion website](https://akirak.github.io/flake-templates/), which provides
instructions for usage. Some templates also support building packages in pure
Nix.

I use these templates on NixOS, so they don't assume any non-Nix dependencies,
such as shared libraries on a specific Linux/Mac system. They should work on any
platform that supports Nix. Basically, each development shell contains:

- A programming language implementation (compiler and build system)
- A language server

Most modern programming languages provide a scaffolding command (e.g. `npm
create`, `cargo new`, etc.), so most of my templates should be used as a
complement. They also don't ship DevOps things (e.g. CI, non-default formatting
and linting, and other conformance-related settings) out of the box, as such
settings can be opinionated.

For maintaining a complex flake configuration, I would suggest use of
[flake-parts](https://github.com/hercules-ci/flake-parts/). Actually, I am using
flake-parts in some of these templates where it makes the configuration more
concise.
## List of templates in this repository

> [!IMPORTANT]
> I have built a web site which describes how to use these templates.
> Check out [the web site](https://akirak.github.io/flake-templates/)
> for detailed instructions.

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

### [flake-parts](flake-parts/flake.nix)

This is a boilerplate based on [flake-parts](https://flake.parts/).

``` bash
nix flake init -t github:akirak/flake-templates#flake-parts
```

It contains a stub for
[partitions](https://flake.parts/options/flake-parts-partitions) which is
commented out by default.

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

### [treefmt](treefmt/flake.nix)

Based on `minimal`, this boilerplate contains a configuration for
[treefmt-nix](https://github.com/numtide/treefmt-nix), so you can set up
formatters easily.

``` bash
nix flake init -t github:akirak/flake-templates#treefmt
```

Usage:

- You can run `nix fmt` to run formatters configured in `treefmt.nix` in the
  repository.
- You can run `nix flake check --print-build-logs` to check if all files are
  correctly formatted (useful on CI).

### [node-typescript](node-typescript/)

This is based on `minimal` but contains basic dependencies for web development
with Node.js and TypeScript. You can add it to your existing code base to start
coding without globally installing node. To scaffold a new project, you can use,
for example, [bolt.new](https://bolt.new/) and then develop the project on NixOS
after adding `flake.nix`:

``` bash
nix flake init -t github:akirak/flake-templates#node-typescript
```

It includes Node, TypeScript, and typescript-language-server as `buildInputs` of
the development shell. You can tweak these settings to suit your needs, e.g. to
use yarn or pnpm.

### [typescript-effect](typescript-effect/)

This is a more opinionated boilerplate than `node-typescript`. I have been using
[Effect](https://effect.website/) in my personal TypeScript projects recently,
and this template contains the common settings for those projects.

``` bash
nix flake init -t github:akirak/flake-templates#typescript-effect
```

Besides the basics in `node-typescript`, it contains:

- A basic `package.json` and `tsconfig.json` to let you create a CLI application
  quickly. If your framework initializes these files beforehand, they will not
  be added to your project. Yet this `package.json` integrates lefthook and
  lint-staged out of the box, so you can use it as a reference.
- An ESlint configuration based on
  [antfu/eslint-config](https://github.com/antfu/eslint-config), with specific
  rules disabled for nicely integrating with Effect.
- A GitHub Actions workflow with Nix cache enabled.
- Some stubs for easily adding Playwright executables.

### [ocaml-dune](ocaml-dune/)

This flake.nix lets you use [Dune](https://dune.build/) for your development
workflow but also allows to build your package using Nix.
It depends on [the overlay from
nix-ocaml](https://github.com/nix-ocaml/nix-overlays).

``` bash
nix flake init -t github:akirak/flake-templates#ocaml-dune
```

You will define your OCaml dependencies in `propagatedBuildInputs` of the dune
package in `flake.nix`. With the `direnv` integration, you don't have to
manually install packages using `opam` for development.

See also [the Nixpkgs
manual](https://nixos.org/manual/nixpkgs/unstable/#sec-language-ocaml) for
concrete information.

### [ocaml-basic](ocaml-basic/)

If you are trying to explore an existing OCaml code base, this template may be
helpful. It is easier to set up than `ocaml-dune` template, and it still
includes ocaml-lsp. You can use it whether your project uses dune or not:

``` bash
nix flake init -t github:akirak/flake-templates#ocaml-basic
```

### [python-uv-simple](python-uv-simple/)

This template contains a simple development environment for Python with
[uv](https://docs.astral.sh/uv/) as the package manager and
[BasedPyright](https://github.com/DetachHead/basedpyright) as the language
server. It is basic but sufficient for LSP, and can be effortlessly added to an
existing project:

``` bash
nix flake init -t github:akirak/flake-templates#python-uv-simple
```

### [rust](rust/)

This is a template for a simple Rust project with a single executable package.

``` bash
nix flake init -t github:akirak/flake-templates#rust
```

It depends on:

- [oxalica/rust-overlay](https://github.com/oxalica/rust-overlay).
- [crane](https://github.com/ipetkov/crane).
- flake-parts.
- [treefmt-nix](https://github.com/numtide/treefmt-nix)

It provides:

- `rust-analyzer` for a selected Rust toolchain.
- Auto-formatting of Rust and Nix code via `nix fmt`.

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

### [elixir-app](elixir-app/)

This is a more complex Nix boilerplate for Elixir. To use this flake, first
scaffold an application using `mix`, and then run the following command to add
`flake.nix`:

``` bash
nix flake init -t github:akirak/flake-templates#elixir-app
```

Features:

- It includes native dependencies for developing a Phoenix application such as
  node.js and a file watcher.
- It includes [Lexical](https://github.com/lexical-lsp/lexical) LSP server, but
  you can tweak the flake to use one of [the
  alternatives](https://gist.github.com/Nezteb/dc63f1d5ad9d88907dd103da2ca000b1).
- It uses [flake-parts](https://flake.parts/) to organize the flake outputs. It
  contains a boilerplate for
  [process-compose-flake](https://github.com/Platonic-Systems/process-compose-flake)
  to define background processes declaratively.

Note that I don't run Elixir applications in production, so I didn't take into
account real-world deployment scenarios of Erlang applications.

### [gleam](gleam/)

This flake provides minimal dependencies for [Gleam](https://gleam.run/).

``` bash
nix flake init -t github:akirak/flake-templates#gleam
```

### [go](go/)

This flake provides a development environment for [Go](https://go.dev/).

``` bash
nix flake init -t github:akirak/flake-templates#go
```

Note that creating a Go project may require some manual work. This template
helps you start working on an existing Go project on NixOS or adding a Nix-based
CI, but not much more.

### [zig](zig/)

This flake provides a minimal development environment for
[Zig](https://ziglang.org/).

``` bash
nix flake init -t github:akirak/flake-templates#zig
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

## License
This repository uses different licenses depending on the files. The specific
license applicable to a file or group of files is indicated in the file headers
or in the [LICENSES](LICENSES/) directory.

- The templates are released under the UNLICENSE.
  See [LICENSES/UNLICENSE](LICENSES/Unlicense.txt) for more details.
- The documentation is licensed under Attribution-ShareAlike 4.0 International
(CC-BY-SA-4.0).
- Some files are released under the MIT License.
## Contributing
See [CONTRIBUTING.md](./CONTRIBUTING.md).
## Other template repositories and alternatives

The following is a list of template repositories I found on GitHub:

- [NixOS](https://github.com/nixos/templates)
- [the-nix-way/dev-templates](https://github.com/the-nix-way/dev-templates): an
  extensive collection maintained by a developer behind Determinate Systems.
- [serokell](https://github.com/serokell/templates)
- [johnae](https://github.com/johnae/nix-flake-templates)

[devenv](https://devenv.sh/) is a convenient tool that lets you set up a
Nix-based development environment quickly.

[nix-init](https://github.com/nix-community/nix-init) is a program that
interactively generates a Nix expression to build a project at a URL.

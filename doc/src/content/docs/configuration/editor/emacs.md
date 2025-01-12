---
title: Emacs
description: How to set up Emacs for using Nix flakes.
---
## Direnv support
It is recommended to set up a direnv integration, so you can transparently
access programs provided from the development shell.

While there is no built-in direnv integration as of Emacs 30, there are a few
third-party packages for that. One option is
[envrc-mode](https://github.com/purcell/envrc) by Steve Purcell, which you can
install as `envrc` from [MELPA](https://melpa.org/#/).
## Other recommendations
These recommendations are not specific to Nix but are suggested to make you feel
productive when working with modern software development projects.
### LSP clients
- eglot (built-in)
- [lsp-mode](https://emacs-lsp.github.io/lsp-mode/)

Also, [lsp-booster](https://github.com/blahgeek/emacs-lsp-booster) is
recommended for users of both lsp-mode and eglot.

See [a corresponding awesome-emacs
section](https://github.com/emacs-tw/awesome-emacs?tab=readme-ov-file#lsp-client)
for other options.
### Formatters
- [reformatters](https://github.com/purcell/emacs-reformatter)
- [apheleia](https://github.com/radian-software/apheleia/)
### Compile frontend
See
[awesome-emacs](https://github.com/emacs-tw/awesome-emacs?tab=readme-ov-file#compiling).
## How to maintain project-specific settings
Emacs provides a way to keep per-project configuration that is `.dir-locals.el`.
It is also possible to apply common settings to a set of directories using
`dir-locals-set-class-variables` and `dir-locals-set-directory-class`.
See the Emacs Manual for details.

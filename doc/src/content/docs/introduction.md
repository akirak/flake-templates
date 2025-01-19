---
# SPDX-FileCopyrightText: 2024-2025 Akira Komamura
# SPDX-License-Identifier: CC-BY-SA-4.0
title: Introduction to Flake Templates
---
Hello, this site provides instructions for setting up a development environment
using Nix flake templates.

With Nix, it is easy to create a cross-platform reproducible environment. Nix
supports multiple platforms including Mac and Linux. Nixpkgs, the package
collection of Nix, is the largest on earth. Nix-based development environments
are more lightweight than using container-based solutions such as Docker.

My [flake templates](https://github.com/akirak/flake-templates) provides a
collection of templates for creating a basic environment for developing with
Nix. This documentation explains how to use it.
## Target audience
This documentation site assumes the reader is

- Using Linux or Mac. If you are using Windows, you will need WSL 2 or a virtual
  machine running Linux. This site doesn't explain how to set up the underlying
  environment.
- Proficient with command-line.

## Overview of this documentation
If you don't know how to develop projects with Nix flakes, first read [Getting
started](/flake-templates/getting-started).

If you have some experiences in development with Nix, you may navigate directly
to the relevant sections:

- The Configuration section provides guides for configuring your editor for
  development with Nix flakes.
- The Recipes section offers step-by-step instructions for initializing a new
  flake using one of the available templates.
- The Patterns section outlines methods for extending your flake to accommodate
  additional project requirements.

Select a section on the sidebar of this web site.

# AGENT.md

This file provides guidance to coding agents when working with code in this repository.

## Repository Overview

This is a collection of Nix flake templates for various programming languages and development scenarios. Each template provides a development shell with language-specific tooling and optionally formatters, linters, and build configurations.

## Architecture

- **Root flake.nix**: Defines all available templates with their paths and descriptions
- **Template directories**: Each subdirectory contains a complete flake.nix for a specific use case
- **Documentation site**: Located in `/doc`, built with Astro and Starlight
- **Development utilities**: Located in `/dev`, contains maintenance tools

### Template Categories

1. **Minimal templates**: `minimal`, `flake-utils`, `flake-parts` - Basic boilerplates
2. **Language-specific**: `rust`, `go`, `python-uv-simple`, `elixir`, `gleam`, `zig`, etc.
3. **Web development**: `node-typescript`, `typescript-effect`
4. **OCaml**: `ocaml-basic`, `ocaml-dune`
5. **Tooling**: `pre-commit`, `treefmt` - Development workflow tools
6. **Metadata**: `meta` - GitHub project files

## Common Development Commands

### Documentation Site (in `/doc`)
```bash
# Install dependencies
pnpm install

# Development server
pnpm dev

# Build site
pnpm build

# Type check
astro check
```

### Code Formatting
```bash
# Format Nix files (repository-wide)
nix fmt

# Format using treefmt configuration
treefmt
```

### Flake Operations
```bash
# Test all templates
nix flake check

# Initialize a project with a template
nix flake init -t github:akirak/flake-templates#<template-name>

# List all available templates
nix flake show
```

### Development Environment
```bash
# Enter development shell
nix develop

# For documentation work
cd doc && nix develop
```

## Key Design Principles

- Templates assume no non-Nix dependencies (work on any Nix-supported platform)
- Each template provides minimal viable development environment
- Language servers and formatters included where applicable
- Templates complement language scaffolding tools rather than replace them
- flake-parts used where it makes configuration more concise

## Template Structure Patterns

Most templates follow this pattern:
- `flake.nix`: Main flake configuration
- Language-specific config files (e.g., `treefmt.nix`, `tsconfig.json`)
- Optional: justfile, package.json, or other build configuration

## Special Templates

- **typescript-effect**: Opinionated setup with Effect-TS, ESLint, lefthook
- **elixir-app**: Complex setup with Phoenix dependencies, process-compose integration
- **ocaml-dune**: Integrates with nix-ocaml overlay for package building
- **rust**: Uses crane and rust-overlay for deterministic builds
- **treefmt**: Demonstrates formatter configuration patterns

## Testing Templates

When modifying templates, test them by:
1. Initialize in a temporary directory: `nix flake init -t .#<template>`
2. Enter development shell: `nix develop`
3. Verify language tools are available
4. Run any included formatters/linters

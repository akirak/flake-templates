# SPDX-FileCopyrightText: 2021-2025 Akira Komamura
# SPDX-License-Identifier: MIT
{
  description = "A collection of project templates";

  outputs =
    { ... }:
    {
      templates = {
        meta = {
          path = ./meta;
          description = "Miscellaneous files for GitHub projects";
        };
        minimal = {
          path = ./minimal;
          description = "Minimal boilerplate with nix-systems";
        };
        flake-utils = {
          path = ./flake-utils;
          description = "A basic boilerplate with flake-utils";
        };
        flake-parts = {
          path = ./flake-parts;
          description = "A minimal boilerplate for the root flake";
        };
        pre-commit = {
          path = ./pre-commit;
          description = "Basic flake with pre-commit check";
        };
        treefmt = {
          path = ./treefmt;
          description = "Basic flake with a treefmt integration";
        };
        node-typescript = {
          path = ./node-typescript;
          description = "Toolchain for TypeScript frontend projects";
        };
        go = {
          path = ./go;
          description = "A minimal environment for Go with support for Go module";
        };
        ocaml-basic = {
          path = ./ocaml-basic;
          description = "A flake template for exploring OCaml code base";
        };
        ocaml-dune = {
          path = ./ocaml-dune;
          description = "A flake template for development with OPAM and Dune";
        };
        rust = {
          path = ./rust;
          description = "Rust toolchain";
        };
        elixir = {
          path = ./elixir;
          description = "Simple Elixir project";
        };
        elixir-app = {
          path = ./elixir-app;
          description = "A boilerplate for Elixir (Phoenix) application";
        };
        gleam = {
          path = ./gleam;
          description = "A minimal Gleam project";
        };
        zig = {
          path = ./zig;
          description = "A minimal Zig project";
        };
      };
    };
}

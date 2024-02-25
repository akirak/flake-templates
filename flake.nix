{
  description = "A collection of project templates";

  outputs = {...}: {
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
      bun = {
        path = ./bun;
        description = "Web development with Bun and Biome";
      };
      rust = {
        path = ./rust;
        description = "Rust toolchain";
      };
      pulumi-ts = {
        path = ./pulumi-ts;
        description = "Pulumi project in TypeScript";
      };
      elixir = {
        path = ./elixir;
        description = "Simple Elixir project";
      };
      elixir-phoenix = {
        path = ./elixir-phoenix;
        description = "Elixir Phoenix project where you use Mix";
      };
    };
  };
}

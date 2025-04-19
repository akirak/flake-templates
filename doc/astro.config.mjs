// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";
import catppuccinTheme from "starlight-theme-catppuccin";
import markdoc from "@astrojs/markdoc";

// https://astro.build/config
export default defineConfig({
  site: "https://akirak.github.io/flake-templates/",
  base: "/flake-templates/",
  integrations: [
    markdoc(),
    starlight({
      title: "Nix Flake Templates",
      plugins: [catppuccinTheme()],
      social: [
        {
          icon: "github",
          label: "GitHub",
          href:  "https://github.com/akirak/flake-templates",
        }
      ],
      sidebar: [
        {
          label: "Introduction",
          slug: "introduction",
        },
        {
          label: "Getting started",
          slug: "getting-started",
        },
        {
          label: "Configuration",
          items: [
            { label: "Nix Direnv", slug: "configuration/nix-direnv" },
            {
              label: "Editor support",
              items: [{ label: "Emacs", slug: "configuration/editor/emacs" }],
            },
          ],
        },
        {
          label: "Recipes",
          // Sort these items alphabetically by the language name
          items: [
            {
              label: "Elixir",
              items: [
                {
                  label: "Elixir Phoenix application",
                  slug: "recipes/elixir/phoenix",
                },
              ],
            },
            {
              label: "Gleam",
              items: [{ label: "Gleam application", slug: "recipes/gleam/app" }],
            },
            {
              label: "Go",
              items: [{ label: "Go executable", slug: "recipes/go/executable" }],
            },
            {
              label: "OCaml",
              items: [
                { label: "Generic Dune project", slug: "recipes/ocaml/generic-dune" },
                { label: "Basic", slug: "recipes/ocaml/basic" },
              ],
            },
            {
              label: "Python",
              items: [{ label: "Uv (basic)", slug: "recipes/python/uv-basic" }],
            },
            {
              label: "Rust",
              items: [{ label: "Rust executable", slug: "recipes/rust/executable" }],
            },
            {
              label: "TypeScript",
              items: [
                {
                  label: "TypeScript web application (with a framework)",
                  slug: "recipes/typescript/web-framework",
                },
              ],
            },
            {
              label: "Zig",
              items: [{ label: "Zig CLI application", slug: "recipes/zig/cli" }],
            },
          ],
        },
        {
          label: "Patterns",
          items: [
            {
              label: "Continuous Integration",
              items: [
                {
                  label: "GitHub Actions",
                  slug: "patterns/ci/github-actions",
                },
              ],
            },
            {
              label: "Formatting",
              items: [
                {
                  label: "treefmt-nix",
                  slug: "patterns/formatting/treefmt-nix",
                },
              ],
            },
            {
              label: "Updating dependencies",
              items: [
                {
                  label: "Renovate Bot",
                  slug: "patterns/updating/renovate",
                },
              ],
            },
            {
              label: "Using nix-systems",
              slug: "patterns/nix-systems",
            },
          ],
        },
        {
          label: "Resources",
          slug: "resources",
        },
      ],
    }),
  ],
});

Update `elixir/flake.nix` and `elixir-app/flake.nix` so their
`erlangVersion` and `elixirVersion` bindings track the latest
versions available from `nixpkgs`.

Requirements:
- Use Nix commands to inspect `nixpkgs`; do not guess.
- Determine the newest `beam.interpreters.erlang_<major>` attribute.
- Determine the newest `beam.packages.<erlang>.elixir_<major>_<minor>`
  attribute for that Erlang package set.
- Update only those version strings in the two flake files.
- If there is a diff, write a unified patch file to
  `generated-patches/elixir-version-updates.patch`.
- If there is no diff, leave `generated-patches/` without any `.patch`
  files.
- Do not commit changes.

Recommended workflow:
1. Use `nix eval --json nixpkgs#legacyPackages.x86_64-linux.beam.interpreters`
   and `nix eval --json nixpkgs#legacyPackages.x86_64-linux.beam.packages.<erlang>`
   to inspect available attributes.
2. Update the files in place.
3. If `git diff -- elixir/flake.nix elixir-app/flake.nix` is non-empty,
   save it as `generated-patches/elixir-version-updates.patch`.

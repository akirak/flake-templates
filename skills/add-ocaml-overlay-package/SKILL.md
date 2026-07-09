---
name: add-ocaml-overlay-package
description: Add or update an OCaml package in this repository's Nix flake overlay and verify it through Hydra job attributes. Use when Codex needs to package an upstream OCaml library, wire it into ocaml/default.nix or related overlay files, handle fetchFromGitHub/fixed-output hashes, respect OCaml version constraints, and prove targets such as hydraJobs.<system>.build_5_5.<package> build cleanly.
---

# Add OCaml Overlay Package

Use this skill for [nix-ocaml/nix-overlays](https://github.com/nix-ocaml/nix-overlays)'s OCaml overlay packaging workflow.

## Workflow

1. Inspect the current tree before editing:
   - `git status --short`
   - `rg -n "<package>|build_5_5|ocamlPackages" .`
   - Read `ocaml/default.nix`, `ocaml/overlay-ocaml-packages.nix`, `ci/filter.nix`, and `ci/hydra.nix` around relevant entries.

2. Determine upstream package metadata:
   - Prefer upstream `*.opam`, `dune-project`, tags, and release tarballs.
   - For GitHub packages, confirm tag names with `git ls-remote --tags https://github.com/<owner>/<repo>.git`.
   - Map opam dependencies into `propagatedBuildInputs` for runtime/library dependencies and `checkInputs` only if tests are intentionally enabled.

3. Add the package in `ocaml/default.nix`:
   - Use `buildDunePackage` for dune packages.
   - Guard incompatible OCaml versions with `if lib.versionAtLeast ocaml.version "<min>" then ... else null`.
   - Use `fetchFromGitHub` when packaging GitHub sources.
   - Set `pname`, `version`, `src`, dependencies, and concise `meta`.
   - Keep ordering and style consistent with nearby entries.

4. Resolve source hashes through Nix:
   - Start with a placeholder hash such as `sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=`.
   - Run the targeted Nix build or eval and replace the placeholder with the reported hash mismatch `got:` value.
   - Do not claim success until the build is rerun with the real hash.

5. Verify the requested Hydra target:
   - Prefer exact job builds, for example:
     `env XDG_CACHE_HOME=/tmp/codex-nix-cache NIX_REMOTE=daemon nix build .#hydraJobs.x86_64-linux.build_5_5.<package> --no-link`
   - If sandboxed Nix cannot access the daemon or network, rerun with escalation rather than weakening verification.
   - Confirm exposure with `nix eval .#hydraJobs.x86_64-linux.build_5_5.<package>.pname --raw` and, when useful, `.version --raw`.

## Repository Notes

- `build_5_5` is defined in `ci/hydra.nix` via `ocamlCandidates`.
- `ocamlCandidates` in `ci/filter.nix` filters derivations from `pkgs.ocaml-ng.ocamlPackages_5_5`; packages exposed as non-broken derivations are candidates automatically.
- `format.sh` may reference missing legacy tooling. If repository formatting tools are unavailable, avoid broad formatting rewrites and keep the edited Nix style local and consistent.

## Completion Criteria

Treat the task as complete only when:

- The package is present in the appropriate OCaml package scope.
- The target requested by the user, such as `build_5_5.<package>`, evaluates to the expected package.
- The exact targeted Nix build exits successfully.
- The final diff is limited to aligned packaging changes and does not revert unrelated user work.

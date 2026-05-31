---
name: init-dependabot
description: Use when the user wants to initialize Dependabot in a repository. Copy the bundled `assets/dependabot.yml` and `assets/auto-merge-dependabot.yml` into `.github`, keep only the package ecosystems and directories that actually exist in the repository, choose the appropriate Nix update strategy for each flake, adapt the auto-merge workflow to the repository's update command, refresh pinned action SHAs, validate with zizmor, and remind the user to create the required GitHub App secrets manually.
metadata:
  short-description: Initialize Dependabot for a repository
---

# Init Dependabot

Set up Dependabot by copying the bundled templates from `assets/`, tailoring them to the target repository, and leaving the workflow in a state that passes `zizmor`.

## Workflow

1. Inspect the repository before copying anything.
   - Find package manifests, lock files, flake files, and existing GitHub workflows.
   - Do not assume the repository root is the only relevant directory. If manifests live in subdirectories, target those directories in the generated Dependabot config.

2. Install `.github/dependabot.yml`.
   - Create `.github` if it does not exist.
   - Start from `assets/dependabot.yml`.
   - Keep only ecosystems that are actually used by the repository.
   - Remove `npm` when there is no Node package manifest in the target directory.
   - Keep `github-actions` when the repository already has workflows or when you are adding the auto-merge workflow in the same change.
   - For repositories with multiple manifest directories, add multiple update entries instead of forcing everything to `/`.

3. Choose the Nix configuration deliberately.
   - Remove `nix` entirely when the repository has no `flake.nix` or `flake.lock`.
   - If a flake directory should only receive automated `nixpkgs` updates, keep the weekly `allow: nixpkgs` configuration from the template.
   - If a flake directory has multiple important inputs that need review, switch to the alternative manual-review configuration from the template and avoid auto-merging those PRs.
   - If the repository has more than one flake directory, add one `nix` update entry per directory and choose the mode separately for each directory.

4. Install `.github/workflows/auto-merge-dependabot.yml`.
   - Create `.github/workflows` if needed.
   - Start from `assets/auto-merge-dependabot.yml`.
   - Keep the safer default `pull_request` trigger unless the repository has a concrete reason to use `pull_request_target`.
   - If the repository does not need to regenerate a derived file or lock artifact, remove the `update` job and also remove `needs: update` from `merge`.
   - If the repository does need an update job, replace the placeholder update command, the files added to Git, and the commit message with repository-specific values.
   - Keep the Nix installation step only when the update command actually needs Nix.
   - Keep the GitHub App secret names as `CREATE_PR_APP_ID` and `CREATE_PR_APP_PRIVATE_KEY`.

5. Refresh action pins when you touch the workflow.
   - Update each `uses:` line to a current immutable revision hash and keep the version comment in sync.
   - Prefer the upstream release or tag page for the authoritative hash.

6. Validate with `zizmor`.
   - Run `zizmor .github/workflows/auto-merge-dependabot.yml`.
   - Address high-severity findings before finishing.
   - If a warning is intentionally kept, explain why it is acceptable for this repository.

7. Finish with the manual step.
   - Tell the user to create a GitHub App manually and add the `CREATE_PR_APP_ID` and `CREATE_PR_APP_PRIVATE_KEY` secrets.
   - Do not imply that this part was automated.

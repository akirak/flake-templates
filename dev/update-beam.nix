/*
  This script helps the user keep Erlang (erlangRxx) and Elixir (elixir_x_xx)
  to their latest versions. It performs simple regexp substitutions in flake.nix.

  SPDX-FileCopyrightText: 2022-2025 Akira Komamura
  SPDX-License-Identifier: MIT
*/
{
  lib,
  beam,
  writeText,
  writeShellScript,
}:
let
  inherit (builtins)
    attrNames
    filter
    match
    sort
    head
    compareVersions
    ;

  latestPackageMatching =
    pattern: attrs:
    lib.pipe attrs [
      (lib.filterAttrs (name: _: match pattern name != null))
      (lib.mapAttrsToList (
        name: value: {
          inherit name;
          inherit (value) version;
        }
      ))
      (sort (a: b: compareVersions a.version b.version > 0))
      (elems: builtins.elemAt elems 1)
      (x: x.name)
    ];

  erlangRegex = "erlang_[[:digit:]]+";

  latestErlang = latestPackageMatching erlangRegex beam.interpreters;

  elixirRegex = "elixir_[[:digit:]]_[[:digit:]]+";

  latestElixir = latestPackageMatching elixirRegex beam.packages.${latestErlang};

  sed = writeText "update.sed" ''
    s/${erlangRegex}/${latestErlang}/
    s/${elixirRegex}/${latestElixir}/
  '';
in
writeShellScript "update-beam" ''
  git add .
  find -name flake.nix | xargs sed -i -r -f ${sed}

  if git diff --exit-code
  then
    exit 1
  else
    git add .
  fi
''

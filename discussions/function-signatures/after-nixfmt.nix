[
  # Short that was single-line
  ({ nixpkgs, ... }@attrs: nixpkgs)

  # Short that was multi-line
  ({ nixpkgs, ... }@attrs: nixpkgs)

  # Long that was single-line
  (attrs@{ stdenv, lib, gcc, coreutils, gnufind, gnugrep, gnumake, gnutar, gnupg
    , gnused, gnuk, gnubg, ... }:
    stdenv)

  # Long that was multi-line
  (attrs@{ stdenv, lib, gcc, coreutils, gnufind, gnugrep, gnumake, gnutar, gnupg
    , gnused, gnuk, gnubg, ... }:
    stdenv)
]

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    alejandra.url = "github:kamadorueda/alejandra";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
    nixfmt.url = "github:serokell/nixfmt";
    nixfmt.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgsFmt.url = "github:nix-community/nixpkgs-fmt";
    nixpkgsFmt.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, ...} @ inputs: let
    system = "x86_64-linux";

    alejandra = inputs.alejandra.outputs.defaultPackage.${system};
    nixfmt = inputs.nixfmt.outputs.defaultPackage.${system};
    nixpkgsFmt = inputs.nixpkgsFmt.outputs.defaultPackage.${system};
    nixpkgs = import inputs.nixpkgs {inherit system;};
  in {
    devShell.${system} = nixpkgs.mkShell {
      buildInputs = [alejandra nixfmt nixpkgsFmt];
    };

    apps.${system} = {
      format = {
        type = "app";
        program =
          (nixpkgs.writeShellScript "format.sh" ''
            cp -rLT --no-preserve=mode,ownership \
              ${self.packages.${system}.allFormatted} .
          '')
          .outPath;
      };

      repl = {
        type = "app";
        program =
          (nixpkgs.writeShellScript "repl.sh" ''
            echo repl.nix | ${nixpkgs.entr}/bin/entr bash -c '
              clear;
              for fmt in ${alejandra}/bin/* ${nixfmt}/bin/* ${nixpkgsFmt}/bin/*; do
                echo $ $(basename $fmt)
                ($fmt < repl.nix 2>/dev/null || echo error) \
                  | ${nixpkgs.bat}/bin/bat --language nix --style numbers
                echo
              done
            '
          '')
          .outPath;
      };
    };

    packages.${system}.allFormatted = nixpkgs.stdenv.mkDerivation {
      name = "formatted";
      src = ./.;

      buildInputs = [alejandra nixfmt nixpkgsFmt nixpkgs.git];

      builder = builtins.toFile "builder.sh" ''
        source $stdenv/setup

        mkdir $out
        cd $out
        cp -rLT --no-preserve=mode,ownership $src/ .

        find -L $out -type f -name before.nix | while read -r file; do
          echo $file

          dirname=$(realpath --relative-to=$out $(dirname $file))
          mkdir -p $dirname
          diff='git diff --ignore-blank-lines --ignore-space-at-eol --minimal --no-index --unified=1'

          for fmt in alejandra nixfmt nixpkgs-fmt; do
            ($fmt < $file 2>/dev/null || echo error) \
              > $dirname/after-$fmt.nix
            ($diff $dirname/before.nix $dirname/after-$fmt.nix || true) \
              > $dirname/diff-$fmt.diff
          done

          for fmt in alejandra nixfmt nixpkgs-fmt; do
            for fmt2 in alejandra nixfmt nixpkgs-fmt; do
              if test $fmt != $fmt2; then
                ($diff $dirname/after-$fmt.nix $dirname/after-$fmt2.nix || true) \
                  > $dirname/from-$fmt-to-$fmt2.diff
              fi
            done
          done
        done
      '';
    };
  };
}

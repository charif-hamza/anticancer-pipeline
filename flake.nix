{
  description = "Reproducible anticancer QSAR pipeline";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        pyPkgs = pkgs.python312Packages;
      in {
        devShells.default = pkgs.mkShell {
          name = "anticancer-dev";
          buildInputs = with pyPkgs; [
            ipython
            pandas
            rdkit
            scikit-learn
            typer
            pytest
            pip
          ];
          shellHook = ''
            export PYTHONPATH=$PWD/src:$PYTHONPATH
            echo "🧪  anticancer-dev shell ready"
          '';
        };
      });
}


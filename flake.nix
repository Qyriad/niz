{
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        niz = pkgs.callPackage ./niz.nix { };

      in {

        packages.default = niz;

        devShells.default = pkgs.mkShell {

          inputsFrom = [
            niz
          ];

          packages = [
            pkgs.pyright
          ];

        };

      }
    ) # eachDefaultSystem
  ; # outputs
}

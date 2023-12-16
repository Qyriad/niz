{
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (builtins) attrValues;

        niz =
          let
            pname = "niz";
            version = "0.0.1";
          in
            pkgs.python3Packages.buildPythonPackage {
              inherit pname version;

              format = "pyproject";
              src = ./.;

              nativeBuildInputs = attrValues {
                inherit (pkgs.python3Packages)
                  setuptools
                  wheel
                ;
              };
          }
        ;

      in {

        packages.default = niz;
        packages.niz = niz;

        devShells.default = pkgs.mkShell {

          inputsFrom = [ niz ];

          packages = attrValues {
            inherit (pkgs)
              pyright
            ;
          };

        };

      }
    ) # eachDefaultSystem
  ; # outputs
}

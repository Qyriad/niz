{
  lib,
  python3Packages,
}:

  let
    inherit (python3Packages)
      setuptools
      wheel
    ;
  in
    python3Packages.buildPythonApplication {
      pname = "niz";
      version = "0.0.1";

      src = lib.cleanSource ./.;
      format = "pyproject";

      nativeBuildInputs = [
        setuptools
        wheel
      ];
    }

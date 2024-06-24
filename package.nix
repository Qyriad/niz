{
  lib,
  python3Packages,
}: let
  inherit (python3Packages) buildPythonApplication setuptools wheel;
in buildPythonApplication {
  pname = "niz";
  version = "0.0.1";

  src = lib.cleanSource ./.;
  format = "pyproject";

  nativeBuildInputs = [
    setuptools
    wheel
  ];
}

{
  lib,
  python3,
}: let
  inherit (python3.pkgs) buildPythonApplication setuptools wheel
  ;
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

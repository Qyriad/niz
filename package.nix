{
  lib,
  buildPythonApplication,
  setuptools,
  wheel,
}: buildPythonApplication {
  pname = "niz";
  version = "0.0.1";

  src = lib.cleanSource ./.;
  format = "pyproject";

  nativeBuildInputs = [
    setuptools
    wheel
  ];
}

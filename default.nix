{
  pkgs ? import <nixpkgs> { },
  python3Packages ? pkgs.python3Packages,
  qpkgs ? let
    src = fetchTarball "https://github.com/Qyriad/nur-packages/archive/main.tar.gz";
  in import src { inherit pkgs; },
}: let
  inherit (pkgs) lib;

  niz = python3Packages.callPackage ./package.nix { };

  overrideCall = scope: scope.callPackage niz.override { };
  notDisabled = p: !((p.meta or { }).disabled or false);

  byPythonVersion = qpkgs.pythonScopes
  |> lib.mapAttrs (lib.const overrideCall)
  |> lib.filterAttrs (lib.const notDisabled);

in niz.overrideAttrs (prev: {
  passthru = prev.passthru or { } // {
    inherit byPythonVersion;
  };
})

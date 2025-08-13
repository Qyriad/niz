{
  pkgs ? import <nixpkgs> { },
  python3Packages ? pkgs.python3Packages,
  qpkgs ? let
    src = fetchTree <| builtins.parseFlakeRef "github:Qyriad/nur-packages";
  in import src { inherit pkgs; },
}: let
  inherit (pkgs) lib;

  niz = python3Packages.callPackage ./package.nix { };

  overrideCall = scope: scope.callPackage niz.override { };
  # nb: the parentheses here are unnecessary but it looks fucking weird.
  notDisabled = p: !(p.meta.disabled or false);

  byPythonVersion = qpkgs.pythonScopes
  |> lib.mapAttrs (lib.const overrideCall)
  |> lib.filterAttrs (lib.const notDisabled);

in niz.overrideAttrs (prev: {
  passthru = prev.passthru or { } // {
    inherit byPythonVersion;
  };
})

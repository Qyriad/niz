{
  pkgs ? import <nixpkgs> { },
}:
  pkgs.callPackage ./niz.nix { }

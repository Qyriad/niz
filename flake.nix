{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils
  }: flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };

    niz = pkgs.callPackage ./package.nix { };

  in {
    packages = {
      default = niz;
      inherit niz;
    };

    devShells.default = pkgs.mkShell {
      inputsFrom = [ niz ];
      packages = [ pkgs.pyright ];
    };
  }) ; # outputs
}

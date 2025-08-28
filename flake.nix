{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    qyriad-nur = {
      url = "github:Qyriad/nur-packages";
      flake = false;
    };
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    qyriad-nur,
  }: flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };
    qpkgs = import qyriad-nur { inherit pkgs; };

    niz = import ./default.nix { inherit pkgs qpkgs; };

  in {
    packages = {
      default = niz;
      inherit niz;
    };

    devShells.default = pkgs.mkShell {
      inputsFrom = [ niz ];
      packages = [ pkgs.pyright ];
    };

    checks = niz.byPythonVersion;
  }); # outputs
}

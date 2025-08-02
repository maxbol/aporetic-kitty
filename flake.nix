{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/?rev=8309e9e8d6106d18a7f00953faf835afa3318573";
    };
    flake-utils = {
      url = "github:numtide/flake-utils/?rev=11707dc2f618dd54ca8739b309ec4fc024de578b";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
      tag = "1.1.0";
      version = "${tag}-kitty";
      sets = import ./sets.nix;
      makeIosevkaFont = pkgs.callPackage ./make-iosevka-font.nix {};
      makeAllIosevkaFonts = pkgs.callPackage ./default.nix {};
    in {
      packages =
        builtins.foldl' (
          acc: setName:
            acc
            // {
              "aporetic-kitty-${setName}" = makeIosevkaFont version setName;
            }
        )
        rec {
          default = makeAllIosevkaFonts {inherit tag version;};
          aporetic-kitty = default;
        }
        sets;
    });
}

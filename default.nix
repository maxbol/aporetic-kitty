{
  pkgs,
  lib,
  iosevka,
  fetchFromGitHub,
  symlinkJoin,
  ...
}: {
  tag,
  version ? "${tag}-kitty",
}: let
  sets = [
    "sans-mono"
    "sans"
    "serif-mono"
    "serif"
  ];
  pname = "aporetic";
  src = fetchFromGitHub {
    inherit tag;
    owner = "protesilaos";
    repo = "aporetic";
    hash = "sha256-5lPViAo9SztOdds6HEmKJpT17tgcxmU/voXDffxTMDI=";
  };
  makeIosevkaFont = pkgs.callPackage ./make-iosevka-font.nix {};
in
  symlinkJoin {
    inherit pname version;

    paths = builtins.map (makeIosevkaFont version) sets;

    meta = {
      inherit (src.meta) homepage;
      description = ''
        Custom build of Iosevka with different style and metrics than the default, successor to my "Iosevka Comfy" fonts
      '';
      license = lib.licenses.ofl;
      platforms = iosevka.meta.platforms;
      maintainers = [lib.maintainers.DamienCassou];
    };
  }

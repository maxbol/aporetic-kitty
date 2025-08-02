{
  buildNpmPackage,
  iosevka,
  fetchFromGitHub,
  ...
}: version: set: let
  superBuildNpmPackage = buildNpmPackage;
  privateBuildPlan = "${./private-build-plans.toml}";
in (iosevka.override {
  inherit set privateBuildPlan;
  buildNpmPackage = args:
    superBuildNpmPackage (
      args
      // {
        pname = "aporetic-${set}";
        inherit version;

        src = fetchFromGitHub {
          owner = "be5invis";
          repo = "iosevka";
          rev = "v32.5.0";
          hash = "sha256-MzsAkq5l4TP19UJNPW/8hvIqsJd94pADrrv8wLG6NMQ=";
        };

        npmDepsHash = "sha256-HeqwpZyHLHdMhd/UfXVBonMu+PhStrLCxAMuP/KuTT8=";
      }
    );
})

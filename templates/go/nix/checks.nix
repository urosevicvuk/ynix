{lib, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    package = config.packages.default;

    check = name: nativeBuildInputs: command:
      package.overrideAttrs (old: {
        name = "${old.pname}-${name}";
        nativeBuildInputs = old.nativeBuildInputs ++ nativeBuildInputs;
        buildPhase = ''
          runHook preBuild
          ${command}
          runHook postBuild
        '';
        doCheck = false;
        installPhase = "touch $out";
        dontFixup = true;
      });
  in {
    checks = lib.mkIf (config.packages ? default) {
      build = package;

      lint = check "lint" [pkgs.golangci-lint] ''
        export HOME=$TMPDIR GOLANGCI_LINT_CACHE=$TMPDIR/golangci-lint
        golangci-lint run
      '';

      tidy = check "tidy" [] ''
        go mod tidy -diff
      '';
    };
  };
}

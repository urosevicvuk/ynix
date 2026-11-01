# What `nix flake check` and nixbot verify, besides formatting (treefmt) and
# the devshell. Each check is a derivation that builds in the sandbox from the
# same locked inputs, so a pass here is a pass in CI and the other way round.
{lib, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    package = config.packages.default;

    # Reuses the package's source and fetched modules, swaps the build for
    # `command`, and produces an empty output: only success matters.
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
    # Only once nix/package.nix defines the package, i.e. after `go mod init`.
    checks = lib.mkIf (config.packages ? default) {
      # Compiles the binaries and runs `go test ./...`.
      build = package;

      lint = check "lint" [pkgs.golangci-lint] ''
        export HOME=$TMPDIR GOLANGCI_LINT_CACHE=$TMPDIR/golangci-lint
        golangci-lint run
      '';

      # go.mod and go.sum list exactly what the code imports.
      tidy = check "tidy" [] ''
        go mod tidy -diff
      '';
    };
  };
}

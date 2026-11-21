{lib, ...}: {
  perSystem = {
    config,
    pkgs,
    uv2nix,
    ...
  }: let
    inherit (uv2nix) python workspace pythonSet name;

    src = lib.fileset.toSource {
      root = ../.;
      fileset = lib.fileset.difference ../. (lib.fileset.unions [
        ../nix
        ../flake.nix
        (lib.fileset.maybeMissing ../flake.lock)
        (lib.fileset.maybeMissing ../.github)
      ]);
    };

    check = check: inputs: command:
      pkgs.runCommand "${name}-${check}" {nativeBuildInputs = inputs;} ''
        cp -r ${src}/. . && chmod -R u+w .
        export HOME=$TMPDIR
        ${command}
        touch $out
      '';

    hasPytest =
      builtins.pathExists ../uv.lock
      && lib.any (p: p.name == "pytest") (lib.importTOML ../uv.lock).package;
  in {
    checks = lib.mkIf (config.packages ? default) ({
        build = config.packages.default;

        lock = check "lock" [pkgs.uv] ''
          unset SSL_CERT_FILE
          export UV_PYTHON=${python.interpreter} UV_PYTHON_DOWNLOADS=never UV_OFFLINE=1
          uv lock --check || {
            echo "uv.lock doesn't match pyproject.toml: run \`uv lock\` and commit it." >&2
            exit 1
          }
        '';
      }
      // lib.optionalAttrs hasPytest {
        test = check "test" [(pythonSet.mkVirtualEnv "${name}-test-env" workspace.deps.all)] ''
          pytest -p no:cacheprovider
        '';
      });
  };
}

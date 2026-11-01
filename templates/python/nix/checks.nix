# What `nix flake check` and nixbot verify, besides formatting and ruff lints
# (treefmt) and the devshell. Each check is a derivation that builds in the
# sandbox from the same locked inputs, so a pass here is a pass in CI and the
# other way round.
{lib, ...}: {
  perSystem = {
    config,
    pkgs,
    uv2nix,
    ...
  }: let
    inherit (uv2nix) python workspace pythonSet name;

    # Everything git tracks except the Nix and CI files.
    src = lib.fileset.toSource {
      root = ../.;
      fileset = lib.fileset.difference ../. (lib.fileset.unions [
        ../nix
        ../flake.nix
        (lib.fileset.maybeMissing ../flake.lock)
        (lib.fileset.maybeMissing ../.github)
      ]);
    };

    # Runs `command` in a writable copy of the source, with `inputs` on PATH,
    # and produces an empty output: only success matters.
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
    # Only once nix/package.nix defines the package, i.e. after `uv lock`.
    checks = lib.mkIf (config.packages ? default) ({
        build = config.packages.default;

        # uv.lock matches pyproject.toml. Checked offline, against the lock
        # alone, so it never resolves anything new.
        lock = check "lock" [pkgs.uv] ''
          unset SSL_CERT_FILE # set to a dummy by the sandbox, and nothing is fetched
          export UV_PYTHON=${python.interpreter} UV_PYTHON_DOWNLOADS=never UV_OFFLINE=1
          uv lock --check || {
            echo "uv.lock doesn't match pyproject.toml: run \`uv lock\` and commit it." >&2
            exit 1
          }
        '';
      }
      # Once pytest is a dependency: `uv add --dev pytest`.
      // lib.optionalAttrs hasPytest {
        test = check "test" [(pythonSet.mkVirtualEnv "${name}-test-env" workspace.deps.all)] ''
          pytest -p no:cacheprovider
        '';
      });
  };
}

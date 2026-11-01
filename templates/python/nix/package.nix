# The project built by Nix, with uv2nix: `nix build` produces a virtualenv
# with the project and its dependencies in ./result, scripts in
# ./result/bin. Every package comes from uv.lock, hashes included, so there's
# nothing to maintain here. Nothing is built until uv.lock exists (`uv lock`),
# so the template also evaluates before there's a project in it.
{
  inputs,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}: let
    # The one interpreter, for the devshell and the build alike.
    python = pkgs.python313;

    workspace = inputs.uv2nix.lib.workspace.loadWorkspace {workspaceRoot = ../.;};

    # Every package in uv.lock, from the wheels it pins where there are any.
    # The build-system overlay supplies the tools sdists build with.
    overlay = lib.composeManyExtensions [
      inputs.pyproject-build-systems.overlays.wheel
      (workspace.mkPyprojectOverlay {sourcePreference = "wheel";})
    ];
    baseSet = pkgs.callPackage inputs.pyproject-nix.build.packages {inherit python;};
    pythonSet = baseSet.overrideScope overlay;

    name = (lib.importTOML ../pyproject.toml).project.name;
  in {
    # Shared with nix/checks.nix and nix/devshell.nix.
    _module.args.uv2nix = {inherit python workspace pythonSet name;};

    packages = lib.mkIf (builtins.pathExists ../uv.lock) {
      # The project's runtime dependencies only, no dev group.
      default = pythonSet.mkVirtualEnv "${name}-env" workspace.deps.default;
    };
  };
}

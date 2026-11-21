{
  inputs,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}: let
    python = pkgs.python313;

    workspace = inputs.uv2nix.lib.workspace.loadWorkspace {workspaceRoot = ../.;};

    overlay = lib.composeManyExtensions [
      inputs.pyproject-build-systems.overlays.wheel
      (workspace.mkPyprojectOverlay {sourcePreference = "wheel";})
    ];
    baseSet = pkgs.callPackage inputs.pyproject-nix.build.packages {inherit python;};
    pythonSet = baseSet.overrideScope overlay;

    name = (lib.importTOML ../pyproject.toml).project.name;
  in {
    _module.args.uv2nix = {inherit python workspace pythonSet name;};

    packages = lib.mkIf (builtins.pathExists ../uv.lock) {
      default = pythonSet.mkVirtualEnv "${name}-env" workspace.deps.default;
    };
  };
}

{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  perSystem.treefmt = {
    projectRootFile = "flake.nix";

    programs = {
      alejandra.enable = true;
      deadnix.enable = true;
      ruff-format.enable = true;
      ruff-check.enable = true;
    };
  };
}

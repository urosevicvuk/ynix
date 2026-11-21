{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  perSystem.treefmt = {
    projectRootFile = "flake.nix";

    programs = {
      alejandra.enable = true;
      deadnix.enable = true;
      goimports.enable = true;
    };
  };
}

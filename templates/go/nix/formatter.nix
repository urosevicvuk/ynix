{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  # `nix fmt` formats the whole tree, and `nix flake check` fails on anything
  # left unformatted.
  perSystem.treefmt = {
    projectRootFile = "flake.nix";

    programs = {
      alejandra.enable = true;
      deadnix.enable = true; # unused nix bindings
      goimports.enable = true; # gofmt, plus sorting and pruning imports
    };
  };
}
